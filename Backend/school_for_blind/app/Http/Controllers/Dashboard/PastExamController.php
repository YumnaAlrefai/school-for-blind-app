<?php

namespace App\Http\Controllers\Dashboard;

use App\Http\Controllers\Controller;
use App\Models\PastExam;
use App\Models\Subject;
use App\Models\Question;
use App\Models\Teacher;
use App\Models\Choice;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;

class PastExamController extends Controller
{
    public function index(Request $request)
    {
        $query = PastExam::with('subject');

        if ($request->has('search') && $request->search != '') {
            $query->where('title', 'like', '%' . $request->search . '%');
        }

        if ($request->has('subject_id') && $request->subject_id != '') {
            $query->where('subject_id', $request->subject_id);
        }

        if ($request->has('year') && $request->year != '') {
            $query->where('year', $request->year);
        }

        $pastExams = $query->latest()->paginate(10);
        $subjects = Subject::all();

        return view('pages.past_exams.index', compact('pastExams', 'subjects'));
    }

    public function create()
    {
        $subjects = Subject::all();
        return view('pages.past_exams.create', compact('subjects'));
    }

    public function store(Request $request)
    {
        $request->validate([
            'title' => 'required|string|max:255',
            'subject_id' => 'required|exists:subjects,id',
            'year' => 'required|integer|min:2000|max:' . (date('Y') + 1),
            'session' => 'required|in:first,second,complementary',
            'voice_solution' => 'nullable|mimes:mp3,wav,aac,ogg|max:20480',
        ]);

        $data = $request->except('voice_solution');

        if ($request->hasFile('voice_solution')) {
            $path = $request->file('voice_solution')->store('past_exams/voice_solutions', 'public');
            $data['voice_solution_path'] = $path;
        }

        $data['is_published'] = false;

        PastExam::create($data);

        return redirect()->route('dashboard.past-exams.index')->with('success', 'تم إنشاء الدورة كمسودة بنجاح.');
    }

    public function show($id)
    {
        $pastExam = PastExam::with(['subject', 'questions.choices'])->findOrFail($id);

        $adminTeacher = Teacher::where('phone', '0000000000')->first();
        $bankQuestions = [];

        if ($adminTeacher) {
            $bankQuestions = Question::where('teacher_id', $adminTeacher->id)
                ->where('status', 'Bank')
                ->whereNotIn('id', $pastExam->questions->pluck('id'))
                ->get();
        }

        return view('pages.past_exams.show', compact('pastExam', 'bankQuestions'));
    }

    public function edit($id)
    {
        $pastExam = PastExam::findOrFail($id);
        $subjects = Subject::all();
        return view('pages.past_exams.edit', compact('pastExam', 'subjects'));
    }

    public function update(Request $request, $id)
    {
        $pastExam = PastExam::findOrFail($id);

        $request->validate([
            'title' => 'required|string|max:255',
            'subject_id' => 'required|exists:subjects,id',
            'year' => 'required|integer|min:2000|max:' . (date('Y') + 1),
            'session' => 'required|in:first,second,complementary',
            'voice_solution' => 'nullable|mimes:mp3,wav,aac,ogg|max:20480',
        ]);

        $data = $request->except('voice_solution');

        if ($request->hasFile('voice_solution')) {
            if ($pastExam->voice_solution_path && Storage::disk('public')->exists($pastExam->voice_solution_path)) {
                Storage::disk('public')->delete($pastExam->voice_solution_path);
            }
            $path = $request->file('voice_solution')->store('past_exams/voice_solutions', 'public');
            $data['voice_solution_path'] = $path;
        }

        $pastExam->update($data);

        return redirect()->route('dashboard.past-exams.index')->with('success', 'تم تحديث بيانات الدورة بنجاح.');
    }

    public function destroy($id)
    {
        $pastExam = PastExam::findOrFail($id);

        if ($pastExam->voice_solution_path && Storage::disk('public')->exists($pastExam->voice_solution_path)) {
            Storage::disk('public')->delete($pastExam->voice_solution_path);
        }

        $pastExam->delete();

        return redirect()->route('dashboard.past-exams.index')->with('success', 'تم حذف الدورة بنجاح.');
    }

    public function publish($id)
    {
        $pastExam = PastExam::findOrFail($id);
        $pastExam->update(['is_published' => true]);

        return redirect()->back()->with('success', 'تم نشر الدورة بنجاح وأصبحت متاحة للطلاب.');
    }

    public function storeQuestion(Request $request, $pastExamId)
    {
        $pastExam = PastExam::findOrFail($pastExamId);

        $request->validate([
            'type' => 'required|in:mcq,TF,TEXT',
            'description' => 'required|string',
            'points' => 'required|numeric|min:0',
            'correct_answer' => 'nullable|required_unless:type,mcq|string',
            'choices' => 'nullable|required_if:type,mcq|array|min:2',
            'choices.*.text' => 'nullable|required_if:type,mcq|string', 
            'correct_choice' => 'nullable|required_if:type,mcq|integer',
        ]);

        $adminTeacher = Teacher::where('phone', '0000000000')->first();

        if (!$adminTeacher) {
            return redirect()->back()->with('error', 'حساب أستاذ الإدارة غير موجود.');
        }

        DB::beginTransaction();
        try {
            $question = Question::create([
                'teacher_id' => $adminTeacher->id,
                'type' => $request->type,
                'description' => $request->description,
                'points' => $request->points,
                'correct_answer' => $request->type !== 'mcq' ? $request->correct_answer : null,
                'status' => 'publish',
            ]);

            if ($request->type === 'mcq' && $request->has('choices')) {
                foreach ($request->choices as $index => $choiceData) {
                    if (isset($choiceData['text'])) {
                        Choice::create([
                            'question_id' => $question->id,
                            'choice_text' => $choiceData['text'],
                            'is_correct' => $index == $request->correct_choice,
                        ]);
                    }
                }
            }

            $pastExam->questions()->attach($question->id);

            DB::commit();
            return redirect()->back()->with('success', 'تم إضافة السؤال التفاعلي بنجاح.');

        } catch (\Exception $e) {
            DB::rollBack();
            return redirect()->back()->with('error', 'حدث خطأ أثناء الحفظ: ' . $e->getMessage());
        }
    }

    public function attachQuestion(Request $request, $pastExamId)
    {
        $request->validate([
            'question_id' => 'required|exists:questions,id'
        ]);

        $pastExam = PastExam::findOrFail($pastExamId);

        if (!$pastExam->questions()->where('question_id', $request->question_id)->exists()) {
            $pastExam->questions()->attach($request->question_id);
        }

        return redirect()->back()->with('success', 'تم استيراد السؤال من بنك الأسئلة بنجاح.');
    }

    public function detachQuestion($pastExamId, $questionId)
    {
        $pastExam = PastExam::findOrFail($pastExamId);
        $pastExam->questions()->detach($questionId);

        return redirect()->back()->with('success', 'تم إزالة السؤال من هذه الدورة.');
    }
}
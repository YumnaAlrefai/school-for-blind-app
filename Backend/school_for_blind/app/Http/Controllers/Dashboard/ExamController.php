<?php

namespace App\Http\Controllers\Dashboard;

use App\Http\Controllers\Controller;
use App\Models\Exam;
use App\Models\Subject;
use App\Models\Question;
use App\Models\Teacher;
use App\Models\Choice;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class ExamController extends Controller
{
    public function index(Request $request)
    {
        $query = Exam::with('subject');

        if ($request->has('search') && $request->search != '') {
            $query->where('title', 'like', '%' . $request->search . '%');
        }

        if ($request->has('subject_id') && $request->subject_id != '') {
            $query->where('subject_id', $request->subject_id);
        }

        if ($request->has('status') && $request->status != '') {
            $isPublished = $request->status == 'published' ? 1 : 0;
            $query->where('is_published', $isPublished);
        }

        $exams = $query->latest('exam_date')->paginate(10);
        $subjects = Subject::all();

        return view('pages.exams.index', compact('exams', 'subjects'));
    }

    public function create()
    {
        $subjects = Subject::all();
        return view('pages.exams.create', compact('subjects'));
    }

    public function store(Request $request)
    {
        $request->validate([
            'title' => 'required|string|max:255',
            'description' => 'nullable|string',
            'subject_id' => 'required|exists:subjects,id',
            'exam_date' => 'required|date|after:now',
            'duration_minutes' => 'required|integer|min:5|max:300',
        ]);

        Exam::create([
            'title' => $request->title,
            'description' => $request->description,
            'subject_id' => $request->subject_id,
            'exam_date' => $request->exam_date,
            'duration_minutes' => $request->duration_minutes,
            'is_published' => false,
        ]);

        return redirect()->route('dashboard.exams.index')->with('success', 'تم إنشاء الامتحان كمسودة بنجاح.');
    }

    public function show($id)
    {
        $exam = Exam::with(['subject', 'questions.choices'])->findOrFail($id);

        $adminTeacher = Teacher::where('phone', '0000000000')->first();
        $bankQuestions = [];

        if ($adminTeacher) {
            $bankQuestions = Question::where('teacher_id', $adminTeacher->id)
                ->where('status', 'Bank')
                ->whereNotIn('id', $exam->questions->pluck('id'))
                ->get();
        }

        return view('pages.exams.show', compact('exam', 'bankQuestions'));
    }

    public function edit($id)
    {
        $exam = Exam::findOrFail($id);
        $subjects = Subject::all();
        return view('pages.exams.edit', compact('exam', 'subjects'));
    }

    public function update(Request $request, $id)
    {
        $exam = Exam::findOrFail($id);

        $request->validate([
            'title' => 'required|string|max:255',
            'description' => 'nullable|string',
            'subject_id' => 'required|exists:subjects,id',
            'exam_date' => 'required|date',
            'duration_minutes' => 'required|integer|min:5|max:300',
        ]);

        $exam->update($request->all());

        return redirect()->route('dashboard.exams.index')->with('success', 'تم تحديث بيانات الامتحان بنجاح.');
    }

    public function destroy($id)
    {
        $exam = Exam::findOrFail($id);
        $exam->questions()->detach();
        $exam->delete();

        return redirect()->route('dashboard.exams.index')->with('success', 'تم حذف الامتحان بنجاح.');
    }

    public function publish($id)
    {
        $exam = Exam::findOrFail($id);
        $exam->update(['is_published' => true]);

        return redirect()->back()->with('success', 'تم نشر الامتحان بنجاح.');
    }

    public function storeQuestion(Request $request, $examId)
    {
        $exam = Exam::findOrFail($examId);

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
            return redirect()->back()->with('error', 'حساب أستاذ الإدارة غير موجود، يرجى تشغيل الـ Seeder أولاً.');
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

            $exam->questions()->attach($question->id);

            DB::commit();
            return redirect()->back()->with('success', 'تم إضافة السؤال التفاعلي إلى الامتحان بنجاح.');

        } catch (\Exception $e) {
            DB::rollBack();
            return redirect()->back()->with('error', 'حدث خطأ أثناء إضافة السؤال: ' . $e->getMessage());
        }
    }

    public function attachQuestion(Request $request, $examId)
    {
        $request->validate([
            'question_id' => 'required|exists:questions,id'
        ]);

        $exam = Exam::findOrFail($examId);

        if (!$exam->questions()->where('question_id', $request->question_id)->exists()) {
            $exam->questions()->attach($request->question_id);
        }

        return redirect()->back()->with('success', 'تم استيراد السؤال من بنك الأسئلة بنجاح.');
    }

    public function detachQuestion($examId, $questionId)
    {
        $exam = Exam::findOrFail($examId);
        $exam->questions()->detach($questionId);

        return redirect()->back()->with('success', 'تم إزالة السؤال من الامتحان بنجاح.');
    }
}
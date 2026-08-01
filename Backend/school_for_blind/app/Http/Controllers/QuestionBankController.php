<?php

namespace App\Http\Controllers;

use App\Models\Question;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class QuestionBankController extends Controller
{
    public function index(Request $request)
    {
        $teacher_id = auth()->id();

        $questions = Question::with('choices')
            ->where('teacher_id', $teacher_id)
            ->when($request->type, function ($query, $type) {
                return $query->where('type', $type);
            })
            ->latest()
            ->paginate(20);

        return response()->json($questions);
    }

    public function store(Request $request)
    {
        $request->validate([
            'type' => 'required|in:mcq,TF,TEXT',
            'description' => 'required|string',
            'points' => 'nullable|numeric|min:0',
            'choices' => 'required_if:type,mcq|array|min:2',
            'choices.*.text' => 'required_with:choices|string',
            'choices.*.is_correct' => 'required_with:choices|boolean',
            'correct_answer' => 'required_unless:type,mcq|string',
        ]);

        DB::beginTransaction();
        try {
            $question = Question::create([
                'teacher_id' => auth()->id(),
                'type' => $request->type,
                'description' => $request->description,
                'correct_answer' => $request->type !== 'mcq' ? $request->correct_answer : null,
                'points' => $request->points ?? 1,
                'status' => 'Bank',
            ]);

            if ($request->type === 'mcq' && $request->has('choices')) {
                foreach ($request->choices as $choice) {
                    $question->choices()->create([
                        'choice_text' => $choice['text'],
                        'is_correct' => $choice['is_correct'] ?? false,
                    ]);
                }
            }

            DB::commit();
            $question->load('choices');

            return response()->json([
                'message' => 'تمت إضافة السؤال إلى البنك بنجاح!',
                'question' => $question
            ], 201);

        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'error' => 'حدث خطأ أثناء حفظ السؤال',
                'details' => $e->getMessage()
            ], 500);
        }
    }

    public function show($id)
    {
        $teacher_id = auth()->id();
        $question = Question::with('choices')
            ->where('teacher_id', $teacher_id)
            ->findOrFail($id);

        return response()->json($question);
    }

    public function destroy($id)
    {
        $teacher_id = auth()->id();
        $question = Question::where('teacher_id', $teacher_id)->findOrFail($id);

        $question->delete();

        return response()->json([
            'message' => 'تم حذف السؤال من البنك بنجاح!'
        ]);
    }
}

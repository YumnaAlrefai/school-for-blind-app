<?php

namespace App\Http\Controllers;

use App\Http\Resources\StudentQuestionResource;
use App\Http\Resources\StudentQuizInfoResource;
use App\Models\Quiz;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class StudentQuizController extends Controller
{
   public function getQuizInfoByNames(Request $request): JsonResponse
{
    $request->validate([
        'subject_name' => 'required|string',
        'teacher_name' => 'required|string',
        'lesson_name'  => 'required|string',
    ]);

    $quiz = Quiz::whereHas('subject', function ($query) use ($request) {
                    $query->where('name', $request->subject_name);
                })
                ->whereHas('teacher', function ($query) use ($request) {
                    $query->where('full_name', $request->teacher_name);
                })
                ->whereHas('lesson', function ($query) use ($request) {
                    $query->where('title', $request->lesson_name);
                })
                ->first();

    if (!$quiz) {
        return response()->json([
            'status' => 'error', 
            'message' => 'لم يتم العثور على كويز مطابق لهذه البيانات'
        ], 404);
    }

    
    return response()->json([
        'status' => 'success',
        'data' => [
            'quiz_id'          => $quiz->id, 
            'duration_minutes' => (int) $quiz->timelimit,
            'total_questions'  => (int) $quiz->numofquestions,
            'total_mark'       => (float) $quiz->totalmark,
        ]
    ]);
}
public function getQuizQuestions($id): JsonResponse
    {
        $quiz = Quiz::with(['questions.choices'])->find($id);

        if (!$quiz) {
            return response()->json(['status' => 'error', 'message' => 'الكويز غير موجود'], 404);
        }

        $questionsData = $quiz->questions->map(function ($question) {
            return new StudentQuestionResource($question, $question->pivot->question_number ?? 0);
        });

        return response()->json([
            'status' => 'success',
            'quiz_id' => $quiz->id,
            'questions' => $questionsData
        ]);
    }



}

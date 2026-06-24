<?php

namespace App\Http\Controllers;

use App\Http\Resources\StudentQuestionResource;
use App\Http\Resources\StudentQuizInfoResource;
use App\Models\Question;
use App\Models\Quiz;
use App\Models\QuizSubmission;
use App\Models\StudentAnswer;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class StudentQuizController extends Controller
{
   public function getQuizInfoByNames(Request $request): JsonResponse
{
    $request->validate([
      'subject_id' => 'required|integer|exists:subjects,id',
        'teacher_id' => 'required|integer|exists:teachers,id',
        'lesson_id'  => 'required|integer|exists:lessons,id',
    ]);

    $quiz = Quiz::whereHas('subject', function ($query) use ($request) {
                    $query->where('id', $request->subject_id);
                })
                ->whereHas('teacher', function ($query) use ($request) {
                    $query->where('id', $request->teacher_id);
                })
                ->whereHas('lesson', function ($query) use ($request) {
                    $query->where('id', $request->lesson_id);
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
            'total_mark'       => (int) $quiz->totalmark,
        ]
    ]);
}
public function getQuizQuestions($id): JsonResponse
    {
        $quiz = Quiz::with(['questions.choices'])->find($id);

        if (!$quiz) {
            return response()->json(['status' => 'error', 'message' => 'الكويز غير موجود'], 404);
        }
$questionsData = $quiz->questions->map(function ($question, $index) {
        $questionNumber = $index + 1;
        return new StudentQuestionResource($question, $questionNumber);
    });
        return response()->json([
            'status' => 'success',
            'quiz_id' => $quiz->id,
            'questions' => $questionsData
        ]);
    }
public function submitQuiz(Request $request): JsonResponse
{
    $request->validate([
        'quiz_id' => 'required|integer|exists:quizzes,id',
        'answers' => 'required|array',
        'answers.*.question_id' => 'required|integer|exists:questions,id',
        'answers.*.choice_id'   => 'nullable|integer|exists:choices,id',
        'answers.*.text_answer' => 'nullable|string', 
    ]);

    $studentId = 1; 
    
    DB::beginTransaction();
    try {
        $submission = QuizSubmission::create([
            'student_id'            => $studentId,
            'quiz_id'               => $request->quiz_id,
            'teacher_assigned_mark' => 0, 
            'total_score'           => 0, 
            'status'                => 'pending', 
        ]);

        $totalAutoScore = 0;
        $hasEssayQuestion = false;

        foreach ($request->answers as $answerData) {
            $question = Question::with('choices')->find($answerData['question_id']);
            
            $isCorrect = 0;
          $questionMarkEarned = 0.0;
            if ($question->type === 'mcq') {
                $correctChoice = $question->choices()->where('is_correct', true)->first();
                
                if ($correctChoice && $correctChoice->id == $answerData['choice_id']) {
                    $isCorrect = 1;
                    $questionMarkEarned = (float) $question->points; 
                }
            } 
            elseif ($question->type === 'TF') {
                if (trim($question->correct_answer) == trim($answerData['text_answer'])) {
                    $isCorrect = 1;
                    $questionMarkEarned = (float) $question->points; 
                }
            }
            elseif ($question->type === 'essay') {
                $hasEssayQuestion = true;
                $isCorrect = 0;
                $questionMarkEarned =0.0; 
            }

            $totalAutoScore += $questionMarkEarned ;

            StudentAnswer::create([
                'student_id'    => $studentId,
                'question_id'   => $question->id,
                'choice_id'     => $answerData['choice_id'] ?? null,
                'text_answer'   => $answerData['text_answer'] ?? null,
                'is_correct'    => $isCorrect,
              //  'points_earned' => $pointsEarned,
            ]);
        }

        $submission->total_score = $totalAutoScore;
        
        if (!$hasEssayQuestion) {
            $submission->status = 'graded';
        }
        
        $submission->save();

        DB::commit();

        return response()->json([
            'status' => 'success',
            'message' => 'تم تسليم الكويز بنجاح وتصحيح الأسئلة المؤتمتة تلقائياً!',
            'data' => [
                'submission_id' => $submission->id,
                'auto_score'    => $totalAutoScore,
                'status'        => $submission->status
            ]
        ]);

    } catch (\Exception $e) {
        DB::rollBack();
        return response()->json([
            'status' => 'error',
            'message' => 'حدث خطأ أثناء حفظ الإجابات: ' . $e->getMessage()
        ], 500);
    }
}


}

<?php

namespace App\Http\Controllers;

use App\Http\Requests\QuizInfoRequest;
use App\Http\Requests\SubmitQuizRequest;
use App\Http\Resources\StudentQuestionResource;
use App\Http\Resources\StudentQuizInfoResource;
use App\Models\Question;
use App\Models\Quiz;
use App\Models\QuizSubmission;
use App\Models\StudentAnswer;
use App\Traits\RecordUploadTrait;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth as FacadesAuth;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;

class StudentQuizController extends Controller
   {use RecordUploadTrait;
   

public function getQuizInfoByNames(QuizInfoRequest $request): JsonResponse
{
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
    $studentId = Auth::id(); 

    $alreadySolved = QuizSubmission::whereQuizId($quiz->id)
                                           ->whereStudentId($studentId)
                                           ->exists();

    if ($alreadySolved) {
        return response()->json([
            'status'  => 'error', 
            'message' => 'لقد قمت بإجراء هذا الاختبار مسبقاً ولا يمكن إعادته.'
        ], 403); 
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

public function submitQuiz(SubmitQuizRequest $request): JsonResponse
{
    $studentId = Auth::id();
        $existingSubmission = QuizSubmission::whereStudentId($studentId)
            ->whereQuizId($request->quiz_id)
            ->first();
        if ($existingSubmission) {
            return response()->json([
                'status' => 'error',
                'message' => 'عذراً، لقد قمت بتقديم هذا الاختبار مسبقاً ولا يمكنك إعادته.',
            ], 403);
        }

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

       foreach ($request->answers as $index => $answerData) {
            $question = Question::with('choices')->find($answerData['question_id']);
            
            $isCorrect = 0;
            $questionMarkEarned = 0.0;
            $audioPath = null; 

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
            elseif ($question->type === 'TEXT') {
                $hasEssayQuestion = true;
                $isCorrect = 0;
                $questionMarkEarned = 0.0; 
                
                if ($request->hasFile("answers.{$index}.audio_answer")) {
                    $file = $request->file("answers.{$index}.audio_answer");
                    $audioPath = $this->uploadRecord($file, 'student_audios'); 
                }
            }

            $totalAutoScore += $questionMarkEarned;
            StudentAnswer::create([
                'student_id'    => $studentId,
                'question_id'   => $question->id,
                'choice_id'     => $answerData['choice_id'] ?? null,
                'text_answer'   => $answerData['text_answer'] ?? null,
                'is_correct'    => $isCorrect,
                'audio_answer'  => $audioPath,
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
                'status'        => $submission->status,
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
public function getQuizReview($quizId): JsonResponse
{
    $studentId = Auth::id();
    $submission = QuizSubmission::whereStudentId($studentId)
                                ->whereQuizId($quizId)
                                ->first();

    if (!$submission) {
        return response()->json([
            'status' => 'error',
            'message' => 'عذراً، لا يمكنك عرض الإجابات لأنك لم تقم بحل هذا الاختبار بعد.'
        ], 403);
    }

    $quiz = Quiz::with('questions.choices')->find($quizId);
    
    if (!$quiz) {
        return response()->json(['status' => 'error', 'message' => 'الكويز غير موجود'], 404);
    }

    $questionIds = $quiz->questions->pluck('id')->all();

    $studentAnswers = StudentAnswer::query()
        ->where('student_id', $studentId)
        ->whereIn('question_id', $questionIds)
        ->get()
        ->keyBy('question_id');

    $questionsWithAnswers = $quiz->questions->map(function ($question) use ($studentAnswers) {
        $studentAnswer = $studentAnswers->get($question->id);
        $correctAnswerText = null;

        if ($question->type === 'mcq') {
            $correctChoice = $question->choices->where('is_correct', 1)->first();
            $correctAnswerText = $correctChoice ? $correctChoice->choice_text : null;
        } else {
            $correctAnswerText = $question->correct_answer;
        }

        return [
            'question_id'    => $question->id,
            'description'    => $question->description,
            'type'           => $question->type,
            'points'         => $question->points,
            'correct_answer' => $correctAnswerText, 
            'student_answer' => [                   
                'is_correct'  => $studentAnswer ? $studentAnswer->is_correct : 0,
                'text_answer' => $studentAnswer ? $studentAnswer->text_answer : null,
                'audio_path'  => $studentAnswer ? $studentAnswer->audio_answer : null, 
                'choice_text' => ($studentAnswer && $studentAnswer->choice_id && $question->type === 'mcq') 
                    ? $question->choices->where('id', $studentAnswer->choice_id)->first()->choice_text ?? null 
                    : null,
            ]
        ];
    });

    return response()->json([
        'status' => 'success',
        'data' => [
            'quiz_id'      => $quiz->id,
            'total_score'  => $submission->total_score,
            'status'       => $submission->status,
            'quiz_review'  => $questionsWithAnswers 
        ]
    ]);
}

}

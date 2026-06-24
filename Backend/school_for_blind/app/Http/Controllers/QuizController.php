<?php

namespace App\Http\Controllers;

use App\Models\Choice;
use App\Models\Lesson;
use App\Models\Question;
use App\Models\Quiz;
use App\Models\QuizSubmission;
use App\Models\StudentAnswer;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class QuizController extends Controller
{
    public function store(Request $request)
    {
        $request->validate([
            // 'title' => 'required|string|min:1',
            'numofquestions' => 'required|integer|min:1',
            'timelimit' => 'required|integer|min:1',
            'totalmark' => 'required|integer|min:1',
            // 'subject_id' => 'required|exists:subjects,id',
            'question_ids' => 'nullable|array',
            'question_ids.*' => 'exists:questions,id',
            'lesson_id' => 'required|exists:lessons,id',
            'questions' => 'required|array|min:1',
            'questions.*.type' => 'required|in:mcq,TF,TEXT',
            'questions.*.description' => 'required|string',
            'questions.*.points' => 'nullable|numeric|min:0',
            'questions.*.choices' => 'required_if:questions.*.type,mcq|array|min:2',
            'questions.*.choices.*.text' => 'required_with:questions.*.choices|string',
            'questions.*.choices.*.is_correct' => 'required_with:questions.*.choices|boolean',
            'questions.*.correct_answer' => 'required_unless:questions.*.type,mcq|string',
        ]);

        DB::beginTransaction();

        $lesson = Lesson::find($request->lesson_id);

        if ($lesson->quiz != null) {
            return response()->json([
                'message' => 'سبق و تم انشاء كويز لهذا الدرس!',
                'quiz' => $lesson->quiz,
            ], 409);
        }

        try {
            $quiz = Quiz::create([
                // 'title'=> $request->title,
                'numofquestions' => $request->numofquestions,
                'timelimit' => $request->timelimit,
                'totalmark' => $request->totalmark,
                'subject_id' => $lesson->subject_id,
                'lesson_id' => $request->lesson_id,
                'teacher_id' => auth()->id(),
            ]);


            $lesson->quiz_id = $quiz->id;
            $lesson->save();

            if ($request->has('question_ids') && !empty($request->question_ids)) {
                $quiz->questions()->attach($request->question_ids);
            }

            if ($request->has('questions') && !empty($request->questions)) {
                foreach ($request->questions as $q) {
                    $question = Question::create([
                        'teacher_id' => auth()->id(),
                        'type' => $q['type'],
                        'description' => $q['description'],
                        'correct_answer' => $q['type'] !== 'mcq' ? $q['correct_answer'] : null,
                        'points' => $q['points'] ?? 1,
                        'status' => $q['status'] ?? 'publish',
                    ]);

                    if ($q['type'] === 'mcq' && isset($q['choices'])) {
                        foreach ($q['choices'] as $choice) {
                            $question->choices()->create([
                                'choice_text' => $choice['text'],
                                'is_correct' => $choice['is_correct'] ?? false,
                            ]);
                        }
                    }
                    $quiz->questions()->attach($question->id);
                }
            }

            DB::commit();
            $quiz->load('questions.choices');

            return response()->json([
                'message' => 'تم إنشاء الكويز بنجاح!',
                'quiz' => $quiz
            ], 201);

        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'error' => 'حدث خطأ أثناء الحفظ',
                'details' => $e->getMessage()
            ], 500);
        }
    }

    public function index()
    {
        $teacher_id = auth()->id();
        $quizzes = Quiz::with('subject')
            ->where('teacher_id', $teacher_id)
            ->paginate(20);
        return response()->json($quizzes);
    }

    public function show($id)
    {
        $quiz = Quiz::with(['questions.choices', 'subject'])->findOrFail($id);
        return response()->json($quiz);
    }

    public function getStudentQuiz($id)
    {
        $quiz = Quiz::with(['questions.choices', 'subject'])->findOrFail($id);
        $questions = $quiz->questions;

        $data = [
            'TF' => $this->chunkQuestionsByType($questions, 'TF'),
            'mcq' => $this->chunkQuestionsByType($questions, 'mcq'),
            'TEXT' => $this->chunkQuestionsByType($questions, 'TEXT'),
        ];

        return response()->json([
            'quiz_details' => $quiz->only(['id', 'numofquestions', 'timelimit', 'totalmark', 'subject_id', 'subject_name']),
            'data' => $data
        ]);
    }

    private function chunkQuestionsByType($questions, $type)
    {
        return $questions->where('type', $type)
            ->values()
            ->chunk(3)
            ->map(function ($chunk) {
                return $chunk->values();
            })
            ->values();
    }

    public function update(Request $request, $id)
    {
        $quiz = Quiz::findOrFail($id);
        $request->validate([
            // 'title' => 'sometimes|string|min:1',
            'numofquestions' => 'sometimes|integer|min:1',
            'timelimit' => 'sometimes|integer|min:1',
            'totalmark' => 'sometimes|integer|min:1',
        ]);

        $quiz->update($request->only(['numofquestions', 'timelimit', 'totalmark']));
        // $quiz->save();

        return response()->json([
            'message' => 'تم تعديل الكويز بنجاح!',
            'quiz' => $quiz
        ]);
    }

    public function destroy($id)
    {
        $quiz = Quiz::findOrFail($id);
        $quiz->delete();
        return response()->json(['message' => 'تم حذف الكويز!']);
    }

    public function submitQuiz(Request $request, $id)
    {
        $request->validate([
            'answers' => 'required|array',
            'answers.*.question_id' => 'required|exists:questions,id',
            'answers.*.type' => 'required|in:mcq,TF,TEXT',
            'answers.*.choice_id' => 'required_if:answers.*.type,mcq|nullable|exists:choices,id',
            'answers.*.text_answer' => 'required_unless:answers.*.type,mcq|nullable|string',
        ]);
        $student_id = auth()->id() ?? 1;
        $quiz = Quiz::findOrFail($id);
        $existingSubmission = QuizSubmission::where('student_id', $student_id)
            ->where('quiz_id', $quiz->id)
            ->first();
        if ($existingSubmission) {
            return response()->json([
                'error' => 'عذراً، لقد قمت بتسليم هذا الكويز مسبقاً.'
            ], 400);
        }
        DB::beginTransaction();
        try {
            $totalScore = 0;
            foreach ($request->answers as $answerData) {
                $question = Question::find($answerData['question_id']);
                $isCorrect = false;
                $pointsEarned = 0;

                if ($answerData['type'] === 'mcq') {
                    if (isset($answerData['choice_id'])) {
                        $choice = Choice::find($answerData['choice_id']);
                        if ($choice && $choice->is_correct) {
                            $isCorrect = true;
                        }
                    }
                } else {
                    if (
                        isset($answerData['text_answer']) &&
                        strcasecmp(trim($answerData['text_answer']), trim($question->correct_answer)) === 0
                    ) {
                        $isCorrect = true;
                    }
                }

                if ($isCorrect) {
                    $pointsEarned = $question->points;
                    $totalScore += $pointsEarned;
                }

                StudentAnswer::create([
                    'student_id' => $student_id,
                    'question_id' => $question->id,
                    'choice_id' => $answerData['type'] === 'mcq' ? $answerData['choice_id'] : null,
                    'text_answer' => $answerData['type'] !== 'mcq' ? $answerData['text_answer'] : null,
                    'is_correct' => $isCorrect,
                    'points_earned' => $pointsEarned,
                ]);
            }

            $submission = QuizSubmission::create([
                'student_id' => $student_id,
                'quiz_id' => $quiz->id,
                'score' => $totalScore,
            ]);
            DB::commit();
            return response()->json([
                'message' => 'تم تسليم الكويز وتصحيحه بنجاح!',
                'score' => $totalScore,
                'total_mark' => $quiz->totalmark,
                'submission_details' => $submission
            ], 201);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'error' => 'حدث خطأ أثناء حفظ الإجابات',
                'details' => $e->getMessage()
            ], 500);
        }
    }

    public function getStudentAnswers($quizId, $studentId)
    {
        $submission = QuizSubmission::where('quiz_id', $quizId)
            ->where('student_id', $studentId)
            ->first();

        if (!$submission) {
            return response()->json([
                'message' => 'هذا الطالب لم يقم بحل هذا الكويز بعد.'
            ], 404);
        }

        $answers = StudentAnswer::where('student_id', $studentId)
            ->whereHas('question.quizzes', function ($query) use ($quizId) {
                $query->where('quizzes.id', $quizId);
            })
            ->with(['question.choices', 'choice'])
            ->get();

        return response()->json([
            'quiz_id' => (int) $quizId,
            'student_id' => (int) $studentId,
            'total_score' => $submission->score,
            'submitted_at' => $submission->created_at,
            'answers' => $answers
        ]);
    }

    public function getQuizByLesson($lessonId)
    {
        $quiz = Quiz::with(['questions.choices', 'subject'])
            ->where('lesson_id', $lessonId)
            ->first();

        if (!$quiz) {
            return response()->json([
                'message' => 'لا يوجد كويز مرتبط بهذا الدرس حالياً.'
            ], 404);
        }

        $questions = $quiz->questions;

        $data = [
            'TF' => $this->chunkQuestionsByType($questions, 'TF'),
            'mcq' => $this->chunkQuestionsByType($questions, 'mcq'),
            'TEXT' => $this->chunkQuestionsByType($questions, 'TEXT'),
        ];

        return response()->json([
            'message' => 'تم جلب الكويز بنجاح',
            'quiz_details' => $quiz->only(['id', 'numofquestions', 'timelimit', 'totalmark', 'subject_id', 'subject_name', 'lesson_id']),
            'data' => $data
        ]);
    }
}
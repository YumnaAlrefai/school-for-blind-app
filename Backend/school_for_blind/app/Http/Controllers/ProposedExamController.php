<?php
namespace App\Http\Controllers\Api\Teacher;

use App\Http\Controllers\Controller;
use App\Models\Exam;
use App\Models\Question;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Models\ExamSubmission;
use App\Models\StudentAnswer;

class ProposedExamController extends Controller
{
    public function store(Request $request)
    {
        $request->validate([
            'title' => 'required|string|max:255',
            'description' => 'nullable|string',
            'subject_id' => 'required|exists:subjects,id',
            'duration_minutes' => 'required|integer|min:5',
            'questions' => 'required|array|min:1',
            'questions.*.type' => 'required|in:mcq,TF,TEXT',
            'questions.*.description' => 'required|string',
            'questions.*.points' => 'nullable|numeric|min:0',
            'questions.*.correct_answer' => 'nullable|required_unless:questions.*.type,mcq|string',
            'questions.*.choices' => 'nullable|required_if:questions.*.type,mcq|array|min:2|max:10',
            'questions.*.choices.*.text' => 'nullable|required_with:questions.*.choices|string',
            'questions.*.choices.*.is_correct' => 'nullable|required_with:questions.*.choices|boolean',
        ]);

        DB::beginTransaction();

        try {
            $exam = Exam::create([
                'title' => $request->title,
                'description' => $request->description,
                'subject_id' => $request->subject_id,
                'exam_date' => null,
                'duration_minutes' => $request->duration_minutes,
                'is_published' => false,
            ]);

            if ($request->has('questions') && !empty($request->questions)) {
                foreach ($request->questions as $q) {
                    $question = Question::create([
                        'teacher_id' => auth()->id(),
                        'type' => $q['type'],
                        'description' => $q['description'],
                        'correct_answer' => $q['type'] !== 'mcq' ? $q['correct_answer'] : null,
                        'points' => $q['points'] ?? 1,
                        'status' => 'publish',
                    ]);

                    if ($q['type'] === 'mcq' && isset($q['choices'])) {
                        foreach ($q['choices'] as $choice) {
                            $question->choices()->create([
                                'choice_text' => $choice['text'],
                                'is_correct' => $choice['is_correct'] ?? false,
                            ]);
                        }
                    }
                    $exam->questions()->attach($question->id);
                }
            }

            DB::commit();

            return response()->json([
                'message' => 'تم رفع مقترح الامتحان كمسودة بنجاح.',
                'data' => $exam->load('questions.choices')
            ], 201);

        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'error' => 'حدث خطأ أثناء حفظ الامتحان',
                'details' => $e->getMessage()
            ], 500);
        }
    }

    public function gradeExamTextAnswers(Request $request, $examId, $studentId)
    {
        $request->validate([
            'grades' => 'required|array',
            'grades.*.answer_id' => 'required|exists:student_answers,id',
            'grades.*.points' => 'required|numeric|min:0',
        ]);

        $submission = ExamSubmission::where('exam_id', $examId)
            ->where('student_id', $studentId)
            ->first();

        if (!$submission) {
            return response()->json([
                'error' => 'لم يتم العثور على تسليم لهذا الطالب في هذا الامتحان.'
            ], 404);
        }

        DB::beginTransaction();
        try {
            foreach ($request->grades as $gradeData) {
                $studentAnswer = StudentAnswer::with('question')
                    ->where('id', $gradeData['answer_id'])
                    ->where('student_id', $studentId)
                    ->first();

                if ($studentAnswer) {
                    $maxPoints = $studentAnswer->question->points;

                    if ($gradeData['points'] > $maxPoints) {
                        DB::rollBack();
                        return response()->json([
                            'error' => "عذراً، لا يمكن إعطاء علامة ({$gradeData['points']}) أكبر من علامة السؤال الأصلية وهي ({$maxPoints}).",
                            'answer_id' => $gradeData['answer_id']
                        ], 400);
                    }

                    $studentAnswer->points_earned = $gradeData['points'];
                    $studentAnswer->is_correct = $gradeData['points'] > 0;
                    $studentAnswer->save();
                }
            }

            $newTotalScore = StudentAnswer::where('student_id', $studentId)
                ->whereHas('question.exams', function ($query) use ($examId) {
                    $query->where('exams.id', $examId); // نفترض أن العلاقة بين الأسئلة والامتحانات اسمها exams
                })
                ->sum('points_earned');

            $submission->score = $newTotalScore;
            $submission->status = 'pending_approval';
            $submission->save();

            DB::commit();

            return response()->json([
                'message' => 'تم رصد العلامات بنجاح وإرسالها للإدارة للموافقة عليها الاعتماد النهائي!',
                'new_total_score' => $newTotalScore,
                'status' => 'pending_approval'
            ], 200);

        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'error' => 'حدث خطأ أثناء حفظ العلامات',
                'details' => $e->getMessage()
            ], 500);
        }
    }
}
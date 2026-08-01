<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Http\Requests\IndexLessonRequest;
use App\Http\Requests\StoreLessonRequest;
use App\Http\Requests\UpdateLessonRequest;
use App\Models\Classes;
use App\Models\Lesson;
use App\Models\QuizSubmission;
use App\Models\Student;
use App\Models\Subject;
use App\Models\Teacher;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Gate;
use Illuminate\Support\Facades\DB;

class LessonController extends Controller
{
    public function store(StoreLessonRequest $request)
    {
        $subject = Subject::findOrFail($request->subject_id);
        $class = Classes::findOrFail($request->class_id);

        Gate::authorize('create', [Lesson::class, $subject, $class]);

        $lesson = Lesson::create([
            'title' => $request->title,
            'subject_id' => $subject->id,
            'teacher_id' => $request->user()->id,
            'class_id' => $request->class_id,
        ]);

        if ($request->hasFile('audio_file')) {
            $path = $request->file('audio_file')->store('lessons', 'public');

            $lesson->records()->create([
                'record_path' => $path,
                'record_mime' => $request->file('audio_file')->getMimeType(),
                'duration' => $request->duration,
            ]);
        }

        return response()->json([
            'message' => 'تم رفع الدرس والتسجيل بنجاح.',
            'lesson' => $lesson->load('records')
        ], 201);
    }

    public function update(UpdateLessonRequest $request, Lesson $lesson)
    {
        Gate::authorize('update', $lesson);

        $lesson->update($request->only(['title', 'class_id']));

        if ($request->hasFile('audio_file')) {
            if ($lesson->records()->count() >= 10) {
                return response()->json([
                    'message' => 'عذراً، لا يمكن إضافة أكثر من 10 تسجيلات للدرس الواحد.'
                ], 400);
            }

            $path = $request->file('audio_file')->store('lessons', 'public');

            $lesson->records()->create([
                'record_path' => $path,
                'record_mime' => $request->file('audio_file')->getMimeType(),
                'duration' => $request->duration,
            ]);
        }

        return response()->json([
            'message' => 'تم تعديل الدرس بنجاح.',
            'lesson' => $lesson->load('records')
        ], 200);
    }

    public function index(IndexLessonRequest $request)
    {
        $perPage = $request->input('per_page', 15);
        $user = $request->user();

        $query = Lesson::with(['subject', 'teacher', 'records']);

        if ($request->has('subject_id')) {
            $query->where('subject_id', $request->subject_id);
        }

        if ($user instanceof Student) {
            $query->where('class_id', $user->class_id);

        } elseif ($user instanceof Teacher && $request->has('teacher_id')) {
            $query->where('teacher_id', $request->teacher_id);
        }

        $lessons = $query->orderBy('created_at', 'desc')->get();
        //->paginate($perPage);

        return response()->json([
            'lessons' => $lessons
        ], 200);
    }

    public function show(Lesson $lesson, Request $request)
    {
        $lesson->load(['subject', 'teacher', 'records']);

        return response()->json([
            'lesson' => $lesson
        ], 200);
    }

    public function destroy(Lesson $lesson, Request $request)
    {
        Gate::authorize('delete', $lesson);

        if ($lesson->records()->exists()) {
            $lesson->records()->delete();
        }

        $lesson->delete();

        return response()->json([
            'message' => 'تم حذف الدرس والتسجيل بنجاح.'
        ], 200);
    }
    // ==============================================================================================================================================================================================================================================================================================================================
   
    public function getLessonsBySubject($subjectId)
    {    $studentId = Auth::id();
        $lessons = Lesson::with('teacher:id,full_name', 'quiz:id,lesson_id')->where('subject_id', $subjectId)
            //  ->with('record') 
            ->withExists([
            'favorites as is_favorited' => function ($query) use ($studentId) {
                $query->where('user_id', $studentId); 
            }
        ])
        ->get();
          $quizIds = $lessons->pluck('quiz.id')->filter();

    $solvedQuizIds = DB::table('quiz_submissions')
        ->where('student_id', $studentId)
        ->whereIn('quiz_id', $quizIds)
        ->pluck('quiz_id')
        ->toArray();

    $formattedLessons = $lessons->map(function ($lesson) use ($solvedQuizIds) {
        $data = $lesson->toArray();

        $data['teacher_name'] = $lesson->teacher->full_name ?? 'غير معروف';
        unset($data['teacher']);
        $data['is_favorited'] = $lesson->is_favorited;

        $data['is_quiz_solved'] = false; 
        if ($lesson->quiz) {
            $data['is_quiz_solved'] = in_array($lesson->quiz->id, $solvedQuizIds);
        }

        unset($data['quiz']); 
        

        return $data;
    });

    return response()->json([
        'subject_id' => $subjectId,
        'lessons'    => $formattedLessons
    ]);
}
    public function getLessonRecord($lessonId)
    {
        $lesson = Lesson::with('records')->find($lessonId);

        if (!$lesson) {
            return response()->json([
                'message' => 'Lesson not found'
            ], 404);
        }

        return response()->json([
            'lesson_id' => $lessonId,
            'record' => $lesson->records
        ]);
    }
    public function getLessonsCountBySubject($subjectId)
    {
        $count = Lesson::where('subject_id', $subjectId)->count();

        return response()->json([
            'subject_id' => $subjectId,
            'lessons_count' => $count
        ]);
    }
    public function getLessonsProgress($subjectId)
    {
        $currentCount = Lesson::where('subject_id', $subjectId)->count();

        $subject = Subject::find($subjectId);

        if (!$subject) {
            return response()->json([
                'message' => 'Subject not found'
            ], 404);
        }

        return response()->json([
            'subject_id' => $subjectId,
            'current_lessons' => $currentCount,
            'total_lessons' => $subject->total_lessons,
            'progress_text' => $currentCount . ' / ' . $subject->total_lessons
        ]);
    }

}

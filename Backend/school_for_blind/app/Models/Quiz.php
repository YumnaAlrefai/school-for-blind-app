<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Laravel\Reverb\Loggers\Log;
use Spatie\Activitylog\LogOptions;
use Spatie\Activitylog\Traits\LogsActivity;
use Spatie\Activitylog\Models\Activity;
class Quiz extends Model
{
    use LogsActivity;

    protected $guarded = [];

    public function lesson()
    {
        return $this->belongsTo(Lesson::class, 'lesson_id');
    }

    public function teacher()
    {
        return $this->belongsTo(Teacher::class, 'teacher_id');
    }

    public function subject()
    {
        return $this->belongsTo(Subject::class, 'subject_id');
    }

    public function questions()
    {
        return $this->belongsToMany(Question::class);
    }
    
    public function submissions()
    {
        return $this->hasMany(QuizSubmission::class);
    }

    protected $appends = ['subject_name', 'teacher_name'];

    public function getSubjectNameAttribute()
    {
        return $this->subject->name ?? null;
    }
    public function getTeacherNameAttribute()
    {
        return $this->teacher->full_name ?? null;
    }

    public function getActivitylogOptions(): LogOptions
    {
        return LogOptions::defaults()
            ->logOnly([
                'title',
                'numofquestions',
                'timelimit',
                'totalmark',
                'subject_id',
                'lesson_id',
                'teacher_id',
            ])
            ->logOnlyDirty()
            ->dontSubmitEmptyLogs();
    }

    public function tapActivity(Activity $activity, string $eventName)
    {
        Log::info($this->subject);
        $customInfo = [
            'lesson_name' => $this->lesson->title ?? 'غير محدد',
            'subject_name' => $this->subject->name ?? 'غير محدد',
            'teacher_name' => $this->teacher->full_name ?? 'غير محدد',
            'quiz_title' => $this->title,
        ];

        $activity->properties = $activity->properties->put('custom_info', $customInfo);
    }
public function favorites()
{
    return $this->morphMany(Favorite::class, 'favorable');
}



    }
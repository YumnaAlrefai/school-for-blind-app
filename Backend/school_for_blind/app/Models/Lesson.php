<?php

namespace App\Models;

use App\Models\Record;
use App\Models\Subject;
use App\Models\Teacher;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Spatie\Activitylog\LogOptions;
use Spatie\Activitylog\Traits\LogsActivity;
use Spatie\Activitylog\Models\Activity;

class Lesson extends Model
{
    use SoftDeletes;
    use LogsActivity;


    protected $guarded = [];
    public function subject()
    {
        return $this->belongsTo(Subject::class);
    }

    public function teacher()
    {
        return $this->belongsTo(Teacher::class);
    }

    public function quiz()
    {
        return $this->hasOne(Quiz::class);
    }

    public function record()
    {
        return $this->morphOne(Record::class, 'recordable');
    }

    public function class(){
        return $this->belongsTo(Classes::class);
    }

    public function getActivitylogOptions(): LogOptions
    {
        return LogOptions::defaults()
            ->logOnly([
                'title',
                'subject_id',
                'teacher_id',
                'class_id',
                // 'order',
            ])
            ->logOnlyDirty()
            ->dontSubmitEmptyLogs();
    }

    public function tapActivity(Activity $activity, string $eventName)
    {
        $customInfo = [
            'lesson_title' => $this->title,
            'subject_name' => $this->subject->name ?? 'غير محدد',
            'teacher_name' => $this->teacher->full_name ?? 'غير محدد',
            // ملاحظة: كلمة class محجوزة بالـ PHP، لذلك غالباً علاقتك رح يكون اسمها مختلف (مثلاً classroom أو schoolClass)
            // تأكد من تغييرها لتطابق اسم العلاقة عندك في المودل
            'class_name' => $this->class->name ?? 'غير محدد',
            'class_level' => $this->class->level ?? 'غير محدد',
        ];

        $activity->properties = $activity->properties->put('custom_info', $customInfo);
    }


public function favorites()
{
    return $this->morphMany(Favorite::class, 'favorable');
}



    }
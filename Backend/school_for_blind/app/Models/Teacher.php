<?php

namespace App\Models;

use App\Models\Subject;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;
use Illuminate\Foundation\Auth\User as Authenticatable;

class Teacher extends Authenticatable
{
    /** @use HasFactory<\Database\Factories\TeacherFactory> */
    use HasFactory, Notifiable, HasApiTokens;

    public function subjects()
    {
        return $this->belongsToMany(Subject::class, 'teacher_subjects')
            ->withPivot('price_for_lesson')
            ->withTimestamps();
    }

    public function classes()
    {
        return $this->belongsToMany(Classes::class, 'class_teacher', 'teacher_id', 'class_id');
    }

    protected $guarded = [];

    protected $hidden = [
        'password',
        'remember_token',
        'fcm_token',
        // 'cv_path',
    ];
public function donations()
{
    return $this->morphMany(Donation::class, 'donatable');
}
 public function deviceTokens()
{
    return $this->morphMany(DeviceToken::class, 'tokenable');
}   
protected static function booted()
    {
        static::deleting(function ($teacher) {
            $teacher->deviceTokens()->delete();
            $teacher->notifications()->delete();
        });
    }
public function notifications()
{
    return $this->morphMany(Notification::class, 'notifiable');
}

}


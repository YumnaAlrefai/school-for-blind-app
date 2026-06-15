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

    public function subject()
    {
        return $this->belongsToMany(Subject::class, 'teacher_subjects')
            ->withPivot('price')
            ->withTimestamps();
        ;
    }

    public function classes()
    {
        return $this->belongsToMany(Classes::class, 'class_teacher', 'teacher_id', 'class_id');
    }

    public function subjects(): \Illuminate\Database\Eloquent\Relations\BelongsToMany
    {
        return $this->belongsToMany(Subject::class, 'teacher_subjects');
    }

    protected $guarded = [];

    protected $hidden = [
        'password',
        'remember_token',
        'fcm_token',
        // 'cv_path',
    ];

}

<?php

namespace App\Models;

use App\Models\Quiz;
use App\Models\Teacher;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Subject extends Model
{
    use SoftDeletes;
    protected $guarded = [];
    public function quizzes()
    {
        return $this->hasMany(Quiz::class);
    }
    public function teachers()
    {
        return $this->belongsToMany(Teacher::class, 'teacher_subjects', 'subject_id', 'teacher_id');
    }

    public function lessons()
    {
        return $this->hasMany(Lesson::class);
    }
}
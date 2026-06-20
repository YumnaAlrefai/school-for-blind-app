<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class QuizSubmission extends Model
{
    protected $fillable = ['student_id', 'quiz_id', 'teacher_assigned_mark', 'total_score', 'status'];

    public function student()
    {
        return $this->belongsTo(Student::class);
    }

    public function quiz()
    {
        return $this->belongsTo(Quiz::class);
    }
}
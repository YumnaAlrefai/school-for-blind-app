<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Question extends Model
{
    protected $fillable = ['quiz_id', 'type', 'description', 'correct_answer', 'points', 'status'];

    public function teacher()
    {
        return $this->belongsTo(User::class, 'teacher_id');
    }

    public function quizzes()
    {
        return $this->belongsToMany(Quiz::class);
    }

    public function choices()
    {
        return $this->hasMany(Choice::class);
    }
}

<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Quiz extends Model
{
    protected $guarded = [];

    public function questions()
    {
        return $this->hasMany(Question::class);
    }
    public function submissions()
    {
        return $this->hasMany(QuizSubmission::class);
    }

    public function subject()
    {
        return $this->belongsTo(Subject::class, 'subject_id');
    }

    protected $appends = ['subject_name'];

    public function getSubjectNameAttribute()
    {
        return $this->subject->name ?? null;
    }

}

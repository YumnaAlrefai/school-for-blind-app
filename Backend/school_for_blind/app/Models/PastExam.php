<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;

class PastExam extends Model
{
 protected $table = 'past_exams';

 protected $guarded = [];

 public function subject(): BelongsTo
 {
  return $this->belongsTo(Subject::class, 'subject_id');
 }

 public function questions(): BelongsToMany
 {
  return $this->belongsToMany(Question::class, 'past_exam_question', 'past_exam_id', 'question_id')
   ->withTimestamps();
 }
}
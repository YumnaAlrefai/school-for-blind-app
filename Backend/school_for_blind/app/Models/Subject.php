<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Subject extends Model
{
    /** @use HasFactory<\Database\Factories\SubjectFactory> */
    use HasFactory;
    public function subject()
    {
        return $this->belongsToMany(Teacher::class, 'teacher_subjects')
            ->withPivot('price')
            ->withTimestamps();
        ;
    }

    protected $guarded = [];
}

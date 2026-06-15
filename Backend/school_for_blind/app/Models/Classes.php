<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Classes extends Model
{
    protected $fillable = [
        'name',
        'level',
        'number',
    ];

    public function students()
    {
        return $this->hasMany(Student::class);
    }


    public function teachers()
    {
        return $this->belongsToMany(Teacher::class, 'class_teacher', 'class_id', 'teacher_id');
    }

    public function rooms()
    {
        return $this->hasMany(Room::class, 'class_id');
    }
}

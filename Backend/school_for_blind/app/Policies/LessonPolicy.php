<?php

namespace App\Policies;

use App\Models\Classes;
use App\Models\Lesson;
use App\Models\Subject;
use App\Models\Admin;
use App\Models\Teacher;
use Illuminate\Contracts\Auth\Authenticatable;

class LessonPolicy
{
    public function before(Authenticatable $user, string $ability): bool|null
    {
        if ($user instanceof Admin && $user->role_id == 1) {
            return true;
        }

        return null;
    }

    public function create(Authenticatable $user, Subject $subject, Classes $class): bool
    {
       
        if ($user instanceof Teacher) {
            return $user->subjects()->where('subject_id', $subject->id)->exists() &&
                $user->classes()->where('class_id', $class->id)->exists();
        }

        return false;
    }

    public function update(Authenticatable $user, Lesson $lesson): bool
    {
        if ($user instanceof Teacher) {
            return $user->id === $lesson->teacher_id;
        }

        return false;
    }

    public function delete(Authenticatable $user, Lesson $lesson): bool
    {
        if ($user instanceof Teacher) {
            return $user->id === $lesson->teacher_id;
        }

        return false;
    }
}
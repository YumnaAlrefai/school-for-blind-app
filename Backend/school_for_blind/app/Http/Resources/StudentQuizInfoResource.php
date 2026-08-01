<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class StudentQuizInfoResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
return [
            'id' => $this->id,
            'subject_name' => $this->subject_name, 
            'teacher_name' => $this->teacher_name,
            'lesson_name' => $this->lesson->title ?? ($this->lesson->name ?? 'غير محدد'), 
            'duration_minutes' => (int) $this->timelimit,
            'total_questions' => (int) $this->numofquestions,
            'total_mark' => (float) $this->totalmark,
        ];    }
}

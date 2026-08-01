<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class StudentQuestionResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */

    protected $questionNumber;
  public function __construct($resource, $index = 0)
    {
        parent::__construct($resource);
        $this->questionNumber = $index ; 
    }
  
  
   public function toArray(Request $request): array
    {
        return [
            'question_number' => $this->questionNumber,
            'id' => $this->id,
            'type' => $this->type, 
            'text' => $this->description,
            'mark' => (float) $this->points,
        'choices' => $this->when($this->type === 'mcq', function() {
            return $this->choices->map(function($choice) {
                return [
                    'id'          => $choice->id,
                    'choice_text' => $choice->choice_text
                ];
            });
        }),
    ];
}
}
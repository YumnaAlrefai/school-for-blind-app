<?php

namespace App\Http\Requests;

use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Foundation\Http\FormRequest;

class StoreAnnouncementRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, ValidationRule|array<mixed>|string>
     */
   public function rules(): array
    {
        $type = $this->input('type');

        $rules = [
            'type'            => 'required|in:normal,exam_schedule',
            'title'           => 'required_if:type,exam_schedule|string|max:255',
            'target_audience' => 'required|in:student,parent,teacher',
            'level'           => 'required_if:target_audience,student|required_if:target_audience,parent|in:ninth,twelfth,all',
        ];

        $rules['content'] = $type === 'exam_schedule' ? 'required|array' : 'required|string';

        return $rules;
    }
    public function messages(): array
    {
        return [
            'type.required' => 'نوع الإعلان مطلوب.',
            'type.in' => 'نوع الإعلان يجب أن يكون إما "normal" أو "exam_schedule".',
            'content.required' => 'محتوى الإعلان مطلوب.',
            'content.array' => 'محتوى الإعلان يجب أن يكون مصفوفة إذا كان نوعه "exam_schedule".',
            'title.required_if' => 'العنوان مطلوب إذا كان نوع الإعلان "exam_schedule".',
            'title.string' => 'العنوان يجب أن يكون نصًا.',
            'title.max' => 'العنوان يجب ألا يزيد عن 255 حرفًا.',
            'target_audience.required' => 'الجمهور المستهدف مطلوب.',
            'target_audience.in' => 'الجمهور المستهدف يجب أن يكون إما "student" أو "parent" أو "teacher".',
            'level.required_if' => 'المستوى مطلوب إذا كان الجمهور المستهدف "student" أو "parent".',
            'level.in' => 'المستوى يجب أن يكون إما "ninth" أو "twelfth" أو "all".',
        ];
    }}
    
    
    
    
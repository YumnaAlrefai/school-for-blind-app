<?php

namespace App\Http\Requests;

use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Foundation\Http\FormRequest;

class QuizInfoRequest extends FormRequest
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
        return [
             'subject_id' => 'required|integer|exists:subjects,id',
        'teacher_id' => 'required|integer|exists:teachers,id',
        'lesson_id'  => 'required|integer|exists:lessons,id'
        ];
    }
public function messages(): array
    {
        return [
            'subject_id.required' => 'رقم المادة مطلوب.',
            'subject_id.integer'  => 'رقم المادة يجب أن يكون عددًا صحيحًا.',
            'subject_id.exists'   => 'المادة المحددة غير موجودة.',
            'teacher_id.required' => 'رقم المعلم مطلوب.',
            'teacher_id.integer'  => 'رقم المعلم يجب أن يكون عددًا صحيحًا.',
            'teacher_id.exists'   => 'المعلم المحدد غير موجود.',
            'lesson_id.required'  => 'رقم الدرس مطلوب.',
            'lesson_id.integer'   => 'رقم الدرس يجب أن يكون عددًا صحيحًا.',
            'lesson_id.exists'    => 'الدرس المحدد غير موجود.'
        ];
    }
}
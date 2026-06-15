<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class IndexLessonRequest extends FormRequest
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
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            'subject_id' => 'nullable|exists:subjects,id',
            'class_id' => 'nullable|integer',
            'per_page' => 'nullable|integer|min:1|max:100',
        ];
    }

    /**
     * Get the error messages for the defined validation rules.
     *
     * @return array<string, string>
     */
    public function messages(): array
    {
        return [
            'subject_id.exists' => 'المادة الدراسية المحددة غير موجودة في النظام.',
            'class_id.integer' => 'يجب أن يكون معرف الصف الدراسي رقماً صحيحاً.',
            'per_page.integer' => 'يجب أن يكون عدد العناصر في الصفحة رقماً صحيحاً.',
            'per_page.min' => 'يجب أن يكون عدد العناصر في الصفحة 1 على الأقل.',
            'per_page.max' => 'لا يمكن عرض أكثر من 100 عنصر في الصفحة الواحدة.',
        ];
    }
}
<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StoreLessonRequest extends FormRequest
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
            'subject_id' => 'required|exists:subjects,id',
            'class_id' => 'required|integer',
            'title' => 'required|string|max:255',
            'order' => 'nullable|integer',
            'audio_file' => 'required|file|mimes:mp3,wav,ogg,m4a|max:51200',
            'duration' => 'nullable|string',
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
            'subject_id.required' => 'يرجى تحديد المادة الدراسية.',
            'subject_id.exists' => 'المادة الدراسية المحددة غير موجودة في النظام.',
            'class_id.required' => 'يرجى تحديد الصف الدراسي للدرس.',
            'class_id.integer' => 'يجب أن يكون معرف الصف الدراسي رقماً صحيحاً.',
            'title.required' => 'عنوان الدرس مطلوب ولا يمكن تركه فارغاً.',
            'title.string' => 'يجب أن يكون عنوان الدرس نصاً.',
            'title.max' => 'عنوان الدرس طويل جداً، الحد الأقصى هو 255 حرفاً.',
            'order.integer' => 'يجب أن يكون ترتيب الدرس رقماً صحيحاً.',
            'audio_file.required' => 'يرجى إرفاق التسجيل الصوتي للدرس.',
            'audio_file.file' => 'الملف المرفوع غير صالح.',
            'audio_file.mimes' => 'يجب أن يكون الملف المرفوع بصيغة صوتية مدعومة (mp3, wav, ogg, m4a).',
            'audio_file.max' => 'حجم التسجيل الصوتي كبير جداً، الحد الأقصى المسموح به هو 50 ميغابايت.',
        ];
    }
}
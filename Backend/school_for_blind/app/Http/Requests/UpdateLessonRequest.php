<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class UpdateLessonRequest extends FormRequest
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
            'title' => 'sometimes|required|string|max:255',
            'class_id' => 'sometimes|required|integer',
            'order' => 'nullable|integer',
            'audio_file' => 'nullable|file|mimes:mp3,wav,ogg,m4a|max:51200',
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
            'title.required' => 'عنوان الدرس مطلوب ولا يمكن تركه فارغاً.',
            'title.string' => 'يجب أن يكون عنوان الدرس نصاً.',
            'title.max' => 'عنوان الدرس طويل جداً، الحد الأقصى هو 255 حرفاً.',
            'class_id.required' => 'الصف الدراسي مطلوب في حال تعديله.',
            'class_id.integer' => 'يجب أن يكون معرف الصف الدراسي رقماً صحيحاً.',
            'order.integer' => 'يجب أن يكون ترتيب الدرس رقماً صحيحاً.',
            'audio_file.file' => 'الملف المرفوع غير صالح.',
            'audio_file.mimes' => 'يجب أن يكون الملف المرفوع بصيغة صوتية مدعومة (mp3, wav, ogg, m4a).',
            'audio_file.max' => 'حجم التسجيل الصوتي كبير جداً، الحد الأقصى المسموح به هو 50 ميغابايت.',
        ];
    }
}
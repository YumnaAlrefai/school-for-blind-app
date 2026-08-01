<?php

namespace App\Http\Requests;

use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Foundation\Http\FormRequest;

class StoreSupportTicketRequest extends FormRequest
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
            'text_content' => 'required_without:audio|nullable|string',
            'audio'        => 'required_without:text_content|nullable|file|mimes:mp3,wav,ogg,m4a|max:10240', 
            'image'        => 'nullable|image|mimes:jpeg,png,jpg|max:5120', 
        ];
  
        }

        public function messages():array
        {
            return[
          
        'text_content.required_without' => 'يرجى إرسال تفاصيل المشكلة إما بشكل نصي أو عبر تسجيل صوتي.',
        'text_content.string'           => 'يجب أن يكون محتوى المشكلة من نوع نصي (String).',

        'audio.required_without' => 'يرجى إرفاق تسجيل صوتي للمشكلة في حال لم تقم بكتابة نص.',
        'audio.file'             => 'يجب أن يكون المرفق الصوتي ملفاً صالحاً.',
        'audio.mimes'            => 'صيغة الملف الصوتي غير مدعومة. الصيغ المقبولة هي: mp3, wav, ogg, m4a.',
        'audio.max'              => 'حجم الملف الصوتي يجب أن لا يتجاوز 10 ميغابايت.',

        'image.image' => 'يجب أن يكون المرفق صورة صحيحة.',
        'image.mimes' => 'صيغة الصورة غير مدعومة. الصيغ المقبولة هي: jpeg, png, jpg.',
        'image.max'   => 'حجم الصورة يجب أن لا يتجاوز 5 ميغابايت.',
    ];
}
        }


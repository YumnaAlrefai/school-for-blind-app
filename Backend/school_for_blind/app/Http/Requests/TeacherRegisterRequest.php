<?php

namespace App\Http\Requests;

use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Foundation\Http\FormRequest;

class TeacherRegisterRequest extends FormRequest
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
            'phone' => 'required|regex:/^\+?\d{8,15}$/|unique:teachers,phone',
            'full_name' => 'required|string|max:31',
            'password' => 'required|string|min:8|confirmed|max:40',
            'subjects' => 'required|string|max:511',
            'level' => 'required|string|in:ninth,twelfth',
            // 'fcm_token' => 'required|string',
            'cv' => 'required|file|mimes:pdf',

        ];
    }

    public function messages()
    {
        return [
            'phone.required' => 'رقم الهاتف مطلوب.',
            'phone.regex' => 'صيغة رقم الهاتف غير صحيحة، يجب أن يتكون من 8 إلى 15 رقماً وقد يبدأ بإشارة (+).',
            'phone.unique' => 'رقم الهاتف مسجل لدينا مسبقاً.',

            'full_name.required' => 'الاسم الكامل مطلوب.',
            'full_name.string' => 'الاسم الكامل يجب أن يكون نصاً.',
            'full_name.max' => 'الاسم الكامل يجب ألا يتجاوز 31 حرفاً.',

            'password.required' => 'كلمة المرور مطلوبة.',
            'password.string' => 'كلمة المرور يجب أن تكون نصاً.',
            'password.min' => 'كلمة المرور يجب أن تتكون من 8 أحرف على الأقل.',
            'password.max' => 'كلمة المرور يجب ألا تتجاوز 40 حرفاً.',
            'password.confirmed' => 'تأكيد كلمة المرور غير متطابق.',

            'subjects.required' => 'تحديد المواد مطلوب.',
            'subjects.string' => 'المواد يجب أن تكون عبارة عن نص.',
            'subjects.max' => 'المواد يجب ألا تتجاوز 511 حرفاً.',

            'level.required' => 'المستوى مطلوب.',
            'level.string' => 'المستوى يجب أن يكون نصاً.',
            'level.in' => 'المستوى المختار غير صحيح، يجب أن يكون التاسع (ninth) أو الثاني عشر (twelfth).',

            'cv.required' => 'ملف السيرة الذاتية مطلوب.',
            'cv.file' => 'السيرة الذاتية يجب أن تكون ملفاً.',
            'cv.mimes' => 'ملف السيرة الذاتية يجب أن يكون بصيغة PDF حصراً.',
        ];
    }
}

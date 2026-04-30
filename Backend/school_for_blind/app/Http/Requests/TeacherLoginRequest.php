<?php

namespace App\Http\Requests;

use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Foundation\Http\FormRequest;

class TeacherLoginRequest extends FormRequest
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
    public function rules()
    {
        return [
            'phone' => 'required|regex:/^\+?\d{8,15}$/|exists:teachers,phone',
            'password' => 'required|string|min:8|max:40',
            // 'fcm_token' => 'required|string',
        ];
    }

    public function messages()
    {
        return [
            'phone.required' => 'رقم الهاتف مطلوب.',
            'phone.regex' => 'صيغة رقم الهاتف غير صالحة. يجب أن يتكون من 8 إلى 15 رقماً، ويمكن أن يبدأ بعلامة (+).',
            'phone.exists' => 'رقم الهاتف المدخل غير مسجل لدينا في النظام.',

            'password.required' => 'كلمة المرور مطلوبة.',
            'password.string' => 'يجب أن تكون كلمة المرور عبارة عن نص.',
            'password.min' => 'يجب ألا تقل كلمة المرور عن 8 أحرف.',
            'password.max' => 'يجب ألا تتجاوز كلمة المرور 40 حرفاً.',

            // 'fcm_token.required' => 'رمز الإشعارات (FCM Token) مطلوب.',
            // 'fcm_token.string'   => 'يجب أن يكون رمز الإشعارات عبارة عن نص.',
        ];
    }
}

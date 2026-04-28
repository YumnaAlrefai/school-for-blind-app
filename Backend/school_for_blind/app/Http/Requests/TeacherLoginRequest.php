<?php

namespace App\Http\Requests;

use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Foundation\Http\FormRequest;
<<<<<<< HEAD
=======
use function PHPUnit\Framework\returnArgument;
>>>>>>> main

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
<<<<<<< HEAD
=======

    public function messages()
    {
        return [
            'phone.required' => 'رقم الهاتف مفقود',
            'phone.regex' => 'رقم الهاتف بصيغة خاطئة',
            'phone.exists' => 'رقم الهاتف غير موجود في القوائم',
            'password.required' => 'كلمة السر مفقودة',
            'password.string' => 'كلمة السر ليست من نوع (string)',
            'password.min' => 'كلمة السر اقل من 8 احرف',
            'password.max' => 'كلمة السر اكثر من 40 حرف',
        ];
    }
>>>>>>> main
}

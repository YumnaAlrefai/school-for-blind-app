<?php

namespace App\Http\Requests;

use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Foundation\Http\FormRequest;

class VerifyOtpRequest extends FormRequest
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
                'otp'   => ['required', 'digits:6'],
'phone' => ['required', 'regex:/^(\+?963|0)9[0-9]{8}$/'],
 ];
    }
public function messages(): array
    {
        return [
            'otp.required' => 'الرجاء إدخال رمز التحقق (OTP).',
            'otp.digits' => 'رمز التحقق (OTP) يجب أن يتكون من 6 أرقام.',
            'phone.required' => 'الرجاء إدخال رقم الهاتف.',
            'phone.regex' => 'رقم الهاتف غير صالح. يجب أن يبدأ بـ +963 أو 0 ويتبعه 9 أرقام.',
            'phone.unique' => 'رقم الهاتف هذا مسجل بالفعل.',

        ];



    }}

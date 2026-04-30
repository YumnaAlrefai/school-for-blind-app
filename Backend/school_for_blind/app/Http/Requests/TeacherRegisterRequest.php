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
            // 'date_of_birth' => [
            //     'required',
            //     'date',
            //     'before:' . Carbon::now()->subYears(6)->toDateString(),
            // ],
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
            'phone.regex' => 'صيغة رقم الهاتف غير صالحة. يجب أن يتكون من 8 إلى 15 رقماً، ويمكن أن يبدأ بعلامة (+).',
            'phone.unique' => 'رقم الهاتف المدخل مسجل لدينا مسبقاً.',

            'full_name.required' => 'الاسم الكامل مطلوب.',
            'full_name.string' => 'يجب أن يكون الاسم الكامل عبارة عن نص.',
            'full_name.max' => 'يجب ألا يتجاوز الاسم الكامل 31 حرفاً.',

            'password.required' => 'كلمة المرور مطلوبة.',
            'password.string' => 'يجب أن تكون كلمة المرور عبارة عن نص.',
            'password.min' => 'يجب ألا تقل كلمة المرور عن 8 أحرف.',
            'password.max' => 'يجب ألا تتجاوز كلمة المرور 40 حرفاً.',
            'password.confirmed' => 'تأكيد كلمة المرور غير متطابق.',

            // 'date_of_birth.required' => 'تاريخ الميلاد مطلوب.',
            // 'date_of_birth.date'     => 'يجب أن يكون تاريخ الميلاد تاريخاً صالحاً.',
            // 'date_of_birth.before'   => 'يجب أن يكون العمر 6 سنوات على الأقل.',

            'subjects.required' => 'المواد الدراسية مطلوبة.',
            'subjects.string' => 'يجب أن تكون المواد الدراسية عبارة عن نص.',
            'subjects.max' => 'يجب ألا تتجاوز المواد الدراسية 511 حرفاً.',

            'level.required' => 'المستوى الدراسي مطلوب.',
            'level.string' => 'يجب أن يكون المستوى الدراسي عبارة عن نص.',
            'level.in' => 'المستوى الدراسي المدخل غير صحيح، يجب أن يكون إما التاسع (ninth) أو الثاني عشر (twelfth).',

            // 'fcm_token.required' => 'رمز الإشعارات (FCM Token) مطلوب.',
            // 'fcm_token.string'   => 'يجب أن يكون رمز الإشعارات عبارة عن نص.',

            'cv.required' => 'السيرة الذاتية مطلوبة.',
            'cv.file' => 'يجب أن تكون السيرة الذاتية عبارة عن ملف.',
            'cv.mimes' => 'يجب أن يكون ملف السيرة الذاتية بصيغة PDF فقط.',
        ];
    }
}

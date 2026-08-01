<?php

namespace App\Http\Requests;

use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Foundation\Http\FormRequest;

class StudentRegisterRequest extends FormRequest
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
            'fullname' => ['required', 'string', 'min:7','max:255'],
            'fathersname' => ['required', 'string', 'min:3','max:255'],
'phone' => 'required|regex:/^\+?\d{8,15}$/|unique:students,phone',
'parent_phone' => ['required', 'digits:10'],
'level' => 'required|string|in:ninth,twelfth',
'DocumentaryEvidence' => ['required', 'mimes:,jpg,jpeg,png', 'max: 2048'],
        ];
    }
public function messages()
{
    return [
        'phone.required' => 'رقم الهاتف مطلوب لإكمال التسجيل',
        'fathersname.required' => 'اسم الأب مطلوب لإكمال التسجيل',
        'parent_phone.required' => 'رقم هاتف ولي الأمر مطلوب لإكمال التسجيل',
        'level.required' => 'المستوى الدراسي مطلوب لإكمال التسجيل',
        'DocumentaryEvidence.required' => 'إرفاق مستند إثبات هوية مطلوب لإكمال التسجيل',
        'parent_phone.digits' => 'رقم هاتف ولي الأمر يجب أن يكون 10 أرقام',
        'parent_phone.regex' => 'تنسيق رقم الهاتف غير صحيح',
        'phone.regex'    => 'تنسيق رقم الهاتف غير صحيح',
        'phone.unique'   => 'هذا الرقم مسجل مسبقاً',
        'fullname.min'   => 'الاسم يجب أن يكون ثلاثياً على الأقل',
    ];
}


    }

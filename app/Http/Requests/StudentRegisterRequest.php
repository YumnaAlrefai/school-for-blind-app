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
            'fathersname' => ['required', 'string', 'min:3','max:255', 'unique:students,fathersname'],
'phone' => 'required|regex:/^\+?\d{8,15}$/|unique:students,phone',
'parent_phone' => ['required', 'digits:10'],
'level' => 'required|string|in:ninth,twelfth',
'DocumentaryEvidence' => ['required', 'file', 'mimes:pdf,jpg,jpeg,png', 'max:2048'],
        ];
    }
public function messages()
{
    return [
        'phone.required' => 'رقم الهاتف مطلوب لإكمال التسجيل',
        'phone.regex'    => 'تنسيق رقم الهاتف غير صحيح',
        'phone.unique'   => 'هذا الرقم مسجل مسبقاً',
        'fullname.min'   => 'الاسم يجب أن يكون ثلاثياً على الأقل',
        'fathersname.min' => 'اسم الأب يجب أن يكون ثلاثة أحرف  على الأقل',
        'fathersname.required' => 'اسم الأب مطلوب',
        'parent_phone.digits' => 'رقم هاتف ولي الأمر يجب أن يكون 10 أرقام',
        'parent_phone.required' => 'رقم هاتف ولي الأمر مطلوب',
'parent_phone.regex' => 'تنسيق رقم هاتف ولي الأمر غير صحيح',
        'level.required' => 'المستوى الدراسي مطلوب',
         'level.string' => 'المستوى الدراسي يجب أن يكون نصاً',

        'level.in' => 'المستوى يجب أن يكون إما ninth أو twelfth',
        'DocumentaryEvidence.required' => 'إرفاق مستند إثبات هو أمر ضروري',
        'DocumentaryEvidence.file' => 'الملف المرفق غير صالح',
        'DocumentaryEvidence.mimes' => 'نوع الملف يجب أن يكون PDF أو JPG'
    ];
}


    }

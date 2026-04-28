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
}

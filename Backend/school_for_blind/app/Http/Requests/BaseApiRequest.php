<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Contracts\Validation\Validator;
use Illuminate\Http\Exceptions\HttpResponseException;

class BaseApiRequest extends FormRequest
{
    protected $authErrorMessage = 'غير مصرح لك بالقيام بهذا الإجراء';

    protected function failedValidation(Validator $validator)
    {
        throw new HttpResponseException(response()->json([
            'error' => 'يوجد خطأ في البيانات المدخلة',
            'details' => $validator->errors()
        ], 422));
    }

    protected function failedAuthorization()
    {
        throw new HttpResponseException(response()->json([
            'error' => $this->authErrorMessage
        ], 403));
    }
}
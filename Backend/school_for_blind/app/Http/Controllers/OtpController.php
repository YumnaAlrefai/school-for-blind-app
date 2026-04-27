<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Http\Requests\VerifyOtpRequest;
use App\Models\Student;
use App\Services\OtpService;

class OtpController extends Controller
{
    protected $otpService;

    public function __construct(OtpService $otpService)
    {
        $this->otpService = $otpService;
    }

    public function verify(VerifyOtpRequest $request)
    {
        $student = Student::where('phone', $request->phone)->first();

        if (!$student) {
            return response()->json([
                'status' => 'error',
                'message' => 'رقم الهاتف هذا غير مسجل لدينا.'
            ], 404);
        }

        if (!$this->otpService->verify($request->otp, $student->otp)) {
            return response()->json([
                'status' => 'error',
                'message' => 'رمز التحقق غير صحيح، يرجى التأكد من الرمز المرسل.'
            ], 422);
        }

        if (now()->isAfter($student->otp_expires_at)) {
            return response()->json([
                'status' => 'error',
                'message' => 'انتهت صلاحية الرمز، يرجى طلب رمز جديد.'
            ], 422);
        }

        $student->update([
            'phone_verified_at' => now(),
            'status'            => 'pending_approval',
            'otp'               => null,
        ]);

       return response()->json([
    "status" => "success",
    "message" => "تم تأكيد الحساب بنجاح، بانتظار موافقة الإدارة لتتمكن من تسجيل الدخول.",
    "data" => [
        "user" => [
            "id"    => $student->id,
            "fullname"  => $student->fullname,
            "phone" => $student->phone,
            "parent_phone" => $student->parent_phone,
            "level"=> $student->level,
            "status"=> $student->status,
        ]

    ]
], 200);
    }
}

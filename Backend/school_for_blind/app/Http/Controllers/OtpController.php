<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Auth;
use App\Services\WhatsAppService;
use App\Services\OtpService;
use App\Http\Requests\VerifyOtpRequest;

class OtpController extends Controller
{

    public function __construct(

        protected WhatsAppService $whatsApp,
        protected OtpService $otpService
    ) {
    }

    public function sendOtp(Request $request)
    {
        $request->validate([
            'phone' => 'required|regex:/^\+?\d{9,15}$/|unique:teachers,phone',
        ]);

        $otp = $this->otpService->generate();

        Cache::put('otp_' . $request->phone, $otp, $this->otpService->expiry());
        $this->whatsApp->sendOtp($request->phone, $otp);

        return response()->json(['message' => 'تم ارسال رمز التحقق']);
    }

    // public function sendOtp_passwordone(Request $request)
    // {
    //     $user = Auth::user();
    //     $request->validate([
    //         'phone' => 'required|regex:/^\+?\d{9,15}$/|exists:teachers,phone',
    //     ]);

    //     if ($user->phone != $request->phone) {
    //         return response()->json(['message' => 'الرقم غير مطابق لحسابك'], 403);
    //     }

    //     $otp = $this->otpService->generate();
    //     Cache::put('otp_' . $request->phone, $otp, $this->otpService->expiry());

    //     $this->whatsApp->sendOtp($request->phone, $otp);

    //     return response()->json(['message' => 'تم إرسال رمز التحقق إلى رقمك بنجاح']);
    // }


    public function verifyOtp(VerifyOtpRequest $request)
    {
        $key = 'otp_' . $request->phone;
        $cachedOtp = Cache::get($key);

        if (!$cachedOtp) {
            return response()->json(['message' => 'رمز التحقق تالف أو انتهى'], 400);
        }

        if ((string) $cachedOtp !== (string) $request->otp) {
            return response()->json(['message' => 'رمز التحقق غير صحيح'], 400);
        }

        Cache::forget($key);
        return response()->json(['message' => 'تم التحقق بنجاح، يمكنك المتابعة']);
    }
}

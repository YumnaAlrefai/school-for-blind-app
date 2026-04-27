<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;

use Illuminate\Foundation\Auth\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;

class OtpController extends Controller
{
    public function sendOtp(Request $request)
    {
        $request->validate([
            'phone' => 'required|regex:/^\+?\d{9,15}$/|unique:teachers,phone',
        ]);

        $otp = rand(100000, 999999);

        Cache::put('otp_' . $request->phone, $otp, now()->addMinutes(5));

        app('greenapi')->sendMessage($request->phone, "Verification code: {$otp}");

        return response()->json(['message' => 'تم ارسال رمز التحقق',]);
    }

    public function sendOtp_passwordone(Request $request)
    {
        $user = auth()->user();
        $request->validate([
            'phone' => 'required|regex:/^\+?\d{9,15}$/|exists:teachers,phone',
        ]);

        if ($user->phone != $request->phone)
            return response()->json([
                'message' => 'تم ارسال رمز التحقق',
            ]);



        $otp = rand(100000, 999999);

        Cache::put('otp_' . $request->phone, $otp, now()->addMinutes(5));

        app('greenapi')->sendMessage($request->phone, "Verification code: {$otp}");

        return response()->json(['message' => __('validation.user.otp_sent'),]);
    }

    public function verifyOtp(Request $request)
    {
        $request->validate([
            'phone' => 'required|regex:/^\+?\d{9,15}$/',
            'otp' => 'required|integer'
        ]);

        $cachedOtp = Cache::get('otp_' . $request->phone);

        if (!$cachedOtp) {
            return response()->json(['message' => 'رمز التحقق تالف'], 400);
        }

        if ($cachedOtp != $request->otp) {
            return response()->json(['message' => 'رمز التحقق غير صحيح'], 400);
        }

        Cache::forget('otp_' . $request->phone);

        return response()->json(['message' => 'رمز التحقق صحيح']);
    }
}

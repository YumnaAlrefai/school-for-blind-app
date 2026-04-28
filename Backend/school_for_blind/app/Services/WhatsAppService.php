<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class WhatsAppService
{
    public function sendOtpAndLink($phone, $otp = null, $link = null, $customMessage = "")
    {
        if (str_starts_with($phone, '0')) {
            $phone = '963' . substr($phone, 1);
        }
        $message = "مرحباً بك..\n";

        if ($otp) {
            $message .= "رمز التحقق الخاص بك هو: " . $otp . "\n";
        }

        if ($link) {
            $message .= "رابط الدخول المباشر: " . $link . "\n";
        }

        $response = Http::post("https://api.ultramsg.com/" . env('ULTRAMSG_INSTANCE_ID') . "/messages/chat", [
            "token" => env('ULTRAMSG_TOKEN'),
            "to"    => $phone,
            "body"  => $message
        ]);
        if ($response->failed()) {
            Log::error("فشل إرسال رسالة الواتساب إلى $phone: " . $response->body());
        }

        return $response->json();
    }
}

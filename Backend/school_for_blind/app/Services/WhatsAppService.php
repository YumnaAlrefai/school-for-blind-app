<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class WhatsAppService
{
    public function sendOtp(string $phone, string $otp)
    {
        $message = "Verification code:\n" . $otp;
        return $this->execute($phone, $message);
    }
    public function sendMagicLink(string $phone, string $fullname, string $link)
    {
        $message = "مرحباً {$fullname} 👋\n";
        $message .= "يمكنك تسجيل الدخول إلى حسابك في مدرسة المكفوفين عبر الضغط على الرابط التالي:\n\n";
        $message .= $link;

        return $this->execute($phone, $message);
    }

    private function execute(string $phone, string $message)
    {
        if (str_starts_with($phone, '0')) {
            $phone = '963' . substr($phone, 1);
        }

        $response = Http::post("https://api.ultramsg.com/" . env('ULTRAMSG_INSTANCE_ID') . "/messages/chat", [
            "token" => env('ULTRAMSG_TOKEN'),
            "to" => $phone,
            "body" => $message
        ]);

        if ($response->failed()) {
            Log::error("UltraMsg Error ($phone): " . $response->body());
        }

        return $response->json();
    }
}

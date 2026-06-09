<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class WhatsAppService
{
    public function sendOtp(string $phone, string $otp)
    {
        $message = ":رمز التحقق الخاص بك\n" . $otp;
        return $this->execute($phone, $message);
    }
    public function sendMagicLink(string $phone, string $fullname, string $link)
    {
        $message = "مرحباً {$fullname} 👋\n";
        $message .= "يمكنك تسجيل الدخول إلى حسابك في مدرسة المكفوفين عبر الضغط على الرابط التالي:\n\n";
        $message .= $link;

        return $this->execute($phone, $message);
    }

    public function sendStudentinfo(string $phone, string $fullname, string $parent_phone, string $password)
    {
        $message = "مرحباً {$fullname} 👋\n
تم قبول طلب انضمامك في مدرستنا راجين لك كل التوفيق و النجاح و ان نكون عند حسن ظنكم\n
يمكن لولي أمر الطالب {$fullname} متابعة اخبار تفوقه الدراسي عبر تطبيقنا الخاص بالاهل حيث يمكنكم تسجيل الدخول بهذه البيانات\n
رقم الهاتف: {$parent_phone}\n
كلمة المرور: {$password}"
        ;

        return $this->execute($phone, $message);
    }
    public function sendteacherinfo(string $phone, string $fullname)
    {
        $message = "مرحباً {$fullname} 👋\n
تم قبول طلب انضمامك في مدرستنا راجين لك كل التوفيق و النجاح و ان نكون عند حسن ظنكم\n
و ان تكون عونا للطالب في نيله العلم"
        ;
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

<?php

namespace App\Http\Controllers;
use App\Http\Controllers\Controller;
use App\Http\Requests\StudentLoginRequest;
use App\Http\Requests\StudentRegisterRequest;
use App\Models\Student;
use App\Services\WhatsAppService;
use App\Traits\UploadFileTrait;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\URL;

class StudentController extends Controller
{
    use UploadFileTrait;
    public function register(StudentRegisterRequest $request)
    {

        $deviceFingerprint = md5($request->ip() . $request->header('User-Agent'));

        $cacheKey = 'otp_verified_' . $request->phone . '_' . $deviceFingerprint;

        $isVerified = Cache::pull($cacheKey);

        if (!$isVerified) {
            return response()->json([
                'message' => 'طلب غير مصرح به، أو انتهت مهلة التحقق.'
            ], 403);
        }

        $path = $this->uploadfile($request->file('DocumentaryEvidence'), 'students/documents');

        $student = Student::create([
            'fullname' => $request->fullname,
            'fathersname' => $request->fathersname,
            'phone' => $request->phone,
            'parent_phone' => $request->parent_phone,
            'level' => $request->level,
            'DocumentaryEvidence' => $path,
            'status' => 'pending',
            'phone_verified_at' => now(),
        ]);

        return response()->json([
            'status' => 'success',
            'message' => 'تم حفظ بياناتك بنجاح. حسابك الآن بانتظار مراجعة الإدارة.',
            "data" => [
                "user" => [
                    "id" => $student->id,
                    "fathersname" => $student->fathersname,
                    "fullname" => $student->fullname,
                    "phone" => $student->phone,
                    "status" => $student->status,
                    'documentary_evidence' => $student->DocumentaryEvidence,
                ]
            ]
        ], 200, [], JSON_UNESCAPED_UNICODE);
    }
    public function login(StudentLoginRequest $request, WhatsAppService $whatsApp)
    {
        $student = Student::query()->where('phone', '=', $request->phone)->first();

        if (!$student) {
            return response()->json([
                'status' => 'error',
                'message' => 'عذراً، هذا الحساب غير موجود أو لم يتم تفعيله من قبل الإدارة بعد.'
            ], 403, [], JSON_UNESCAPED_UNICODE);
        }

        // URL::forceRootUrl('https://barman-wannabe-cape.ngrok-free.dev');
        // URL::forceScheme('https');

        $loginUrl = URL::temporarySignedRoute(
            'student.magic.view',
            now()->addMinutes(15),
            ['id' => $student->id]
        );

        try {

            $whatsApp->sendMagicLink($student->phone, $student->fullname, $loginUrl);

            return response()->json([
                'status' => 'success',
                'message' => 'تم إرسال رابط الدخول المباشر إلى رقمك على واتساب بنجاح'
            ], 200, [], JSON_UNESCAPED_UNICODE);

        } catch (\Exception $e) {

            Log::error("WhatsApp Login Error: " . $e->getMessage());

            return response()->json([
                'status' => 'error',
                'message' => 'حدث خطأ أثناء إرسال الرسالة، يرجى المحاولة لاحقاً.'
            ], 500, [], JSON_UNESCAPED_UNICODE);
        }
    }
    public function magicLogin(Request $request, $id)
    {
        if (!$request->hasValidSignature()) {
            return response()->json(['message' => 'عذراً، الرابط منتهي الصلاحية أو غير صالح.'], 401);
        }
        $student = Student::findOrFail($id);
        //$student->DocumentaryEvidence = $student->getFullUrl($student->DocumentaryEvidence);
        $token = $student->createToken('student_access_token')->plainTextToken;
        return response()->json([
            'status' => 'success',
            'message' => 'تم تسجيل الدخول بنجاح',
            'token' => $token,
            'user' => $student
        ], 200, [], JSON_UNESCAPED_UNICODE);
    }

}


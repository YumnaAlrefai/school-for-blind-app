<?php

namespace App\Http\Controllers;
use App\Http\Requests\LoginRequest;
use App\Http\Requests\RegisterStudentRequest;
use App\Http\Requests\StudentLoginRequest;
use App\Http\Requests\StudentRegisterRequest;
use App\Models\Student;
use App\Services\OtpService;
use App\Services\WhatsAppService;
use App\Traits\UploadFileTrait;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\URL;

class StudentController extends Controller
{
    use UploadFileTrait;

    protected $otpService, $whatsapp;

    public function __construct(OtpService $otpService, WhatsAppService $whatsapp)
    {
        $this->otpService = $otpService;
        $this->whatsapp = $whatsapp;
    }
    public function register(StudentRegisterRequest $request)
    {
        $path = $this->uploadfile($request->file('DocumentaryEvidence'), 'students/documents');
        $otpCode = $this->otpService->generate();
        $student = Student::create([
            'fullname' => $request->fullname,
            'phone' => $request->phone,
            'parent_phone' => $request->parent_phone,
            'level' => $request->level,
            'DocumentaryEvidence' => $path,
            'otp' => $this->otpService->hash($otpCode),
            'otp_expires_at' => $this->otpService->expiry(),
            'status' => 'not_active',
        ]);
        $this->whatsapp->sendOtpAndLink($student->phone, $otpCode);
        return response()->json([
            'status' => 'success',
            'message' => 'تم التسجيل بنجاح. يرجى إدخال الرمز المرسل إلى واتساب لتأكيد الحساب.',
            "data" => [
                "user" => [
                    "id" => $student->id,
                    "fullname" => $student->fullname,
                    "phone" => $student->phone,
                    "parent_phone" => $student->parent_phone,
                    "level" => $student->level,
                    "status" => $student->status,
                    'documentaryevidence' => $student->{'DocumentaryEvidence'},
                ]
            ]
        ], 201, [], JSON_UNESCAPED_UNICODE);
    }
    public function login(StudentLoginRequest $request)
    {

        $student = Student::where('phone', $request->phone)->first();

        if (!$student || $student->status !== 'active') {
            return response()->json([
                'status' => 'error',
                'message' => 'عذراً، هذا الحساب غير موجود أو لم يتم تفعيله من قبل الإدارة بعد.'
            ], 403, [], JSON_UNESCAPED_UNICODE);
        }

        $loginUrl = URL::temporarySignedRoute(
            'student.magic.login',
            now()->addMinutes(15),
            ['id' => $student->id]
        );

        $this->whatsapp->sendOtpAndLink($student->phone, null, $loginUrl);
        return response()->json([
            'status' => 'success',
            'message' => 'تم إرسال رابط الدخول المباشر إلى رقمك على واتساب بنجاح.'
        ], 200, [], JSON_UNESCAPED_UNICODE);
    }
    public function magicLogin(Request $request, $id)
    {
        $student = Student::findOrFail($id);
        $token = $student->createToken('student_access_token')->plainTextToken;

        return response()->json([
            'message' => 'تم تسجيل الدخول بنجاح',
            'token' => $token,
            'user' => $student
        ]);
    }
}


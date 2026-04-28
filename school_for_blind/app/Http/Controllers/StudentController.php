<?php

namespace App\Http\Controllers;
use App\Http\Requests\StudentLoginRequest;
use App\Http\Requests\StudentRegisterRequest;
use App\Models\Student;
use App\Traits\UploadFileTrait;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\URL;

class StudentController extends Controller
{
    use UploadFileTrait;
    public function register(StudentRegisterRequest $request)
{
    $path = $this->uploadfile($request->file('DocumentaryEvidence'), 'students/documents');

   $student = Student::create([
        'fullname'             => $request->fullname,
        'phone'                => $request->phone,
        'parent_phone'         => $request->parent_phone,
        'level'                => $request->level,
        'DocumentaryEvidence'  => $path,
        'status'               => 'pending',
        'phone_verified_at'    => now(),
    ]);

    return response()->json([
        'status' => 'success',
        'message' => 'تم حفظ بياناتك بنجاح. حسابك الآن بانتظار مراجعة الإدارة.',
        "data" => [
            "user" => [
                "id"           => $student->id,
                "fullname"     => $student->fullname,
                "phone"        => $student->phone,
                "status"       => $student->status,
                'documentary_evidence' => $student->DocumentaryEvidence,
            ]
        ]
    ], 200, [], JSON_UNESCAPED_UNICODE);
}
   public function login(StudentLoginRequest $request)
{
    $student = Student::where('phone', $request->phone)->first();

    if (!$student || $student->status !== 'approved') {
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


    $message = "مرحباً {$student->fullname} 👋\n";
    $message .= "يمكنك تسجيل الدخول إلى حسابك في مدرسة المكفوفين عبر الضغط على الرابط التالي:\n\n";
    $message .= $loginUrl;

    try {
$formattedPhone = $student->phone;
if (str_starts_with($formattedPhone, '0')) {
    $formattedPhone = '963' . substr($formattedPhone, 1);
}
elseif (!str_starts_with($formattedPhone, '963')) {
    $formattedPhone = '963' . $formattedPhone;
}

app('greenapi')->sendMessage($formattedPhone, $message);
        app('greenapi')->sendMessage($student->phone, $message);

        return response()->json([
            'status' => 'success',
            'message' => 'تم إرسال رابط الدخول المباشر إلى رقمك على واتساب بنجاح'
        ], 200, [], JSON_UNESCAPED_UNICODE);

    } catch (\Exception $e) {
        return response()->json([
            'status' => 'error',
            'message' => 'حدث خطأ أثناء إرسال الرسالة يرجى المحاولة لاحقاً'
        ], 500, [], JSON_UNESCAPED_UNICODE);
    }
}
public function magicLogin(Request $request, $id)
    {
        if (! $request->hasValidSignature()) {
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


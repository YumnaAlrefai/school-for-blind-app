<?php

namespace App\Http\Controllers;

use App\Http\Requests\TeacherLoginRequest;
use App\Http\Requests\TeacherRegisterRequest;
use App\Models\Teacher;
use App\Traits\UploadFileTrait;
use Exception;
use Illuminate\Routing\Controller;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Hash;

class TeacherController extends Controller
{

    use UploadFileTrait;
    public function uploadfile($file, $folder)
    {
        if ($file && $file->isValid()) {
            return $file->store($folder, 'public');
        }
        return null;
    }

    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        return response()->json([
            'data' => Teacher::paginate(15),
            'message' => 'قائمة بجميع المدرسين',
        ], 200);
    }

    public function register(TeacherRegisterRequest $request)
    {

        $deviceFingerprint = md5($request->ip() . $request->header('User-Agent'));

        $cacheKey = 'otp_verified_' . $request->phone . '_' . $deviceFingerprint;

        \Log::info('' . $request->phone . '  ' . $cacheKey);
        $isVerified = Cache::pull($cacheKey);

        if (!$isVerified) {
            return response()->json([
                'message' => 'طلب غير مصرح به، أو انتهت مهلة التحقق.'
            ], 403);
        }

        $teacherdata = [
            'full_name' => $request->full_name,
            'phone' => $request->phone,
            'password' => Hash::make($request->password),
            'subjects' => $request->subjects,
            'level' => $request->level,
            // 'fcm_token' => $request->fcm_token,
        ];

        $path = $this->uploadfile($request->file('cv'), 'teahcers/CVS');
        \Log::info('path : ' . $path);
        $teacherdata['cv_path'] = $path;
        $teacher = Teacher::create($teacherdata);

        return response()->json([
            'message' => 'تم ارسال طلب لانشاء الحساب بنجاح',
            'data' => $teacher
        ], 201);
    }

    public function login(TeacherLoginRequest $request)
    {
        if (!Auth::guard('teacher')->attempt($request->only('phone', 'password'))) {
            return response()->json(['message' => 'معلومات تسجيل دخول خاطئة'], 401);
        }

        $teacher = Auth::guard('teacher')->user();

        if (!$teacher) {
            return response()->json(['message' => 'لا يوجد حساب على هذا الرقم'], 423);
        }

        if ($teacher->status == 'pending') {
            return response()->json(['message' => 'انتظر حتى يوافق احد المشرفين على حسابك'], 403);
        }

        try {
            $token = $teacher->createToken('api-token')->plainTextToken;
            $teacher->fcm_token = $request->fcm_token;
            $teacher->save();
        } catch (Exception $e) {
            return response()->json(['message' => 'فشل في توليد التوكن حاول مجددا'], 500);
        }

        return response()->json([
            'access_token' => $token,
            'token_type' => 'Bearer',
            'user' => $teacher
        ]);
    }

    public function logout()
    {
        auth()->user()->currentAccessToken()->delete();
        return response()->json(['message' => 'تم تسجيل الخروج بنجاح']);
    }


    public function info()
    {
        $teacher = auth()->user();

        $teacher->cv_link = asset('storage/' . $teacher->cv_path);

        $teacher->load('classes');

        return response()->json([
            'message' => 'بيانات المدرس',
            'data' => $teacher
        ], 200);
    }

    // public function showCv()
    // {
    //     $teacher = auth()->user();

    //     if (!$teacher->cv_path || !Storage::exists($teacher->cv_path)) {
    //         return response()->json(['message' => 'ملف السيرة الذاتية غير موجود'], 404);
    //     }

    //     return Storage::response($teacher->cv_path);
    // }
}

<?php

namespace App\Http\Controllers;

use App\Http\Requests\LoginRequest;
use App\Http\Requests\RegisterRequest;
use App\Models\Teacher;
use App\Models\User;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Routing\Controller;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Hash;

class TeacherController extends Controller
{
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

        $user = User::where('phone', $request->phone)->first();
        if ($user) {
            $user->update(['phone_verified_at' => now()]);
        }
        return response()->json(['message' => 'رمز التحقق صحيح']);
    }

    public function register(RegisterRequest $request)
    {
        $teacherdata = [
            'full_name' => $request->full_name,
            'phone' => $request->phone,
            'password' => Hash::make($request->password),
            'subjects' => $request->subjects,
            'level' => $request->level,
            'fcm_token' => $request->fcm_token,
        ];

        $cv = $request->file('cv');
        $path = $cv->store('CVS');
        $teacherdata['cv_path'] = $path;
        $teacher = Teacher::create($teacherdata);


        return response()->json([
            'message' => 'تم ارسال طلب لانشاء الحساب بنجاح',
            'data' => $teacher
        ], 201);
    }

    public function login(LoginRequest $request)
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
}

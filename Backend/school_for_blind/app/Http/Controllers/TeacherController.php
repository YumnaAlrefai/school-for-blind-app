<?php

namespace App\Http\Controllers;

use App\Http\Requests\LoginRequest;
use App\Http\Requests\RegisterRequest;
use App\Http\Requests\StoreTeacherRequest;
use App\Http\Requests\UpdateTeacherRequest;
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
            'phone' => 'required|regex:/^\+?\d{9,15}$/|unique:users,phone',
        ]);

        $otp = rand(100000, 999999);

        Cache::put('otp_' . $request->phone, $otp, now()->addMinutes(5));

        app('greenapi')->sendMessage($request->phone, "Verification code: {$otp}");

        return response()->json(['message' => 'ok done',]);
    }

    public function sendOtp_passwordone(Request $request)
    {
        $user = auth()->user();
        $request->validate([
            'phone' => 'required|regex:/^\+?\d{9,15}$/|exists:users,phone',
        ]);

        if ($user->phone != $request->phone)
            return response()->json([
                'message' => __('validation.phone.doesnotmatch'),
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
            return response()->json(['message' => __('validation.user.otp_expired')], 400);
        }

        if ($cachedOtp != $request->otp) {
            return response()->json(['message' => __('validation.user.otp_invalid')], 400);
        }

        Cache::forget('otp_' . $request->phone);

        $user = User::where('phone', $request->phone)->first();
        if ($user) {
            $user->update(['phone_verified_at' => now()]);
        }
        return response()->json(['message' => __('validation.user.phone_verified')]);
    }



    public function register(RegisterRequest $request)
    {
        $teacherdata = [
            'full_name' => $request->full_name,
            'phone' => $request->phone,
            'password' => Hash::make($request->password),
            // 'date_of_birth' => $request->date_of_birth,
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
        if (!Auth::attempt($request->only('phone', 'password'))) {
            return response()->json(['message' => __('validation.user.invalid_credentials')], 401);
        }

        $teacher = Auth::user();

        if (!$teacher) {
            return response()->json(['message' => __('validation.user.not_found')], 423);
        }

        if ($teacher->role === 'PENDING') {
            return response()->json(['message' => __('validation.user.pending_approval')], 403);
        }

        try {
            $token = $teacher->createToken('api-token')->plainTextToken;
            $teacher->fcm_token = $request->fcm_token;
            $teacher->save();
        } catch (Exception $e) {
            return response()->json(['message' => __('validation.user.token_failed')], 500);
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
        return response()->json(['message' => __('validation.user.logged_out')]);
    }

    public function info(User $user)
    {
        return response()->json(auth()->user());
    }
}

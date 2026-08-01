<?php

namespace App\Http\Controllers\Dashboard;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class AuthController extends Controller
{
    public function login(Request $request)
    {

        $request->validate([
            'username' => 'required|email',
            'password' => 'required',
        ], [
            'username.required' => 'يرجى إدخال البريد الإلكتروني الخاص بك.',
            'username.email' => 'صيغة البريد الإلكتروني غير صحيحة، يرجى التأكد منها.',
            'password.required' => 'حقل كلمة المرور مطلوب للدخول.',
        ]);

        $credentials = [
            'email' => $request->username,
            'password' => $request->password
        ];

        if (Auth::guard('admin')->attempt($credentials)) {
            $request->session()->regenerate();
            return redirect()->intended(route('dashboard'))
                ->with('success', 'تم تسجيل الدخول بنجاح');
        }

        return redirect()->back()
            ->withInput($request->only('username'))
            ->withErrors([
                'login_error' => 'بيانات الدخول غير صحيحة.',
            ]);
    }

    public function logout(Request $request)
    {
        Auth::guard('admin')->logout();
        $request->session()->invalidate();
        $request->session()->regenerateToken();

        return response()->json([
            'status' => 'success',
            'message' => 'تم تسجيل الخروج بنجاح'
        ]);
    }
}

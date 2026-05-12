<?php

namespace App\Http\Controllers;

use App\Models\Student;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\URL;

class MagicLoginController extends Controller
{
    public function showView(Request $request, $id)
    {
        $student = Student::findOrFail($id);

        $postUrl = URL::temporarySignedRoute(
            'student.magic.generate',
            now()->addMinutes(15),
            ['id' => $student->id]
        );

        return view('magic-login-page', [
            'student' => $student,
            'postUrl' => $postUrl
        ]);
    }
    public function generateToken(Request $request, $id)
    {
        $student = Student::findOrFail($id);

        $student->tokens()->delete();

        $token = $student->createToken('flutter-mobile-app')->plainTextToken;

        \Log::info("myapp://login?token=" . urlencode($token));
        $flutterDeepLink = "myapp://login?token=" . urlencode($token);

        return redirect()->away($flutterDeepLink);
    }
}

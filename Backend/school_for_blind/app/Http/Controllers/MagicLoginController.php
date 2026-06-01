<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\Student;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\URL;
use Illuminate\Support\Str;
use App\Traits\UploadFileTrait;

class MagicLoginController extends Controller
{use UploadFileTrait;
    public function showView(Request $request, $id)
    {
        $student = Student::findOrFail($id);
$postUrl = $this->generateMagicSignedRoute('student.magic.generate', 15, ['id' => $student->id]);
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

        // $student->tokens()->delete();

        $token = Str::random(64);

        Cache::put('temp_token_' . $token, $id, now()->addMinutes(10));

        Log::info("myapp://login?token=" . urlencode($token));
        $flutterDeepLink = "myapp://login?token=" . urlencode($token);

        return redirect()->away($flutterDeepLink);
    }

    public function exchangeToken(Request $request)
    {
        $request->validate([
            'token' => 'required|string'
        ]);

        $studentId = Cache::pull('temp_token_' . $request->token);

        if (!$studentId) {
            return response()->json([
                'message' => 'الرابط غير صالح، منتهي الصلاحية، أو تم استخدامه مسبقاً.'
            ], 401);
        }

        $student = Student::find($studentId);

        if (!$student) {
            return response()->json(['message' => 'الطالب غير موجود.'], 404);
        }

        $realToken = $student->createToken('mobile-app')->plainTextToken;
        return response()->json([
            'access_token' => $realToken,
            'student' => $student
        ]);
    }
}

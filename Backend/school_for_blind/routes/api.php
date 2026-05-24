<?php

use App\Http\Controllers\MagicLoginController;
use App\Http\Controllers\TeacherController;
use App\Http\Controllers\OtpController;
use App\Http\Controllers\StudentController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::post('verify-otp', [OtpController::class, 'verify']);
Route::post('register', [StudentController::class, 'register']);
Route::post('login', [StudentController::class, 'login']);
Route::post('/auth/exchange-token', [MagicLoginController::class, 'exchangeToken']);
// Route::get('magic-login/{id}', [StudentController::class, 'magicLogin'])
//     ->name('student.magic.login');
//     ->middleware('signed');

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

Route::prefix('otp')->controller(OtpController::class)->group(function () {
    Route::post('send', 'sendOtp')->name('otp.send')->middleware('throttle:3,1');
    Route::post('verify', 'verifyOtp')->name('otp.verify');
});

Route::prefix('teacher')->controller(TeacherController::class)->group(function () {
    Route::post('logout', 'logout')->middleware('auth:sanctum')->name('users.login');
    Route::post('register', 'register')->name('users.register');
    Route::post('login', 'login')->name('users.login');
});

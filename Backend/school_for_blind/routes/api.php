<?php

use App\Http\Controllers\DonationController;
use App\Http\Controllers\MagicLoginController;
use App\Http\Controllers\TeacherController;
use App\Http\Controllers\OtpController;
use App\Http\Controllers\PointExchangeController;
use App\Http\Controllers\PointRedemptionController;
use App\Http\Controllers\StudentController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\Storage;

Route::post('verify-otp', [OtpController::class, 'verify']);
Route::post('register', [StudentController::class, 'register']);
Route::post('login', [StudentController::class, 'login']);
Route::middleware(['auth:sanctum', 'CheckIsStudent'])->group(function () {

    Route::post('/logout', [StudentController::class, 'logout']);
});
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
Route::get('/students/documents/{filename}', function (Request $request, $filename) {

    if (!$request->hasValidSignature()) { abort(401, 'الرابط غير صالح'); }

    $path = 'private/students/documents/' . $filename;

    if (!Storage::exists($path)) {
        abort(404, 'الملف غير موجود في مجلد private التابع للسيرفر');
    }

    return Storage::response($path);
})->name('students.documents.show');


Route::post('/donation/checkout', [DonationController::class, 'checkout']);
Route::post('/donation/confirm', [DonationController::class, 'confirmPayment']);
Route::get('/donation/success', [DonationController::class, 'success'])->name('donation.success');
Route::get('/donation/cancel', [DonationController::class, 'cancel'])->name('donation.cancel');
Route::middleware('auth:sanctum')->group(function () {
});
Route::post('/point-redemption/request', [PointRedemptionController::class, 'store'])->middleware('auth:sanctum');
Route::prefix('admin/point-redemption')->middleware(['auth:sanctum'])->group(function () {
    Route::post('/{redemptionRequest}/approve', [PointRedemptionController::class, 'approve']);
    Route::get('/{redemptionRequest}/reject', [PointRedemptionController::class, 'reject']);
});

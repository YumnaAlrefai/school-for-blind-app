<?php

use App\Http\Controllers\TeacherController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

Route::prefix('teacher')->controller(TeacherController::class)->group(function () {
    Route::post('logout', 'logout')->middleware('auth:sanctum')->name('users.login');
    Route::post('register', 'register')->name('users.register');
    Route::post('login', 'login')->name('users.login');
    Route::post('send-otp', 'sendOtp')->name('users.sendOtp');
    Route::post('verify-otp', 'verifyOtp')->name('users.verifyOtp');
});
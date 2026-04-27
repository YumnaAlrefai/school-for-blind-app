<?php

use App\Http\Controllers\OtpController;
use App\Http\Controllers\StudentController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::post('verify-otp', [OtpController::class, 'verify']);
Route::post('register', [StudentController::class, 'register']);
Route::post('login', [StudentController::class, 'login']);

Route::get('magic-login/{id}', [StudentController::class, 'magicLogin'])
    ->name('student.magic.login');
    //->middleware('signed');
Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

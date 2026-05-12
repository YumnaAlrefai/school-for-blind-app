<?php

use App\Http\Controllers\Admin\TeacherRequestController;
use App\Http\Controllers\MagicLoginController;
use Illuminate\Support\Facades\Route;

Route::get('/home', function () {
    return view('admin.dashboard');
});

Route::get('/teacher-request', function () {
    return view('teacher.request');
})->name('teacher.request');

//Route::middleware(['auth'])->group(function () {
Route::get('/teacher-request', [TeacherRequestController::class, 'index'])->name('teacher.request');
//});

Route::get('/magic-login/{id}', [MagicLoginController::class, 'showView'])
    ->name('student.magic.view')
    ->middleware('signed');

Route::post('/magic-login/generate/{id}', [MagicLoginController::class, 'generateToken'])
    ->name('student.magic.generate')
    ->middleware('signed');
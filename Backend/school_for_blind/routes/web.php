<?php

use App\Http\Controllers\Dashboard\AuthController;
use App\Http\Controllers\Dashboard\DashboardController;
use App\Http\Controllers\MagicLoginController;
use Illuminate\Support\Facades\Route;


Route::get('/', function () {
    return view('auth.login');
})->name('login');

Route::post('/login-form', [AuthController::class, 'login'])->name('dashboard.login');

Route::middleware(['auth:admin'])->group(function () {
    Route::get('/home', [DashboardController::class, 'index'])->name('dashboard');

    Route::get('/requests', function () {
        return view('dashboard');
    })->name('requests');

    Route::get('/content-monitor', function () {
        return view('dashboard');
    })->name('content.monitor');

    Route::get('/classes', function () {
        return view('dashboard');
    })->name('classes');

    Route::get('/charts', function () {
        return view('dashboard');
    })->name('charts');

    Route::get('/logs', function () {
        return view('dashboard');
    })->name('logs');

    Route::get('/requests/{type}', [DashboardController::class, 'showRequests'])->name('requests.view');
    Route::get('/request-details/{type}/{id}', [DashboardController::class, 'getRequestDetails']);
    Route::post('/request-update-status/{type}/{id}', [DashboardController::class, 'updateStatus'])->name('requests.update');
});

Route::get('/magic-login/{id}', [MagicLoginController::class, 'showView'])
    ->name('student.magic.view')
    // ->middleware('signed')
    ;

Route::post('/magic-login/generate/{id}', [MagicLoginController::class, 'generateToken'])
    ->name('student.magic.generate')
    // ->middleware('signed')
    ;
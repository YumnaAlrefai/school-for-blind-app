<?php

use App\Http\Controllers\Dashboard\AuthController;
use App\Http\Controllers\Dashboard\DashboardController;
use App\Http\Controllers\MagicLoginController;
use App\Http\Controllers\Web\RoomWebController;
use App\Http\Middleware\CheckAdminRole;
use Illuminate\Support\Facades\Route;

/*
'Super Admin',
                'Academic Manager',
                'Moderator',
                'Support Agent',
                'Data Entry',
                'Financial Manager',
*/

Route::get('/', function () {
    return view('auth.login');
})->name('login');

Route::post('/login-form', [AuthController::class, 'login'])->name('dashboard.login');

Route::get('/magic-login/{id}', [MagicLoginController::class, 'showView'])
    ->name('student.magic.view')
    ->middleware('signed');

Route::post('/magic-login/generate/{id}', [MagicLoginController::class, 'generateToken'])
    ->name('student.magic.generate')
    ->middleware('signed');

Route::middleware([CheckAdminRole::class . ':Super Admin,Academic Manager,Moderator,Support Agent,Data Entry,Financial Manager'])->group(function () {
    Route::get('/home', [DashboardController::class, 'index'])->name('dashboard');
    Route::get('/charts', function () {
        return view('dashboard');
    })->name('charts');
    Route::get('/classes', function () {
        return view('dashboard');
    })->name('classes');
});

Route::middleware([CheckAdminRole::class . ':Super Admin,Academic Manager'])->group(function () {
    Route::get('/rooms', [RoomWebController::class, 'index'])->name('rooms.index');
    Route::get('/rooms/create', [RoomWebController::class, 'create'])->name('rooms.create');
    Route::post('/rooms', [RoomWebController::class, 'store'])->name('rooms.store');
    Route::get('/classes/{class_id}/rooms', [RoomWebController::class, 'classRooms'])->name('rooms.class');
    Route::get('/rooms/{room_name}/join', [RoomWebController::class, 'joinRoom'])->name('rooms.join');
    Route::prefix('rooms/actions')->name('rooms.actions.')->group(function () {
        Route::post('/kick', [RoomWebController::class, 'kickParticipant'])->name('kick');
        Route::post('/mute', [RoomWebController::class, 'muteParticipant'])->name('mute');
        Route::post('/unmute', [RoomWebController::class, 'unmuteParticipant'])->name('unmute');
        Route::post('/end', [RoomWebController::class, 'endCall'])->name('end');
    });
});

Route::middleware([CheckAdminRole::class . ':Super Admin,Moderator'])->group(function () {
    Route::get('/content-monitor', function () {
        return view('dashboard');
    })->name('content.monitor');
    Route::get('/logs', [DashboardController::class, 'logs'])->name('logs.index');
});


Route::middleware([CheckAdminRole::class . ':Super Admin,Academic Manager,Data Entry'])->group(function () {
    Route::get('/dashboard/students', [DashboardController::class, 'studentsList'])->name('students.index');
    Route::get('/dashboard/teachers', [DashboardController::class, 'teachersList'])->name('teachers.index');

    Route::get('/requests', function () {
        return view('dashboard');
    })->name('requests');
    Route::get('/requests/{type}', [DashboardController::class, 'showRequests'])->name('requests.view');
    Route::get('/request-details/{type}/{id}', [DashboardController::class, 'getRequestDetails']);
    Route::post('/request-update-status/{type}/{id}', [DashboardController::class, 'updateStatus'])->name('requests.update');

    Route::get('/dashboard/teachers/{id}/complete-approval', [DashboardController::class, 'showTeacherApprovalForm'])->name('teachers.approve.form');
    Route::post('/dashboard/teachers/{id}/complete-approval', [DashboardController::class, 'completeTeacherApproval'])->name('teachers.approve.submit');
});

// Route::get('/', function () {
//     return view('auth.login');
// })->name('login');

// Route::post('/login-form', [AuthController::class, 'login'])->name('dashboard.login');

// Route::middleware(['auth:admin'])->group(function () {
//     Route::get('/home', [DashboardController::class, 'index'])->name('dashboard');

//     Route::get('/requests', function () {
//         return view('dashboard');
//     })->name('requests');

//     Route::get('/content-monitor', function () {
//         return view('dashboard');
//     })->name('content.monitor');

//     Route::get('/classes', function () {
//         return view('dashboard');
//     })->name('classes');

//     Route::get('/charts', function () {
//         return view('dashboard');
//     })->name('charts');

//     Route::get('/logs', function () {
//         return view('dashboard');
//     })->name('logs');

//     Route::get('/logs', [DashboardController::class, 'logs'])->name('logs.index');
//     Route::get('/dashboard/students', [DashboardController::class, 'studentsList'])->name('students.index');
//     Route::get('/dashboard/teachers', [DashboardController::class, 'teachersList'])->name('teachers.index');

//     Route::get('/requests/{type}', [DashboardController::class, 'showRequests'])->name('requests.view');
//     Route::get('/request-details/{type}/{id}', [DashboardController::class, 'getRequestDetails']);
//     Route::post('/request-update-status/{type}/{id}', [DashboardController::class, 'updateStatus'])->name('requests.update');
//     Route::get('/dashboard/teachers/{id}/complete-approval', [DashboardController::class, 'showTeacherApprovalForm'])->name('teachers.approve.form');
//     Route::post('/dashboard/teachers/{id}/complete-approval', [DashboardController::class, 'completeTeacherApproval'])->name('teachers.approve.submit');

//     Route::middleware([CheckAdminRole::class . ':super admin,acadimec admin'])->group(function () {

//         Route::get('/rooms', [RoomWebController::class, 'index'])->name('rooms.index');
//         Route::get('/rooms/create', [RoomWebController::class, 'create'])->name('rooms.create');
//         Route::post('/rooms', [RoomWebController::class, 'store'])->name('rooms.store');
//         Route::get('/classes/{class_id}/rooms', [RoomWebController::class, 'classRooms'])->name('rooms.class');
//         Route::get('/rooms/{room_name}/join', [RoomWebController::class, 'joinRoom'])->name('rooms.join');

//         Route::prefix('rooms/actions')->name('rooms.actions.')->group(function () {
//             Route::post('/kick', [RoomWebController::class, 'kickParticipant'])->name('kick');
//             Route::post('/mute', [RoomWebController::class, 'muteParticipant'])->name('mute');
//             Route::post('/unmute', [RoomWebController::class, 'unmuteParticipant'])->name('unmute');
//             Route::post('/end', [RoomWebController::class, 'endCall'])->name('end');
//         });

//     });
// });

// Route::get('/magic-login/{id}', [MagicLoginController::class, 'showView'])
//     ->name('student.magic.view')
//     ->middleware('signed');

// Route::post('/magic-login/generate/{id}', [MagicLoginController::class, 'generateToken'])
//     ->name('student.magic.generate')
//     ->middleware('signed');
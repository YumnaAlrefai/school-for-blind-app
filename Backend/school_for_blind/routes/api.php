<?php

use App\Http\Controllers\AnnouncementController;
use App\Http\Controllers\CaregiverController;
use App\Http\Controllers\DonationController;
use App\Http\Controllers\LessonController;
use App\Http\Controllers\MagicLoginController;
use App\Http\Controllers\OtpController;
use App\Http\Controllers\PointExchangeController;
use App\Http\Controllers\PointRedemptionController;
use App\Http\Controllers\QuizController;
use App\Http\Controllers\RoomController;
use App\Http\Controllers\StudentController;
use App\Http\Controllers\TeacherController;
use App\Http\Middleware\CheckAdminRole;
use App\Http\Middleware\CheckCallCreatorRole;
use App\Http\Middleware\PreventStudentCallActions;
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
    Route::post('register', 'register')->name('users.register');
    Route::post('login', 'login')->name('users.login');
    Route::middleware('auth:sanctum')->group(function () {
        Route::post('logout', 'logout')->name('teachers.logout');
        Route::get('info', 'info')->name('teachers.info');
        // Route::get('cv', 'showCv')->name('teachers.cv');
    });
});

Route::post('/caregiver/login', [CaregiverController::class, 'login']);
Route::middleware('auth:sanctum')->group(function () {
    Route::post('/caregiver/logout', [CaregiverController::class, 'logout']);
});

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
Route::prefix('call')->middleware('auth:sanctum')->group(function () {
    Route::get('/active-calls', [RoomController::class, 'getActiveCallsForStudent']);
    Route::post('/start', [RoomController::class, 'startCall'])->middleware(CheckCallCreatorRole::class);
    Route::post('/join', [RoomController::class, 'joinCall']);
    Route::middleware(PreventStudentCallActions::class)->group(function () {
        Route::post('/kick', [RoomController::class, 'kickParticipant']);
        Route::post('/mute', [RoomController::class, 'muteParticipant']);
        Route::post('/end', [RoomController::class, 'endCall']);
        Route::post('/unmute-participant', [RoomController::class, 'unmuteParticipant']);
    });
});

Route::prefix('quizzes')->group(function () {
    Route::middleware(['auth:sanctum', 'isTeacher'])->group(function () {
        Route::post('/', [QuizController::class, 'store']);
        Route::get('/teacher/list', [QuizController::class, 'index']);
        Route::put('/{id}', [QuizController::class, 'update']);
        Route::delete('/{id}', [QuizController::class, 'destroy']);
        Route::get('{lessonId}/quiz', [QuizController::class, 'getQuizByLesson']);
    });
    // Route::middleware(['auth:sanctum', 'CheckIsStudent'])->group(function () {
    // });
    Route::middleware('auth:sanctum')->group(function () {
        Route::post('/{id}/submit', [QuizController::class, 'submitQuiz']);
        Route::get('/{id}/student-view', [QuizController::class, 'getStudentQuiz']);
        Route::get('/{id}', [QuizController::class, 'show']);
        Route::get('/{quiz_id}/students/{student_id}/answers', [QuizController::class, 'getStudentAnswers']);
    });
});

Route::middleware('auth:sanctum')
    ->prefix('lessons')
    ->controller(LessonController::class)
    ->group(function () {
        Route::get('/', 'index');
        Route::post('/', 'store');
        Route::get('{lesson}', 'show');
        Route::match(['put', 'patch'], '{lesson}', 'update');
        Route::delete('{lesson}', 'destroy');
    });
   Route::post('/announcements', [AnnouncementController::class, 'store']);
   Route::get('/announcements', [AnnouncementController::class, 'index']);
Route::get('/announcements/exam/{id}', [AnnouncementController::class, 'showExam']);

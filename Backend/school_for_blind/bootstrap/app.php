<?php

use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;
use Symfony\Component\HttpFoundation\Response;
use Illuminate\Auth\AuthenticationException;
return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(
        channels: __DIR__.'/../routes/channels.php',
        web: __DIR__ . '/../routes/web.php',
        api: __DIR__ . '/../routes/api.php',
        commands: __DIR__ . '/../routes/console.php',
        health: '/up',
    )
    ->withMiddleware(function (Middleware $middleware): void {
        $middleware->trustProxies(at: '*');
        $middleware->alias([
            'admin.role' => \App\Http\Middleware\CheckAdminRole::class,
            'CheckIsStudent' => \App\Http\Middleware\CheckIsStudent::class,
            'isTeacher' => \App\Http\Middleware\IsTeacher::class,
            'CheckPunishment' => \App\Http\Middleware\CheckPunishment::class,
        ]);
    })
    ->withExceptions(function (Exceptions $exceptions): void {
        $exceptions->render(function (AuthenticationException $e, $request) {
            if ($request->is('api/*')) {
                return response()->json([
                    'success' => false,
                    'logged_out' => true,
                    'message' => ' عذراً، انتهت صلاحية الجلسة أو تم تسجيل الخروج مسبقاً. يرجى العودة لصفحة تسجيل الدخول'
                ], Response::HTTP_UNAUTHORIZED, [], JSON_UNESCAPED_UNICODE);
            }
        });
    })->create();

<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Log;
use Symfony\Component\HttpFoundation\Response;

class CheckUserType
{
    /**
     * Handle an incoming request.
     */
    public function handle(Request $request, Closure $next, ...$guards): Response
    {

        foreach ($guards as $guard) {
           Log::info("Checking guard: " . $guard);
            
            // 1. استخدام الأقواس () واستخدام الـ guard الحالي
            $user = Auth::guard($guard)->user(); 
            
            // 2. فحص ما إذا كان المستخدم موجوداً قبل استدعاء get_class
            if ($user) {
                Log::info("User class: " . get_class($user));
            } else {
                Log::info("No user found for guard: " . $guard);
            }
            if (Auth::guard($guard)->check()) {

                Auth::shouldUse($guard);

                return $next($request);
            }
        }

        return response()->json([
            'message' => 'غير مصرح لك بالوصول لهذا المسار.'
        ], 403);
    }
}
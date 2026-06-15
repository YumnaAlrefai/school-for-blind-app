<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Symfony\Component\HttpFoundation\Response;

class CheckUserType
{
    /**
     * Handle an incoming request.
     */
    public function handle(Request $request, Closure $next, ...$guards): Response
    {

        foreach ($guards as $guard) {
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
<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Symfony\Component\HttpFoundation\Response;

class CheckAdminRole
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     * @param  mixed  ...$roles
     */
    public function handle(Request $request, Closure $next, ...$roles): Response
    {
        if (!Auth::guard('admin')->check()) {
            return redirect()->route('login'); 
            // return response()->json(['message' => 'Unauthenticated.'], 401);
        }

        $admin = Auth::guard('admin')->user();

        if (!in_array($admin->role, $roles)) {
            abort(403, 'ليس لديك الصلاحية للوصول إلى هذه الصفحة.');
        }

        return $next($request);
    }
}
<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class CheckCallCreatorRole
{
    public function handle(Request $request, Closure $next): Response
    {
        $allowedRoles = [
            'App\Models\Teacher',
            'App\Models\Admin'
        ];

        if (!in_array(get_class(auth()->user()), $allowedRoles)) {
            return response()->json(['error' => 'غير مصرح لك بإنشاء مكالمة'], 403);
        }

        return $next($request);
    }
}
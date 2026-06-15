<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class PreventStudentCallActions
{
    public function handle(Request $request, Closure $next): Response
    {
        $user = auth()->user();
        if (get_class($user) === 'App\Models\Student') {
            return response()->json([
                'error' => 'غير مصرح لك بالقيام بهذا الإجراء (كتم، طرد، أو إنهاء المكالمة)'
            ], 403);
        }
        return $next($request);
    }
}
<?php

namespace App\Http\Middleware;

use App\Models\Teacher;
use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class IsTeacher
{
    /**
     * Handle an incoming request.
     *
     * @param  Closure(Request): (Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        if ($request->user() && $request->user() instanceof Teacher) {

            return $next($request);
        }

        return response()->json([
            'success' => false,
            'message' => 'عذراً، هذا المسار مخصص للأساتذة فقط. لا تملك الصلاحية للدخول.'
        ], Response::HTTP_FORBIDDEN, [], JSON_UNESCAPED_UNICODE);
    }
}

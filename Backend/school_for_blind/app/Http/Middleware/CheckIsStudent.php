<?php

namespace App\Http\Middleware;

use App\Models\Student;
use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class CheckIsStudent
{
    /**
     * Handle an incoming request.
     *
     * @param  Closure(Request): (Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        if ($request->user() && $request->user() instanceof Student) {

            return $next($request);
        }

        return response()->json([
            'success' => false,
            'message' => 'عذراً، هذا المسار مخصص للطلاب فقط. لا تملك الصلاحية للدخول.'
        ], Response::HTTP_FORBIDDEN, [], JSON_UNESCAPED_UNICODE);
    }
}

<?php
namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Carbon;
use Symfony\Component\HttpFoundation\Response;

class CheckPunishment
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure  $next
     * @param  string  $punishmentName
     * @return mixed
     */
    public function handle(Request $request, Closure $next, $punishmentName): Response
    {
        $user = $request->user();

        if (!$user) {
            return response()->json([
                'success' => false,
                'message' => 'غير مصرح لك بالوصول.'
            ], Response::HTTP_UNAUTHORIZED);
        }

        $hasActivePunishment = DB::table('punishables')
            ->join('punishments', 'punishables.punishment_id', '=', 'punishments.id')
            ->where('punishables.punishable_id', $user->id)
            ->where('punishables.punishable_type', get_class($user))
            ->where('punishments.name', 'LIKE', '%' . $punishmentName . '%')
            ->where(function ($query) {
                $query->whereNull('punishables.expires_at')
                    ->orWhere('punishables.expires_at', '>', Carbon::now());
            })
            ->exists();

        if ($hasActivePunishment) {
            return response()->json([
                'success' => false,
                'message' => "عذراً، تم تقييد حسابك. لا يمكنك القيام بهذا الإجراء بسبب وجود عقوبة: {$punishmentName}.",
            ], Response::HTTP_FORBIDDEN, [], JSON_UNESCAPED_UNICODE);
        }

        return $next($request);
    }
}
<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Punishment;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class PunishmentController extends Controller
{
    private $modelMap = [
        'student' => \App\Models\Student::class,
        'teacher' => \App\Models\Teacher::class,
        'parent' => \App\Models\ParentModel::class,
    ];

    public function applyPunishment(Request $request)
    {
        $request->validate([
            'punishable_id' => 'required|integer',
            'punishable_type' => 'required|in:student,teacher,parent',
            'punishment_id' => 'required|exists:punishments,id',
        ]);

        $admin = Auth::guard('admin')->user();
        $punishment = Punishment::findOrFail($request->punishment_id);

        $expiresAt = $punishment->duration_minutes
            ? Carbon::now()->addMinutes($punishment->duration_minutes)
            : null;

        $appliedPunishment = DB::table('punishables')->insert([
            'punishment_id' => $punishment->id,
            'punishable_id' => $request->punishable_id,
            'punishable_type' => $this->modelMap[$request->punishable_type],
            'admin_id' => $admin->id,
            'expires_at' => $expiresAt,
            'created_at' => Carbon::now(),
            'updated_at' => Carbon::now(),
        ]);

        if ($punishment->name === 'Warning' && $request->punishable_type === 'student') {
            // TODO: Trigger Notification to Parent App
        }

        return response()->json([
            'success' => true,
            'message' => "تم تطبيق عقوبة ({$punishment->name}) بنجاح.",
            'expires_at' => $expiresAt
        ], 201);
    }

    public function revokePunishment($id)
    {
        DB::table('punishables')
            ->where('id', $id)
            ->update(['expires_at' => Carbon::now()]);

        return response()->json([
            'success' => true,
            'message' => 'تم فك العقوبة عن المستخدم بنجاح.'
        ]);
    }
}

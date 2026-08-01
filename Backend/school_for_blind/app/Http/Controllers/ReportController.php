<?php

namespace App\Http\Controllers;

use App\Models\Report;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class ReportController extends Controller
{
    private $userModelMap = [
        'student' => \App\Models\Student::class,
        'teacher' => \App\Models\Teacher::class,
        'admin' => \App\Models\Admin::class,
        'parent' => \App\Models\ParentModel::class,
    ];

    private $reportableModelMap = [
        'message' => \App\Models\Message::class,
        'material' => \App\Models\Material::class,
        'quiz' => \App\Models\Quiz::class,
    ];

    public function store(Request $request)
    {
        $request->validate([
            'reported_id' => 'required|integer',
            'reported_type' => 'required|in:student,teacher,admin,parent',
            'reason' => 'required|string|max:1000',

            'reportable_id' => 'nullable|integer',
            'reportable_type' => 'nullable|in:message,material,quiz',
        ]);

        $reporter = Auth::user();

        $reportableId = $request->reportable_id;
        $reportableType = $request->reportable_type ? $this->reportableModelMap[$request->reportable_type] : null;

        $report = Report::create([
            'reporter_id' => $reporter->id,
            'reporter_type' => get_class($reporter),
            'reported_id' => $request->reported_id,
            'reported_type' => $this->userModelMap[$request->reported_type],
            'reason' => $request->reason,
            'status' => 'pending',

            'reportable_id' => $reportableId,
            'reportable_type' => $reportableType,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'تم إرسال البلاغ مع الدليل بنجاح وجاري مراجعته من قبل الإدارة.',
            'data' => $report
        ], 201);
    }

    public function index(Request $request)
    {
        $reports = Report::with(['reporter', 'reported', 'reportable'])
            ->when($request->status, function ($query, $status) {
                return $query->where('status', $status);
            })
            ->latest()
            ->paginate(20);

        return response()->json($reports);
    }

    public function updateStatus(Request $request, $id)
    {
        $request->validate([
            'status' => 'required|in:pending,reviewed,dismissed'
        ]);

        $report = Report::findOrFail($id);
        $report->update(['status' => $request->status]);

        return response()->json([
            'success' => true,
            'message' => 'تم تحديث حالة البلاغ بنجاح.',
            'data' => $report
        ]);
    }
}
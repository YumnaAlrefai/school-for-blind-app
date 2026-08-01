<?php

namespace App\Http\Controllers;

use App\Models\PointRedemptionRequest;
use App\Services\PointRedemptionService;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class PointRedemptionController extends Controller
{
    private PointRedemptionService $redemptionService;

    public function __construct(PointRedemptionService $redemptionService)
    {
        $this->redemptionService = $redemptionService;
    }

    public function store(Request $request)
    {
        $request->validate([
            'points' => 'required|integer|min:1',
        ]);

        try {
            $student = Auth::user();

            $redemptionRequest = $this->redemptionService->createRequest($student, $request->points);

            return response()->json([
                'success' => true,
                'message' => 'تم إرسال طلب استبدال النقاط بنجاح وهو قيد الانتظار حالياً.',
                'data' => $redemptionRequest
            ], 201);

        } catch (Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 422);
        }
    }

    
  public function approve(Request $request, PointRedemptionRequest $redemptionRequest){
    if (!Auth::user()->is_admin) {
        return response()->json([
            'success' => false,
            'message' => 'عذراً، لا تملك الصلاحيات الكافية للقيام بهذا الإجراء.'
        ], 403);}
        $request->validate([
            'amount_paid' => 'required|numeric|min:0',
        ]);

        try {
            $updatedRequest = $this->redemptionService->approveRequest($redemptionRequest, $request->amount_paid);

            return response()->json([
                'success' => true,
                'message' => 'تم قبول الطلب، وخصم النقاط من الطالب، وتحديث رصيد المدرسة بنجاح!',
                'data' => $updatedRequest
            ], 200);

        } catch (Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 422);
        }
    }
    public function reject(Request $request, PointRedemptionRequest $redemptionRequest)
    {
        if (!Auth::user()->is_admin) {
            return response()->json([
                'success' => false,
                'message' => 'عذراً، لا تملك الصلاحيات الكافية للقيام بهذا الإجراء.'
            ], 403);
        }
        $request->validate([
            'admin_notes' => 'required|string|max:255',
        ]);
        try {
            $updatedRequest = $this->redemptionService->rejectRequest($redemptionRequest);

            return response()->json([
                'success' => true,
                'message' => 'تم رفض الطلب بنجاح.',
                'data' => $updatedRequest
            ], 200);

        } catch (Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 422);
        }
    }
}


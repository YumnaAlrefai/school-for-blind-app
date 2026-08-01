<?php

namespace App\Http\Controllers;

use App\Models\Caregiver;
use App\Http\Requests\StoreCaregiverRequest;
use App\Http\Requests\UpdateCaregiverRequest;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Exception; 

class CaregiverController extends Controller
{
    public function login(UpdateCaregiverRequest $request)
    {
        $validated = $request->validated();

        try {
            $caregiver = Caregiver::where('phone', '=', $validated['phone'], 'and')->first();
            if (!$caregiver || !Hash::check($validated['password'], $caregiver->password)) {
                return response()->json([
                    'success' => false,
                    'message' => 'بيانات الاعتماد غير صحيحة، يرجى التأكد من رقم الهاتف أو كلمة المرور المرسلة.'
                ], 401);
            }

            if (!empty($validated['fcm_token'])) {
                $caregiver->update([
                    'fcm_token' => $validated['fcm_token']
                ]);
            }

           $caregiver->tokens()->delete();

            $token = $caregiver->createToken('caregiver_auth_token')->plainTextToken;

            return response()->json([
                'success' => true,
                'message' => 'تم تسجيل الدخول بنجاح.',
                'data'    => [
                    'user' => [
                        'id'        => $caregiver->id,
                        'phone'     => $caregiver->phone,
                        'fcm_token' => $caregiver->fcm_token,
                    ],
                    'token' => $token,
                ]
            ], 200);

        } catch (Exception $e) { 
            return response()->json([
                'success' => false,
                'message' => 'حدث خطأ غير متوقع أثناء معالجة الطلب، يرجى المحاولة لاحقاً.',
                'error'   => config('app.debug') ? $e->getMessage() : null
            ], 500);
        }
    }

    
    public function logout(Request $request)
    {
        try {
            $caregiver = $request->user();

            $caregiver->update([
                'fcm_token' => null
            ]);

            $caregiver->currentAccessToken()->delete();

            return response()->json([
                'success' => true,
                'message' => 'تم تسجيل الخروج بنجاح .'
            ], 200);

        } catch (Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'فشل تسجيل الخروج، يرجى إعادة المحاولة.',
            ], 500);
        }
    }

    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        //
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(StoreCaregiverRequest $request)
    {
        //
    }

    /**
     * Display the specified resource.
     */
    public function show(Caregiver $caregiver)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Caregiver $caregiver)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(UpdateCaregiverRequest $request, Caregiver $caregiver)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Caregiver $caregiver)
    {
        //
    }
}
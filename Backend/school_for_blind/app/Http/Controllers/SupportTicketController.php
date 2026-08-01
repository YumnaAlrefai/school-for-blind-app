<?php

namespace App\Http\Controllers;

use App\Http\Requests\StoreSupportTicketRequest;
use App\Models\SupportTicket;
use App\Traits\RecordUploadTrait;
use App\Traits\UploadFileTrait;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class SupportTicketController extends Controller
{use RecordUploadTrait, UploadFileTrait;
public function store(StoreSupportTicketRequest $request): JsonResponse  
    {
        $validated = $request->validated();
        // get the authenticated user object (not just the id)
        $user = Auth::user();
        $senderType = strtolower(class_basename($user));
        $audioPath = null;
        $imagePath = null;

     if ($request->hasFile('audio')) {
            $audioPath = $this->uploadRecord($request->file('audio'), 'support/audios');
        }

        if ($request->hasFile('image')) {
            $imagePath = $this->uploadFile($request->file('image'), 'support/images');
        }

        $ticket = SupportTicket::create([
           'sender_id'    => $user->id,        
            'sender_type'  => $senderType,     
            'text_content' => $validated['text_content'] ?? null,
            'audio_path'   => $audioPath,
            'image_path'   => $imagePath,
            'status'       => 'pending', 
        ]);

        return response()->json([
            'success' => true,
            'message' => 'تم إرسال تذكرة الدعم بنجاح.',
            'data'    => $ticket
        ], 201);
    }





}

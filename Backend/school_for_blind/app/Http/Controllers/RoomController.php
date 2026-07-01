<?php

namespace App\Http\Controllers;

use App\Http\Requests\Room\EndCallRequest;
use App\Http\Requests\Room\JoinCallRequest;
use App\Http\Requests\Room\KickParticipantRequest;
use App\Http\Requests\Room\MuteParticipantRequest;
use App\Http\Requests\Room\StartCallRequest;
use App\Http\Requests\Room\UnmuteParticipantRequest;
use App\Models\Room;
use App\Services\RoomService;
use Illuminate\Routing\Controller;

class RoomController extends Controller
{
    protected $roomService;

    public function __construct(RoomService $roomService)
    {
        $this->roomService = $roomService;
    }

    public function startCall(StartCallRequest $request)
    {
        $user = auth()->user();
        $creatorType = get_class($user);
        $userRole = ($creatorType === 'App\Models\Admin') ? 'Admin' : 'Teacher';
        $userName = ($userRole === 'Teacher' ? $user->full_name : $user->name);

        $identity = $userRole . '--' . $user->id;

        $existingRoom = Room::where('creator_id', $user->id)
            ->where('creator_type', $creatorType)
            ->where('status', 'active')
            ->first();

        if ($existingRoom) {
            $canPublish = true;

            $mutedParticipants = $existingRoom->muted_participants ?? [];
            if (in_array($identity, $mutedParticipants)) {
                $canPublish = false;
            }

            $token = $this->roomService->generateToken($user, $existingRoom->room_name, $userRole, $canPublish, true);

            return response()->json([
                'message' => 'لديك مكالمة نشطة بالفعل، تم إعادة توليد توكن الانضمام بنجاح',
                'room_name' => $existingRoom->room_name,
                'token' => $token,
            ]);
        }

        $room = Room::create([
            'creator_id' => $user->id,
            'creator_type' => $creatorType,
            'class_id' => $request->class_id,
            'room_name' => $request->room_name,
            'status' => 'active',
            'muted_participants' => [],
        ]);

        $token = $this->roomService->generateToken($user, $room->room_name, $userRole, true, true);

        return response()->json([
            'message' => 'تم إنشاء الغرفة بنجاح',
            'room_name' => $room->room_name,
            'token' => $token,
        ]);
    }

    public function joinCall(JoinCallRequest $request)
    {
        $user = auth()->user();
        $userType = get_class($user);
        $userRole = ($userType === 'App\Models\Student' ? 'Student' : ($userType === 'App\Models\Teacher' ? 'Teacher' : 'Admin'));

        $identity = $userRole . '--' . $user->id;

        $room = Room::where('room_name', $request->room_name)->first();
        $canPublish = true;

        if ($room) {
            $mutedParticipants = $room->muted_participants ?? [];
            if (in_array($identity, $mutedParticipants)) {
                $canPublish = false;
            }
        }

        $token = $this->roomService->generateToken($user, $request->room_name, $userRole, $canPublish, false);

        return response()->json([
            'message' => 'تم توليد توكن الانضمام بنجاح',
            'room_name' => $request->room_name,
            'token' => $token,
        ]);
    }

    public function kickParticipant(KickParticipantRequest $request)
    {
        $targetRole = ($request->target_type === 'App\Models\Student') ? 'Student' : (($request->target_type === 'App\Models\Teacher') ? 'Teacher' : 'Admin');
        $targetIdentity = $targetRole . '--' . $request->target_id;

        try {
            $this->roomService->kickParticipant($request->room_name, $targetIdentity);

            $room = $request->roomModel ?? Room::where('room_name', $request->room_name)->first();
            if ($room) {
                $kicked = $room->kicked_participants ?? [];
                if (!in_array($targetIdentity, $kicked)) {
                    $kicked[] = $targetIdentity;
                    $room->kicked_participants = $kicked;
                    $room->save();
                }
            }

            return response()->json(['message' => 'تم طرد المستخدم ومنعه من العودة بنجاح']);
        } catch (\Exception $e) {
            return response()->json(['error' => 'حدث خطأ أثناء تنفيذ عملية الطرد'], 500);
        }
    }

    public function muteParticipant(MuteParticipantRequest $request)
    {
        $targetRole = ($request->target_type === 'App\Models\Student') ? 'Student' : (($request->target_type === 'App\Models\Teacher') ? 'Teacher' : 'Admin');
        $targetIdentity = $targetRole . '--' . $request->target_id;

        try {
            $this->roomService->muteParticipant($request->room_name, $targetIdentity, $request->track_sid);

            $room = Room::where('room_name', $request->room_name)->first();
            if ($room) {
                $muted = $room->muted_participants ?? [];
                if (!in_array($targetIdentity, $muted)) {
                    $muted[] = $targetIdentity;
                    $room->muted_participants = $muted;
                    $room->save();
                }
            }

            return response()->json(['message' => 'تم كتم المستخدم بنجاح وسحب صلاحية التحدث']);
        } catch (\Exception $e) {
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }

    public function unmuteParticipant(UnmuteParticipantRequest $request)
    {
        $targetRole = ($request->target_type === 'App\Models\Student') ? 'Student' : (($request->target_type === 'App\Models\Teacher') ? 'Teacher' : 'Admin');
        $targetIdentity = $targetRole . '--' . $request->target_id;

        try {
            $this->roomService->unmuteParticipant($request->room_name, $targetIdentity);

            $room = Room::where('room_name', $request->room_name)->first();
            if ($room) {
                $muted = $room->muted_participants ?? [];
                if (($key = array_search($targetIdentity, $muted)) !== false) {
                    unset($muted[$key]);
                    $room->muted_participants = array_values($muted);
                    $room->save();
                }
            }

            return response()->json(['message' => 'تم فك الكتم عن المستخدم بنجاح']);
        } catch (\Exception $e) {
            return response()->json(['error' => 'حدث خطأ أثناء فك الكتم: ' . $e->getMessage()], 500);
        }
    }

    public function endCall(EndCallRequest $request)
    {
        $room = $request->roomModel ?? Room::where('room_name', $request->room_name)->first();

        try {
            $this->roomService->endCall($request->room_name);

            if ($room) {
                $room->status = 'ended';
                $room->ended_at = now();
                $room->save();
            }

            return response()->json(['message' => 'تم إنهاء الدرس وإغلاق الغرفة بنجاح']);
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'فشل إنهاء الغرفة في سيرفر البث',
                'details' => $e->getMessage(),
            ], 500);
        }
    }

    public function getActiveCallsForStudent()
    {
        $user = auth()->user();
        if (get_class($user) !== 'App\Models\Student') {
            return response()->json(['error' => 'هذا الإجراء مخصص للطلاب فقط'], 403);
        }

        $activeCalls = Room::where('class_id', $user->class_id)
            ->where('status', 'active')
            ->with([
                'creator' => function ($query) {
                    $query->select('id', 'full_name');
                }
            ])->latest()->get();

        return response()->json([
            'message' => 'المكالمات الجارية حالياً لشعبتك',
            'data' => $activeCalls
        ], 200);
    }
}
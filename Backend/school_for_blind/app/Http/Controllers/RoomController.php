<?php

namespace App\Http\Controllers;

use Agence104\LiveKit\AccessToken;
use Agence104\LiveKit\AccessTokenOptions;
use Agence104\LiveKit\RoomServiceClient;
use Agence104\LiveKit\VideoGrant;
use App\Http\Requests\Room\EndCallRequest;
use App\Http\Requests\Room\JoinCallRequest;
use App\Http\Requests\Room\KickParticipantRequest;
use App\Http\Requests\Room\MuteParticipantRequest;
use App\Http\Requests\Room\StartCallRequest;
use App\Models\Room;
use Illuminate\Routing\Controller;
use Livekit\ParticipantPermission;

class RoomController extends Controller
{

    public function startCall(StartCallRequest $request)
    {
        $user = auth()->user();
        $creatorType = get_class($user);
        $userRole = ($creatorType === 'App\Models\Admin') ? 'Admin' : 'Teacher';
        $userName = ($userRole === 'Teacher' ? $user->full_name : $user->name);

        // إنشاء الغرفة
        $room = Room::create([
            'creator_id' => $user->id,
            'creator_type' => $creatorType,
            'class_id' => $request->class_id,
            'room_name' => $request->room_name,
            'status' => 'active',
        ]);

        $tokenOptions = (new AccessTokenOptions())
            ->setIdentity($userRole . '--' . $user->id)
            ->setName($userName)
            ->setMetadata(json_encode(['role' => $userRole]));

        $videoGrant = (new VideoGrant())
            ->setRoomJoin(true)->setRoomName($room->room_name)
            ->setRoomAdmin(true)->setCanPublish(true)->setCanSubscribe(true);

        $token = (new AccessToken(config('livekit.api_key'), config('livekit.api_secret')))->init($tokenOptions)->setGrant($videoGrant)->toJwt();

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
        $userName = ($userRole === 'Student' ? $user->fullname : ($userRole === 'Teacher' ? $user->full_name : $user->name));

        $tokenOptions = (new AccessTokenOptions())
            ->setIdentity($userRole . '--' . $user->id)
            ->setName($userName)
            ->setMetadata(json_encode(['role' => $userRole]));

        $videoGrant = (new VideoGrant())
            ->setRoomJoin(true)->setRoomName($request->room_name)
            ->setRoomAdmin(false)->setCanPublish(false)->setCanSubscribe(true);

        $token = (new AccessToken(config('livekit.api_key'), config('livekit.api_secret')))
            ->init($tokenOptions)->setGrant($videoGrant)->toJwt();

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
            $svc = new RoomServiceClient(
                config('livekit.url'),
                config('livekit.api_key'),
                config('livekit.api_secret')
            );
            $svc->removeParticipant($request->room_name, $targetIdentity);

            $room = $request->roomModel;
            $kicked = $room->kicked_participants ?? [];
            if (!in_array($targetIdentity, $kicked)) {
                $kicked[] = $targetIdentity;
                $room->kicked_participants = $kicked;
                $room->save();
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
            $svc = new RoomServiceClient(
                config('livekit.url'),
                config('livekit.api_key'),
                config('livekit.api_secret')
            );
            $svc->mutePublishedTrack($request->room_name, $targetIdentity, $request->track_sid, true);

            $permissions = new ParticipantPermission();
            $permissions->setCanPublish(false)->setCanSubscribe(true);
            $svc->updateParticipant($request->room_name, $targetIdentity, null, $permissions);

            return response()->json(['message' => 'تم كتم المستخدم بنجاح وسحب صلاحية التحدث']);
        } catch (\Exception $e) {
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }

    public function endCall(EndCallRequest $request)
    {
        $room = $request->roomModel;

        try {
            $svc = new RoomServiceClient(
                config('livekit.url'),
                config('livekit.api_key'),
                config('livekit.api_secret')
            );
            $svc->deleteRoom($request->room_name);

            $room->status = 'ended';
            $room->ended_at = now();
            $room->save();

            return response()->json(['message' => 'تم إنهاء الدرس وإغلاق الغرفة بنجاح']);
        } catch (\Exception $e) {
            return response()->json(['error' => 'فشل إنهاء الغرفة في سيرفر البث'], 500);
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

    public function unmuteParticipant(UnmuteParticipantRequest $request)
    {
        $targetRole = ($request->target_type === 'App\Models\Student') ? 'Student' : (($request->target_type === 'App\Models\Teacher') ? 'Teacher' : 'Admin');
        $targetIdentity = $targetRole . '--' . $request->target_id;

        try {
            $svc = new RoomServiceClient(
                config('livekit.url'),
                config('livekit.api_key'),
                config('livekit.api_secret')
            );
            $permissions = new ParticipantPermission();
            $permissions->setCanPublish(true)->setCanSubscribe(true);

            $svc->updateParticipant($request->room_name, $targetIdentity, null, $permissions);

            return response()->json(['message' => 'تم فك الكتم عن المستخدم بنجاح']);
        } catch (\Exception $e) {
            return response()->json(['error' => 'حدث خطأ أثناء فك الكتم: ' . $e->getMessage()], 500);
        }
    }
}
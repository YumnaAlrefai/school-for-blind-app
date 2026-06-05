<?php

namespace App\Http\Controllers;

use Agence104\LiveKit\AccessToken;
use Agence104\LiveKit\AccessTokenOptions;
use Agence104\LiveKit\VideoGrant;
use App\Http\Controllers\Controller;
use App\Http\Requests\StoreRoomRequest;
use App\Http\Requests\UpdateRoomRequest;
use App\Models\Room;
use Illuminate\Http\Request;
use Agence104\LiveKit\RoomServiceClient;

class RoomController extends Controller
{
    public function startCall(Request $request)
    {
        $request->validate([
            'room_name' => 'required|string|unique:rooms,room_name',
        ]);

        $user = auth()->user();
        $creatorType = get_class($user);

        if ($creatorType === 'App\Models\Student') {
            return response()->json(['error' => 'غير مصرح للطلاب إنشاء مكالمة'], 403);
        }


        $room = Room::create([
            'creator_id' => $user->id,
            'creator_type' => $creatorType,
            'room_name' => $request->room_name,
            'status' => 'active',
        ]);



        $userRole = ($creatorType === 'App\Models\Admin') ? 'Admin' : 'Teacher';
        $userName = ($userRole === 'Teacher' ? $user->full_name : $user->name);

        $tokenOptions = (new AccessTokenOptions())
            ->setIdentity((string) $user->id . '' . $userRole)
            ->setName($userName)
            ->setMetadata(json_encode(['role' => $userRole]));

        $videoGrant = (new VideoGrant())
            ->setRoomJoin(true)
            ->setRoomName($room->room_name)
            ->setRoomAdmin(false)
            ->setCanPublish(true)
            ->setCanSubscribe(true);

        $token = (new AccessToken(env('LIVEKIT_API_KEY'), env('LIVEKIT_API_SECRET')))
            ->init($tokenOptions)
            ->setGrant($videoGrant)
            ->toJwt();

        return response()->json([
            'message' => 'تم إنشاء الغرفة بنجاح',
            'room_name' => $room->room_name,
            'token' => $token,
        ]);
    }

    public function joinCall(Request $request)
    {
        $request->validate([
            'room_name' => 'required|string',
        ]);

        $room = Room::where('room_name', $request->room_name)
            ->where('status', 'active')
            ->first();

        if (!$room) {
            return response()->json(['error' => 'الغرفة غير موجودة أو انتهت المكالمة'], 404);
        }

        $user = auth()->user();
        $participantType = get_class($user);
        $userRole = ($participantType === 'App\Models\Student' ? 'Student' : ($participantType === 'App\Models\Teacher' ? 'Teacher' : 'Admin'));
        $userName = ($userRole === 'Student' ? $user->fullname : ($userRole === 'Teacher' ? $user->full_name : $user->name));

        $tokenOptions = (new AccessTokenOptions())
            ->setIdentity((string) $user->id . '' . $userRole)
            ->setName($userName)
            ->setMetadata(json_encode(['role' => $userRole]));

        $videoGrant = (new VideoGrant())
            ->setRoomJoin(true)
            ->setRoomName($room->room_name)
            ->setRoomAdmin(false)
            ->setCanPublish(true)
            ->setCanSubscribe(true);

        $token = (new AccessToken(env('LIVEKIT_API_KEY'), env('LIVEKIT_API_SECRET')))
            ->init($tokenOptions)
            ->setGrant($videoGrant)
            ->toJwt();

        return response()->json([
            'message' => 'تم توليد توكن الانضمام بنجاح',
            'room_name' => $room->room_name,
            'token' => $token,
        ]);
    }

    public function kickParticipant(Request $request)
    {
        $request->validate([
            'room_name' => 'required|string',
            'target_id' => 'required|integer',
            'target_type' => 'required|string',
        ]);

        $user = auth()->user();
        $requesterType = get_class($user);

        if ($requesterType === 'App\Models\Student') {
            return response()->json(['error' => 'ليس لديك صلاحية'], 403);
        }

        if ($requesterType === 'App\Models\Teacher' && $request->target_type === 'App\Models\Admin') {
            return response()->json(['error' => 'غير مصرح'], 403);
        }

        try {
            $svc = new RoomServiceClient(
                env('LIVEKIT_URL'),
                env('LIVEKIT_API_KEY'),
                env('LIVEKIT_API_SECRET')
            );

            $targetRole = ($request->target_type === 'App\Models\Student') ? 'Student' : (($request->target_type === 'App\Models\Teacher') ? 'Teacher' : 'Admin');
            $targetIdentity = $request->target_id . '' . $targetRole;

            \Log::info('' . $targetIdentity);
            \Log::info('' . $request->target_type);

            $svc->removeParticipant($request->room_name, (string) $targetIdentity);

            return response()->json(['message' => 'success']);

        } catch (\Exception $e) {
            return response()->json(['error' => 'server_error'], 500);
        }
    }

    public function muteParticipant(Request $request)
    {
        $request->validate([
            'room_name' => 'required|string',
            'target_id' => 'required|integer',
            'target_type' => 'required|string',
            'track_sid' => 'required|string',
        ]);

        $user = auth()->user();
        $requesterType = get_class($user);

        if ($requesterType === 'App\Models\Student') {
            return response()->json(['error' => 'ليس لديك صلاحية'], 403);
        }

        if ($requesterType === 'App\Models\Teacher' && $request->target_type === 'App\Models\Admin') {
            return response()->json(['error' => 'غير مصرح'], 403);
        }

        $targetRole = ($request->target_type === 'App\Models\Student') ? 'Student' : (($request->target_type === 'App\Models\Teacher') ? 'Teacher' : 'Admin');

        $targetIdentity = $request->target_id . '' . $targetRole;

        try {
            $svc = new RoomServiceClient(
                env('LIVEKIT_URL'),
                env('LIVEKIT_API_KEY'),
                env('LIVEKIT_API_SECRET')
            );

            $svc->mutePublishedTrack(
                $request->room_name,
                $targetIdentity,
                $request->track_sid,
                true
            );

            return response()->json(['message' => 'success']);

        } catch (\Exception $e) {
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }
}

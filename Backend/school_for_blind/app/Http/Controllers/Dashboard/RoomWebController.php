<?php

namespace App\Http\Controllers\Dashboard;
use App\Http\Controllers\Controller;
use App\Models\Room;
use App\Models\Classes;
use App\Services\RoomService;
use Illuminate\Http\Request;

class RoomWebController extends Controller
{
    protected $roomService;

    public function __construct(RoomService $roomService)
    {
        $this->roomService = $roomService;
    }

    public function classRooms($class_id)
    {
        $rooms = Room::where('class_id', $class_id)->latest()->get();
        return view('pages.rooms.index', compact('rooms'));
    }
    public function create()
    {
        $classes = Classes::all();
        return view('pages.rooms.create', compact('classes'));
    }
    public function store(Request $request)
    {
        $request->validate([
            'room_name' => 'required|string|unique:rooms,room_name|max:255',
            'class_id' => 'required|exists:classes,id',
        ]);

        $admin = auth()->user();

        Room::create([
            'creator_id' => $admin->id,
            'creator_type' => get_class($admin),
            'class_id' => $request->class_id,
            'room_name' => $request->room_name,
            'status' => 'active',
        ]);
        return redirect()->route('rooms.index')->with('success', 'تم إنشاء المكالمة بنجاح');
    }
    public function joinCall($room_name)
    {
        $user = auth()->guard('admin')->user();

        if (!$user) {
            return redirect()->route('admin.login')->with('error', 'يجب تسجيل الدخول كأدمن أولاً');
        }

        $identity = 'Admin--' . $user->id;
        $room = Room::where('room_name', $room_name)->first();
        $canPublish = true;
        
        $mutedParticipants = $room ? ($room->muted_participants ?? []) : [];

        if (in_array($identity, $mutedParticipants)) {
            $canPublish = false;
        }

        $roomService = new RoomService();
        $token = $roomService->generateToken($user, $room_name, 'Admin', $canPublish, true);

        return view('pages.rooms.room', compact('token', 'room_name', 'mutedParticipants'));
    }

    public function kickParticipant(Request $request)
    {
        $targetIdentity = $request->target_identity;
        \Log::info('targetIdentity ' . $targetIdentity);
        $roomName = $request->room_name;

        try {
            $this->roomService->kickParticipant($roomName, $targetIdentity);
            $room = Room::where('room_name', $roomName)->first();
            if ($room) {
                $kicked = $room->kicked_participants ?? [];
                if (!in_array($targetIdentity, $kicked)) {
                    $kicked[] = $targetIdentity;
                    $room->kicked_participants = $kicked;
                    $room->save();
                }
            }

            return response()->json(['success' => true, 'message' => 'تم الطرد بنجاح']);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => 'حدث خطأ أثناء الطرد'], 500);
        }
    }

    public function muteParticipant(Request $request)
    {
        try {
            $this->roomService->muteParticipant($request->room_name, $request->target_identity, $request->track_sid);

            $room = Room::where('room_name', $request->room_name)->first();
            if ($room) {
                $muted = $room->muted_participants ?? [];
                if (!in_array($request->target_identity, $muted)) {
                    $muted[] = $request->target_identity;
                    $room->muted_participants = $muted;
                    $room->save();
                }
            }

            return response()->json(['success' => true, 'message' => 'تم الكتم بنجاح']);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
        }
    }

    public function unmuteParticipant(Request $request)
    {
        try {
            $this->roomService->unmuteParticipant($request->room_name, $request->target_identity);

            $room = Room::where('room_name', $request->room_name)->first();
            if ($room) {
                $muted = $room->muted_participants ?? [];
                if (($key = array_search($request->target_identity, $muted)) !== false) {
                    unset($muted[$key]);
                    $room->muted_participants = array_values($muted);
                    $room->save();
                }
            }

            return response()->json(['success' => true, 'message' => 'تم فك الكتم']);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
        }
    }

    public function endCall(Request $request)
    {
        $roomName = $request->room_name;

        try {
            $this->roomService->endCall($roomName);

            $room = Room::where('room_name', $roomName)->first();
            if ($room) {
                $room->status = 'ended';
                $room->ended_at = now();
                $room->save();
            }

            return response()->json(['success' => true, 'message' => 'تم إنهاء المكالمة']);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => 'حدث خطأ أثناء الإنهاء'], 500);
        }
    }
    public function activeCalls()
    {
        $activeCalls = Room::where('status', 'active')
            ->with(['creator', 'schoolclass'])
            ->get();

        return view('pages.rooms.active_calls', compact('activeCalls'));
    }
}
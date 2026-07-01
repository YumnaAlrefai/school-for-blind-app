<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Room;
use App\Models\Attendance;
use Agence104\LiveKit\WebhookReceiver;
use Carbon\Carbon;

class LiveKitWebhookController extends Controller
{
    public function handle(Request $request)
    {
        \Log::info('hello world');
        $apiKey = env('LIVEKIT_API_KEY');
        $apiSecret = env('LIVEKIT_API_SECRET');
        $receiver = new WebhookReceiver($apiKey, $apiSecret);

        \Log::info('receiver ' );

        try {
            $event = $receiver->receive(
                $request->getContent(),
                $request->header('Authorization')
            );

            $eventName = $event->getEvent();
            $roomName = $event->getRoom()->getName();

            $room = Room::where('room_name', $roomName)->first();
            \Log::info('room is ' . $room);
            \Log::info('event is ' .$eventName);
            if (!$room) {
                return response()->json(['status' => 'Room not found'], 200);
            }

            if ($eventName === 'room_finished') {
                $room->update([
                    'status' => 'ended',
                    'ended_at' => now()
                ]);
                return response()->json(['status' => 'success'], 200);
            }

            if (in_array($eventName, ['participant_joined', 'participant_left'])) {
                $identity = $event->getParticipant()->getIdentity();
                $identityParts = explode('--', $identity);

                if (count($identityParts) === 2) {
                    $role = $identityParts[0];
                    $participantId = $identityParts[1];

                    $participantType = match ($role) {
                        'Student' => 'App\Models\Student',
                        'Teacher' => 'App\Models\Teacher',
                        'Admin' => 'App\Models\Admin',
                        default => null
                    };

                    if ($participantType) {
                        if ($eventName === 'participant_joined') {
                            Attendance::create([
                                'room_id' => $room->id,
                                'participant_type' => $participantType,
                                'participant_id' => $participantId,
                                'joined_at' => now(),
                            ]);
                        } elseif ($eventName === 'participant_left') {
                            $attendance = Attendance::where('room_id', $room->id)
                                ->where('participant_type', $participantType)
                                ->where('participant_id', $participantId)
                                ->whereNull('left_at')
                                ->latest()
                                ->first();

                            if ($attendance) {
                                $joinedAt = Carbon::parse($attendance->joined_at);
                                $leftAt = now();
                                $durationSeconds = $joinedAt->diffInSeconds($leftAt);

                                $attendance->update([
                                    'left_at' => $leftAt,
                                    'duration_seconds' => $durationSeconds
                                ]);
                            }
                        }
                    }
                }
            }

            return response()->json(['status' => 'success'], 200);

        } catch (\Exception $e) {
            return response()->json(['error' => 'Unauthorized'], 401);
        }
    }
}
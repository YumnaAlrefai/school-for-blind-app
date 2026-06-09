<?php

namespace App\Http\Requests\Room;

use App\Http\Requests\BaseApiRequest;
use App\Models\Room;

class EndCallRequest extends BaseApiRequest
{
    public $roomModel;

    public function authorize()
    {
        $room = Room::where('room_name', $this->room_name)->where('status', 'active')->first();
        if (!$room) {
            $this->authErrorMessage = 'المكالمة منتهية بالفعل أو غير موجودة';
            return false;
        }

        $user = $this->user();
        $userType = get_class($user);

        if ($userType !== 'App\Models\Admin' && ($room->creator_id !== $user->id || $room->creator_type !== $userType)) {
            $this->authErrorMessage = 'غير مصرح لك بإنهاء هذا الدرس، لست منشئ الغرفة';
            return false;
        }

        $this->roomModel = $room;
        return true;
    }

    public function rules()
    {
        return ['room_name' => 'required|string'];
    }
}
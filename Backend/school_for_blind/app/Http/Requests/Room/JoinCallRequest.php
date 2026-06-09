<?php

namespace App\Http\Requests\Room;

use App\Http\Requests\BaseApiRequest;
use App\Models\Room;

class JoinCallRequest extends BaseApiRequest
{
    public $roomModel;

    public function authorize()
    {
        $room = Room::where('room_name', $this->room_name)->where('status', 'active')->first();
        
        if (!$room) {
            $this->authErrorMessage = 'الغرفة غير موجودة أو انتهت المكالمة';
            return false;
        }

        $user = $this->user();
        $userType = get_class($user);
        $userRole = ($userType === 'App\Models\Student' ? 'Student' : ($userType === 'App\Models\Teacher' ? 'Teacher' : 'Admin'));

        if ($userRole === 'Student' && $room->class_id !== $user->class_id) {
            $this->authErrorMessage = 'غير مصرح لك بدخول هذا الدرس، ليس مخصصاً لشعبتك';
            return false;
        }

        $identityToCheck = $userRole . '--' . $user->id;
        if ($room->kicked_participants && in_array($identityToCheck, $room->kicked_participants)) {
            $this->authErrorMessage = 'لقد تم طردك من هذا الدرس بواسطة المدرس، لا يمكنك الدخول مجدداً';
            return false;
        }

        $this->roomModel = $room; 
        return true;
    }

    public function rules()
    {
        return ['room_name' => 'required|string'];
    }

    public function messages()
    {
        return ['room_name.required' => 'اسم الغرفة مطلوب للانضمام'];
    }
}
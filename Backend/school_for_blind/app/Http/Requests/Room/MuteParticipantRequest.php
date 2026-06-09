<?php

namespace App\Http\Requests\Room;

use App\Http\Requests\BaseApiRequest;
use App\Models\Room;

class MuteParticipantRequest extends BaseApiRequest
{
    public $roomModel;

    public function authorize()
    {
        $room = Room::where('room_name', $this->room_name)->where('status', 'active')->first();
        if (!$room) {
            $this->authErrorMessage = 'المكالمة غير موجودة أو منتهية';
            return false;
        }
        $user = $this->user();
        $userType = get_class($user);

        if ($userType !== 'App\Models\Admin' && ($room->creator_id !== $user->id || $room->creator_type !== $userType)) {
            $this->authErrorMessage = 'غير مصرح لك! فقط مشرف النظام أو الأستاذ منشئ الدرس يمكنه الكتم';
            return false;
        }
        if ($userType === 'App\Models\Teacher' && $this->target_type === 'App\Models\Admin') {
            $this->authErrorMessage = 'غير مصرح لك بكتم صوت مشرفي النظام (الإدارة)';
            return false;
        }

        $this->roomModel = $room;
        return true;
    }

    public function rules()
    {
        return [
            'room_name' => 'required|string',
            'target_id' => 'required|integer',
            'target_type' => 'required|string|in:App\Models\Student,App\Models\Teacher,App\Models\Admin',
            'track_sid' => 'required|string',
        ];
    }

    public function messages()
    {
        return [
            'room_name.required' => 'اسم الغرفة مطلوب',
            'target_id.required' => 'يجب تحديد معرف الشخص المراد كتمه',
            'target_type.required' => 'يجب تحديد نوع حساب الشخص المراد كتمه',
            'target_type.in' => 'نوع الحساب غير صالح',
            'track_sid.required' => 'معرف المسار الصوتي (Track SID) مطلوب لإتمام عملية الكتم',
        ];
    }
}
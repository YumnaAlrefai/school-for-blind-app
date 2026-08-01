<?php

namespace App\Http\Requests\Room;

use App\Http\Requests\BaseApiRequest;
use App\Models\Room;

class UnmuteParticipantRequest extends BaseApiRequest
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
            $this->authErrorMessage = 'غير مصرح لك! فقط مشرف النظام أو الأستاذ منشئ الدرس يمكنه فك الكتم';
            return false;
        }

        if ($userType === 'App\Models\Teacher' && $this->target_type === 'App\Models\Admin') {
            $this->authErrorMessage = 'غير مصرح لك بتعديل حالة مشرفي النظام (الإدارة)';
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
        ];
    }

    public function messages()
    {
        return [
            'room_name.required' => 'اسم الغرفة مطلوب',
            'target_id.required' => 'يجب تحديد معرف الشخص المراد فك الكتم عنه',
            'target_type.required' => 'يجب تحديد نوع حساب الشخص المراد فك الكتم عنه',
            'target_type.in' => 'نوع الحساب غير صالح',
        ];
    }
}
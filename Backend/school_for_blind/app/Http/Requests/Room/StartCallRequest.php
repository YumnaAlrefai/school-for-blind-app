<?php

namespace App\Http\Requests\Room;

use App\Http\Requests\BaseApiRequest;
use App\Models\Room;

class StartCallRequest extends BaseApiRequest
{
    public function authorize()
    {
        if (get_class($this->user()) === 'App\Models\Student') {
            $this->authErrorMessage = 'غير مصرح للطلاب إنشاء مكالمة';
            return false;
        }
        return true;
    }

    public function rules()
    {
        $user = $this->user();
        $existingRoom = Room::where('creator_id', $user->id)
            ->where('creator_type', get_class($user))
            ->where('status', 'active')
            ->first();

        $ignoreId = $existingRoom ? ',' . $existingRoom->id : '';

        return [
            'room_name' => 'required|string|unique:rooms,room_name' . $ignoreId,
            'class_id' => 'required|integer|exists:classes,id',
        ];
    }

    public function messages()
    {
        return [
            'room_name.required' => 'اسم الغرفة مطلوب',
            'room_name.unique' => 'اسم الغرفة موجود مسبقاً، يرجى اختيار اسم آخر',
            'class_id.required' => 'يجب تحديد الشعبة لإنشاء الدرس',
            'class_id.exists' => 'الشعبة المحددة غير موجودة في النظام',
        ];
    }

    public function withValidator($validator)
    {
        $validator->after(function ($validator) {
            $user = $this->user();

            if (get_class($user) === 'App\Models\Teacher') {
                $isMyClass = $user->classes()
                    ->where('classes.id', $this->class_id)
                    ->exists();

                if (!$isMyClass) {
                    $validator->errors()->add('class_id', 'غير مصرح لك بإنشاء مكالمة لشعبة لا تدرسها!');
                    return;
                }
            }

            $existingRoom = Room::where('creator_id', $user->id)
                ->where('creator_type', get_class($user))
                ->where('status', 'active')
                ->first();

            $activeCallExists = Room::where('class_id', $this->class_id)
                ->where('status', 'active')
                ->when($existingRoom, function ($query) use ($existingRoom) {
                    return $query->where('id', '!=', $existingRoom->id);
                })
                ->exists();

            if ($activeCallExists) {
                $validator->errors()->add('class_id', 'لا يمكن إنشاء المكالمة، هناك درس قائم حالياً لهذه الشعبة!');
            }
        });
    }
}
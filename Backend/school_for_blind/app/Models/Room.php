<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Spatie\Activitylog\LogOptions;
use Spatie\Activitylog\Traits\LogsActivity;
use Spatie\Activitylog\Models\Activity;

class Room extends Model
{
    /** @use HasFactory<\Database\Factories\RoomFactory> */
    use HasFactory;
    use LogsActivity;


    public function creator()
    {
        return $this->morphTo();
    }

    public function participants()
    {
        return $this->hasMany(Attendance::class);
    }

    public function schoolClass()
    {
        return $this->belongsTo(Classes::class, 'class_id');
    }

    protected $guarded = [];
    protected $casts = [
        'kicked_participants' => 'array',
    ];

    public function getActivitylogOptions(): LogOptions
    {
        return LogOptions::defaults()
            ->logOnly([
                'creator_type',
                'creator_id',
                'class_id',
                'room_name',
                'status',
                'started_at',
                'ended_at',
            ])
            ->logOnlyDirty()
            ->dontSubmitEmptyLogs();
    }

    public function tapActivity(Activity $activity, string $eventName)
    {
        $customInfo = [
            'room_name' => $this->room_name,
            'status' => $this->status,
            'creator_name' => $this->creator->full_name ?? $this->creator->role ?? 'غير محدد',
            'class_name' => $this->schoolClass->name ?? 'غير محدد',
            'class_level' => $this->class->level ?? 'غير محدد',

        ];

        $activity->properties = $activity->properties->put('custom_info', $customInfo);
    }
}

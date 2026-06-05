<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Room extends Model
{
    /** @use HasFactory<\Database\Factories\RoomFactory> */
    use HasFactory;

    public function creator()
    {
        return $this->morphTo();
    }

    public function participants()
    {
        return $this->hasMany(Attendance::class);
    }

    protected $guarded = [];
}

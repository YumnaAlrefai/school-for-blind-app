<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Attendance extends Model
{

    public function participant()
    {
        return $this->morphTo();
    }
    public function room()
    {
        return $this->belongsTo(Room::class);
    }
    protected $guarded = [];

}

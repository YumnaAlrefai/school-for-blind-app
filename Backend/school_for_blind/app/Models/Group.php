<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Group extends Model
{
    protected $fillable = [
        'name',
        'owner_id',
        'type',
        'who_can_send',
        'description',
    ];

  /* public function owner()
    {
        return $this->belongsTo(User::class, 'owner_id');
    }*/
}

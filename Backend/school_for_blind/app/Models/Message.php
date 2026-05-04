<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Message extends Model
{
    protected $fillable = [
        'conversation_id',
        'sender_id',
        'message_text',
        'file_path',
        'type',
        'is_read',
    ];

    public function conversation()
    {
        return $this->belongsTo(Conversation::class);
    }
}

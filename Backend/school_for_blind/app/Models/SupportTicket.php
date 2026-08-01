<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class SupportTicket extends Model
{
    protected$fillable = [
'sender_type',
'sender_id',
'text_content',
'audio_path',
'image_path',
'status',
];
}

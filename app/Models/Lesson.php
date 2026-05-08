<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Lesson extends Model
{
    protected$fillable = [
'title',
'audio_path',
'content_text',
'order'
];
}

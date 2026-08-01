<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Announcement extends Model
{
    protected $fillable = ['content', 'type', 'title','level', 'target_audience'];
protected function casts(): array
{
    return [
        'content' => 'array',
    ];
}

    }

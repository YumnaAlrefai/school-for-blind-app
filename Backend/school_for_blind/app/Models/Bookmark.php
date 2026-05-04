<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Bookmark extends Model
{
    protected $fillable = [
'name',
'location',
'bookmarkable_id',
    ];
}

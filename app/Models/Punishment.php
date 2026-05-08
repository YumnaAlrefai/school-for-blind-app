<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Punishment extends Model
{
    protected $fillable = [
        'name',
        'description',
        'duration',
    ];
}

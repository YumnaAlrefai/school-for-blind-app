<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Record extends Model
{

    use SoftDeletes;

    public function recordable()
    {
        return $this->morphTo();
    }
    protected $guarded = [];
}

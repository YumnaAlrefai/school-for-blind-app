<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Report extends Model
{
    protected $guarded = [];

    public function reporter()
    {
        return $this->morphTo();
    }

    public function reported()
    {
        return $this->morphTo();
    }

    public function reportable()
    {
        return $this->morphTo();
    }
}

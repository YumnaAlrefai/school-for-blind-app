<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\MorphTo;

class SchoolTransaction extends Model
{
    protected $fillable = [
        'amount',
        'transaction_type',
        'description',
        'reference_id',
        'reference_type',
    ];

    public function reference(): MorphTo
    {
        return $this->morphTo();
    }

    }

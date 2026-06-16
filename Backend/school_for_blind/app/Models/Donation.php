<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Donation extends Model
{
    protected $fillable = [
        'amount',
        'donor_name',
        'donor_email',
        'message',
        'currency',
        'stripe_session_id',
        'status',
        'user_id',
        ];
public function donatable()
{
    return $this->morphTo();
}






        }


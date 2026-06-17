<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Donation extends Model
{
    protected $fillable = [
        'amount',
        'donor_name',
        'currency',
        'stripe_session_id',
        'status',
        'donatable_id',
        'donatable_type',];
public function donatable()
{
    return $this->morphTo();
}






        }


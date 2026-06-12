<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class PointRedemptionRequest extends Model
{
    protected $fillable = [
        'points_to_redeem',
        'amount_paid',
        'status',
        'student_id',
    ];

  public function student(): BelongsTo
    {
        return $this->belongsTo(Student::class, 'student_id');
    }
}

<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Laravel\Sanctum\HasApiTokens;
use App\Traits\UploadFileTrait;

class Student extends Authenticatable
{
    use HasApiTokens, HasFactory, UploadFileTrait;

    protected $fillable = [
        'fullname',
        'phone',
        'parent_phone',
        'points',
        'fcm_token',
        'level',
        'phone_verified_at',
        'status',
        'DocumentaryEvidence',
        'otp',
        'otp_expires_at',
        ];

    protected $hidden = [
        'otp',
    ];

public function getDocumentaryevidenceAttribute($value)
{
    if ($value) {
    return asset('storage/' . $value);
    }
    return null;
}
 }

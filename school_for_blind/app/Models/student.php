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
        ];

    protected $hidden = [
        'otp',
    ];

public function getDocumentaryEvidenceAttribute($value)
{
    if ($value) {
    return asset('storage/' . $value);
    }
    return null;
    }




}

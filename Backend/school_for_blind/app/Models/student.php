<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Laravel\Sanctum\HasApiTokens;
use App\Traits\UploadFileTrait;
use Illuminate\Database\Eloquent\Casts\Attribute;

class Student extends Authenticatable
{
    use HasApiTokens, HasFactory, UploadFileTrait;

    protected $fillable = [
        'fullname',
        'fathersname',
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
            return request()->getSchemeAndHttpHost() . '/storage/' . $value;
        }
        return null;
    }

    protected function documentaryEvidence(): Attribute
    {
        return Attribute::make(
            get: fn($value) => $value ? route('students.documents.show', ['filename' => basename($value)]) : null,
        );
    }

    public function parent()
    {
        return $this->belongsTo(Caregiver::class, 'parent_id');
    }

    public function class()
    {
        return $this->belongsTo(Classes::class, 'class_id');
    }

}

<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Laravel\Sanctum\HasApiTokens;
use App\Traits\UploadFileTrait;
use Illuminate\Database\Eloquent\Casts\Attribute;
use Illuminate\Database\Eloquent\Relations\HasMany;

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
        'total_earned_points',
        'stripe_account_id',

    ];

    protected $hidden = [
        'otp',
        'stripe_account_id',
    ];

   public function getDocumentaryEvidenceAttribute($value)
{
    if (!$value) return null;

    $cleanFileName = basename($value);

    return 'doc/' . $cleanFileName;
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


    public function redemptionRequests(): HasMany
    {
        return $this->hasMany(PointRedemptionRequest::class, 'student_id');
    }
    public function getSubtractedPointsAttribute(): int
    {
        return (int) $this->redemptionRequests()
            ->where('status', 'approved')
            ->sum('points_to_redeem');
    }

    public function getRemainingPointsAttribute(): int
    {
        return $this->points;
    }
    public function class()
    {
        return $this->belongsTo(Classes::class, 'class_id');
    }

    public function quizSubmissions()
    {
        return $this->hasMany(QuizSubmission::class);
    }

    public function answers()
    {
        return $this->hasMany(StudentAnswer::class);
    }
public function donations()
{
    return $this->morphMany(Donation::class, 'donatable');
}
public function favoriteLessons()
{
    return $this->morphToMany(Lesson::class, 'favorable', Favorite::class);
}
public function favoriteQuizzes()
{
    return $this->morphToMany(Quiz::class, 'favorable', Favorite::class);   
}
public function deviceTokens()
{
    return $this->morphMany(DeviceToken::class, 'tokenable');
}
protected static function booted()
    {
        static::deleting(function ($student) {
            $student->deviceTokens()->delete();
            $student->notifications()->delete();
        });
    }
    public function notifications()
{
    return $this->morphMany(Notification::class, 'notifiable');
}
}

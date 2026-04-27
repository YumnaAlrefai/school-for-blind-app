<?php
namespace App\Services;

use Illuminate\Support\Str;

class VerificationService
{
    public function generateToken()
    {
        return Str::random(60);
    }

    public function expiry()
    {
        return now()->addMinutes(30);
    }

    public function generateLink($token)
    {
        return url("/api/verify-account?token=$token");
    }
}
?>

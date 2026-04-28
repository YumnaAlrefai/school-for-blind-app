<?php

namespace App\Services;

use Illuminate\Support\Facades\Hash;

class OtpService
{
   public function generate()
    {
        return rand(100000, 999999);
    }

    public function hash($otp)
    {
        return Hash::make($otp);
    }

    public function verify($input, $stored)
    {
        return Hash::check($input, $stored);
    }

    public function expiry()
    {
        return now()->addMinutes(2);
    }
}

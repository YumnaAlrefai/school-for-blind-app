<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class SchoolWallet extends Model
{
    protected $fillable = [
        'balance',
    ];
    public static function getWallet(): self
    {
        return self::firstOrCreate([], ['balance' => 0.00]);
    }
}

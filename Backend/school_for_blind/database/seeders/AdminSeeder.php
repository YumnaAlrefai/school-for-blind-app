<?php

namespace Database\Seeders;

use App\Models\Admin;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class AdminSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        if (!Admin::where('email', 'admin@example.com')->exists()) {
            Admin::create([
                'name' => 'المدير العام',
                'email' => 'admin@example.com', // الإيميل الذي ستسجل الدخول به
                'password' => Hash::make('password123'), // الباسورد (مهم جداً تشفيره)
            ]);
        }
    }
}

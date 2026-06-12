<?php

namespace Database\Seeders;

use App\Models\Admin;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class AdminSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $admins = [
            ['role' => 'Super Admin', 'email' => 'super_admin@app.com'],
            ['role' => 'Academic Manager', 'email' => 'academic@app.com'],
            ['role' => 'Moderator', 'email' => 'moderator@app.com'],
            ['role' => 'Support Agent', 'email' => 'support@app.com'],
            ['role' => 'Data Entry', 'email' => 'data_entry@app.com'],
            ['role' => 'Financial Manager', 'email' => 'financial@app.com'],
        ];

        $hashedPassword = Hash::make('password123');
        $this->command->info('Admins: same password for all admins (password123)');
        foreach ($admins as $adminData) {
            $admin = Admin::updateOrCreate(
                ['email' => $adminData['email']],
                [
                    'role' => $adminData['role'],
                    'password' => $hashedPassword,
                    'email_verified_at' => now(),
                ]
            );
            $admin->tokens()->delete();
            $token = $admin->createToken('Test_Token')->plainTextToken;
            $this->command->warn("Email: {$admin->email}");
            $this->command->line("Token: {$token}");
            $this->command->line("-------------------------------------------------");
        }
    }
}
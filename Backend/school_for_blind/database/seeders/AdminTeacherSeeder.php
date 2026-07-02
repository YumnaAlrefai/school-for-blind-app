<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Teacher;

class AdminTeacherSeeder extends Seeder
{
    public function run(): void
    {
        Teacher::firstOrCreate(
            ['phone' => '0000000000'],
            [
                'full_name' => 'الإدارة العامة',
                'password' => bcrypt('admin_secret_123'), 
                'subjects' => 'كل المواد', 
                'level' => 'twelfth', 
                'status' => 'approved', 
                'cv_path' => 'system/admin_cv.pdf',
            ]
        );
    }
}
<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Subject;

class SubjectSeeder extends Seeder
{
    public function run(): void
    {
        $subjects = [
            [
                'name' => 'الرياضيات',
                'grade_level' => 'ninth',
            ],
            [
                'name' => 'الفيزياء',
                'grade_level' => 'ninth',
            ],
            [
                'name' => 'اللغة العربية',
                'grade_level' => 'ninth',
            ],
            [
                'name' => 'اللغة الإنجليزية',
                'grade_level' => 'twelfth',
            ],
            [
                'name' => 'البرمجة',
                'grade_level' => 'twelfth',
            ]
        ];

        foreach ($subjects as $subject) {
            Subject::updateOrCreate(
                ['name' => $subject['name']], 
                $subject 
            );
        }
    }
}
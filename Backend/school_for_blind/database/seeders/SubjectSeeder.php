<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Subject;

class SubjectSeeder extends Seeder
{
    public function run(): void
    {
        $subjects = [
          // === مواد البكالوريا (twelfth) ===
            ['name' => 'الفلسفة', 'grade_level' => 'twelfth'],
            ['name' => 'التاريخ', 'grade_level' => 'twelfth'],
            ['name' => 'الجغرافيا', 'grade_level' => 'twelfth'],
            ['name' => 'اللغة العربية', 'grade_level' => 'twelfth'],
            ['name' => 'اللغة الإنكليزية', 'grade_level' => 'twelfth'], // مطابقة لـ فلوتر بالنون
            ['name' => 'اللغة الفرنسية', 'grade_level' => 'twelfth'],
            ['name' => 'التربية الدينية', 'grade_level' => 'twelfth'],
            // === مواد الصف التاسع (ninth) ===
            ['name' => 'الرياضيات (جبر)', 'grade_level' => 'ninth'], // مطابقة لـ فلوتر مع الأقواس
            ['name' => 'الفيزياء والكيمياء', 'grade_level' => 'ninth'],
            ['name' => 'علم الأحياء والأرض', 'grade_level' => 'ninth'],
            ['name' => 'التاريخ', 'grade_level' => 'ninth'],
            ['name' => 'الجغرافيا', 'grade_level' => 'ninth'],
            ['name' => 'اللغة العربية', 'grade_level' => 'ninth'],
            ['name' => 'اللغة الإنكليزية', 'grade_level' => 'ninth'],
            ['name' => 'اللغة الفرنسية', 'grade_level' => 'ninth'],
            ['name' => 'التربية الدينية', 'grade_level' => 'ninth'],
        ];
foreach ($subjects as $subject) {
            Subject::updateOrCreate(
                [
                    'name' => $subject['name'],
                    'grade_level' => $subject['grade_level']
                ], 
                $subject 
            );
        }
    }
    }


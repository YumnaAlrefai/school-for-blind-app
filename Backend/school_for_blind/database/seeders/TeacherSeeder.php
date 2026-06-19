<?php

namespace Database\Seeders;

use App\Models\Subject;
use App\Models\Teacher;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Faker\Factory as Faker;

class TeacherSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $faker = Faker::create('ar_SA');

        $ninthClasses = DB::table('classes')->where('level', 'ninth')->pluck('id')->toArray();
        $twelfthClasses = DB::table('classes')->where('level', 'twelfth')->pluck('id')->toArray();

        $famousTeachers = [
            // === أساتذة البكالوريا (twelfth) ===
            ['name' => 'الأستاذ أحمد حيدر', 'subject' => 'الفلسفة', 'level' => 'twelfth', 'phone' => '0911111111'],
            ['name' => 'الأستاذ نضال يوسف', 'subject' => 'التاريخ', 'level' => 'twelfth', 'phone' => '0922222222'],
            ['name' => 'الأستاذ موسى الرز', 'subject' => 'الجغرافيا', 'level' => 'twelfth', 'phone' => '0933333333'],
            ['name' => 'الأستاذ مصطفى الشيخ أحمد', 'subject' => 'اللغة العربية', 'level' => 'twelfth', 'phone' => '0944444444'],
            ['name' => 'الأستاذ أنس أحمد', 'subject' => 'اللغة الإنكليزية', 'level' => 'twelfth', 'phone' => '0955555555'],
            ['name' => 'الأستاذ يامن قيس', 'subject' => 'اللغة الفرنسية', 'level' => 'twelfth', 'phone' => '0966666666'],
            ['name' => 'الشيخ عبد الله علوش', 'subject' => 'التربية الدينية', 'level' => 'twelfth', 'phone' => '0977777777'],

            // === أساتذة التاسع (ninth) ===
            ['name' => 'الأستاذ فايز جوهرة', 'subject' => 'الرياضيات (جبر)', 'level' => 'ninth', 'phone' => '0988888888'],
            ['name' => 'الأستاذ محمد نور طحّان', 'subject' => 'الفيزياء والكيمياء', 'level' => 'ninth', 'phone' => '0999999999'],
            ['name' => 'الأستاذة رنا خير بك', 'subject' => 'علم الأحياء والأرض', 'level' => 'ninth', 'phone' => '0912345678'],
            ['name' => 'الأستاذ علاء العبيد', 'subject' => 'التاريخ', 'level' => 'ninth', 'phone' => '0923456789'],
            ['name' => 'الأستاذ حيان حيدر', 'subject' => 'الجغرافيا', 'level' => 'ninth', 'phone' => '0934567890'],
            ['name' => 'الأستاذ طارق فرزات', 'subject' => 'اللغة العربية', 'level' => 'ninth', 'phone' => '0945678901'],
            ['name' => 'الأستاذ عمار ملوحي', 'subject' => 'اللغة الإنكليزية', 'level' => 'ninth', 'phone' => '0956789012'],
            ['name' => 'الأستاذ باسل زعرور', 'subject' => 'اللغة الفرنسية', 'level' => 'ninth', 'phone' => '0967890123'],
            ['name' => 'الآنسة هدى الموصلي', 'subject' => 'التربية الدينية', 'level' => 'ninth', 'phone' => '0978901234'],
        ];
        $consoleData = [];
        foreach ($famousTeachers as $tData) {
      $subject = Subject::where('name', $tData['subject'])
                              ->where('grade_level', $tData['level'])
                              ->first();

            if (!$subject) {
                continue; 
            }

            $randomDate = $faker->dateTimeBetween('-11 months', 'now');
            $teacher = Teacher::updateOrCreate(
                ['phone' => $tData['phone']], 
                [
                    'full_name' => $tData['name'],
                    'password' => Hash::make('12345678'),
                    'subjects' => $tData['subject'], 
                    'level' => $tData['level'],
                    'status' => 'approved',
                    'cv_path' => 'cv_dummy.pdf',
                    'created_at' => $randomDate,
                    'updated_at' => $randomDate,
                ]
            );

            $availableClasses = ($tData['level'] === 'ninth') ? $ninthClasses : $twelfthClasses;
            if (!empty($availableClasses)) {
                $classesCount = min(rand(1, 2), count($availableClasses));
                $assignedClasses = (array) array_rand(array_flip($availableClasses), $classesCount);
                $teacher->classes()->sync($assignedClasses);
            }

            $teacher->subjects()->sync([$subject->id]);

            $token = $teacher->createToken('teacher-test-token')->plainTextToken;

            $consoleData[] = [
                $teacher->full_name,
                $teacher->phone,
                '12345678',
                $teacher->level,
                $subject->name,
                $token
            ];
        }

        $this->command->info('=== Famous Teachers Seeder Loaded Successfully ===');
        $this->command->table(
            ['Name', 'Phone', 'Password', 'Level', 'Subject Assigned', 'Token'],
            $consoleData
        );
    }
}
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

        $classesMap = DB::table('classes')->pluck('name', 'id')->toArray();
        
        $ninthClasses = DB::table('classes')->where('level', 'ninth')->pluck('id')->toArray();
        $twelfthClasses = DB::table('classes')->where('level', 'twelfth')->pluck('id')->toArray();

        $availableSubjects = DB::table('subjects')->pluck('id')->toArray();

        $famousTeachers = [
            // === أساتذة البكالوريا (twelfth) ===
            ['name' => 'الأستاذ أحمد حيدر', 'subject' => 'الفلسفة', 'level' => 'twelfth', 'phone' => '0911111111'],
            ['name' => 'الأستاذنضال يوسف', 'subject' => 'التاريخ', 'level' => 'twelfth', 'phone' => '0922222222'],
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
            $level = $tData['level'];
            $availableClasses = ($level === 'ninth') ? $ninthClasses : $twelfthClasses;
            $randomDate = $faker->dateTimeBetween('-11 months', 'now');

            $dbSubject = Subject::where('name', $tData['subject'])
                                ->where('grade_level', $tData['level'])
                                ->first();

            $teacher = Teacher::updateOrCreate(
                ['phone' => $tData['phone']],
                [
                    'full_name' => $tData['name'],
                    'password' => Hash::make('12345678'),
                    'level' => $level,
                    'status' => 'approved',
                    'cv_path' => 'cv_dummy.pdf',
                    'created_at' => $randomDate,
                    'updated_at' => $randomDate,
                ]
            );

            $assignedClassesIds = [];
            if (!empty($availableClasses)) {
                $classesCountToAssign = min(rand(1, 2), count($availableClasses));
                $keys = (array) array_rand($availableClasses, $classesCountToAssign);
                foreach ($keys as $key) {
                    $assignedClassesIds[] = $dbSubject->id;
                }
                $teacher->classes()->sync($assignedClassesIds);
            }

            $assignedSubjectIds = [];
            if ($dbSubject) {
                $assignedSubjectIds[] = $dbSubject->id;
            } else {
                $fallbackSubject = Subject::where('grade_level', $level)->first();
                if ($fallbackSubject) {
                    $assignedSubjectIds[] = $fallbackSubject->id;
                } elseif (!empty($availableSubjects)) {
                    $assignedSubjectIds[] = $availableSubjects[array_rand($availableSubjects)];
                }
            }
            $teacher->subjects()->sync($assignedSubjectIds);

            $assignedClassesNames = array_map(function($id) use ($classesMap) {
                return $classesMap[$id] ?? "شعبة ($id)";
            }, $assignedClassesIds);

            $assignedSubjectsNames = $teacher->subjects()->pluck('name')->toArray();
            if (empty($assignedSubjectsNames)) {
                $assignedSubjectsNames = [$tData['subject']];
            }
$token = $teacher->createToken('teacher-test-token')->plainTextToken;
            $consoleData[] = [
                $teacher->full_name,
                $teacher->phone,
                $level,
                implode(', ', $assignedSubjectsNames), 
                implode(', ', $assignedClassesNames),
                $token,

            ];
        }

        $this->command->info('=== Famous Teachers & Their Assigned Subjects/Classes ===');
        $this->command->table(
            ['Teacher Name', 'Phone', 'Level', 'Assigned Subjects', 'Assigned Classes', 'Token'],
            $consoleData
        );

        $statuses = ['pending', 'approved', 'rejected'];

        for ($i = 0; $i < 80; $i++) {
            $randomDate = $faker->dateTimeBetween('-11 months', 'now');
            $randomLevel = ['ninth', 'twelfth'][rand(0, 1)];

            $teacher = Teacher::create([
                'full_name' => $faker->name,
                'phone' => '09' . $faker->unique()->randomNumber(8, true),
                'password' => Hash::make('password'),
                'level' => $randomLevel,
                'status' => $statuses[array_rand($statuses)],
                'cv_path' => 'random_cv.pdf',
                'created_at' => $randomDate,
                'updated_at' => $randomDate,
            ]);

            $levelSubjects = Subject::where('grade_level', $randomLevel)->pluck('id')->toArray();

            if (!empty($levelSubjects)) {
                $count = min(rand(1, 2), count($levelSubjects));
                $subjectKeys = (array) array_rand($levelSubjects, $count);
                $assignedSubjectIds = [];
                foreach ($subjectKeys as $key) {
                    $assignedSubjectIds[] = $levelSubjects[$key];
                }
                $teacher->subjects()->attach($assignedSubjectIds);
            }

            if ($teacher->status === 'approved') {
                $pool = $randomLevel === 'ninth' ? $ninthClasses : $twelfthClasses;
                if (!empty($pool)) {
                    $teacher->classes()->attach($pool[array_rand($pool)]);
                }
            }
        }
        
    }
}
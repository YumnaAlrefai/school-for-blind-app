<?php

namespace Database\Seeders;

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
        
        $availableSubjects = DB::table('subjects')->where('id', '<=', 6)->pluck('id')->toArray();
        if (empty($availableSubjects)) {
            $availableSubjects = [1, 2, 3, 4, 5, 6];
        }

        $consoleData = [];

        for ($i = 0; $i < 20; $i++) {
            $level = ($i < 10) ? 'ninth' : 'twelfth';
            $availableClasses = ($level === 'ninth') ? $ninthClasses : $twelfthClasses;

            $teacher = Teacher::create([
                'full_name' => 'الأستاذ ' . $faker->firstNameMale . ' (' . $level . ')',
                'phone' => '09' . $faker->unique()->randomNumber(8, true),
                'password' => Hash::make('12345678'),
                'subjects' => ['رياضيات', 'فيزياء', 'علوم', 'لغة عربية'][rand(0, 3)],
                'level' => $level,
                'status' => 'approved',
                'cv_path' => 'cv_dummy.pdf',
            ]);

            $classesCountToAssign = rand(1, 2);
            $keys = (array) array_rand($availableClasses, $classesCountToAssign);
            $assignedClassesIds = [];
            foreach ($keys as $key) {
                $assignedClassesIds[] = $availableClasses[$key];
            }
            $teacher->classes()->attach($assignedClassesIds);

            $subjectsCountToAssign = rand(1, 2);
            $subjectKeys = (array) array_rand($availableSubjects, $subjectsCountToAssign);
            $assignedSubjectIds = [];
            foreach ($subjectKeys as $key) {
                $assignedSubjectIds[] = $availableSubjects[$key];
            }
            $teacher->subjects()->attach($assignedSubjectIds);

            $token = $teacher->createToken('teacher-test-token')->plainTextToken;

            $consoleData[] = [
                $teacher->phone,
                '12345678',
                $level,
                implode(', ', $assignedClassesIds),
                implode(', ', $assignedSubjectIds),
                $token
            ];
        }

        $this->command->info('Teacher Seeder');
        $this->command->table(
            ['phone', 'password', 'Level', 'Class id', 'Subject id', 'token'],
            $consoleData
        );
        
        $statuses = ['pending', 'approved', 'rejected'];

        for ($i = 0; $i < 80; $i++) {
            $teacher = Teacher::create([
                'full_name' => $faker->name,
                'phone' => '09' . $faker->unique()->randomNumber(8, true),
                'password' => Hash::make('password'),
                'subjects' => 'مادة عشوائية',
                'level' => ['ninth', 'twelfth'][rand(0, 1)],
                'status' => $statuses[array_rand($statuses)],
                'cv_path' => 'random_cv.pdf',
            ]);

            $subjectsCountToAssign = rand(1, 2);
            $subjectKeys = (array) array_rand($availableSubjects, $subjectsCountToAssign);
            $assignedSubjectIds = [];
            foreach ($subjectKeys as $key) {
                $assignedSubjectIds[] = $availableSubjects[$key];
            }
            $teacher->subjects()->attach($assignedSubjectIds);

            if ($teacher->status === 'approved') {
                $pool = $teacher->level === 'ninth' ? $ninthClasses : $twelfthClasses;
                $teacher->classes()->attach($pool[array_rand($pool)]);
            }
        }
    }
}
<?php

namespace Database\Seeders;

use App\Models\Student;
use App\Models\SchoolClass; // تأكد من اسم موديل الشعبة عندك
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Faker\Factory as Faker;

class StudentSeeder extends Seeder
{
    public function run(): void
    {
        $faker = Faker::create('ar_SA');
        $classes = DB::table('classes')->get(); 

        $consoleData = []; 

        foreach ($classes as $class) {
            $student = Student::create([
                'fullname' => 'طالب ' . $class->name . ' - ' . $class->level,
                'fathersname' => $faker->firstNameMale,
                'phone' => '09' . $faker->unique()->randomNumber(8, true),
                'parent_phone' => '09' . $faker->randomNumber(8, true),
                'level' => $class->level, // ninth أو twelfth
                'class_id' => $class->id,
                'status' => 'approved',
                'points' => rand(10, 100),
                'DocumentaryEvidence' => 'proof_' . rand(1, 100) . '.jpg',
            ]);

            $token = $student->createToken('student-test-token')->plainTextToken;

            $consoleData[] = [
                // $student->fullname,
                $student->phone,
                $class->level,
                $class->name,
                $token
            ];
        }

        $this->command->table(
            ['name', 'phone', 'level', 'class', 'token'],
            $consoleData
        );

        
        $statuses = ['pending', 'approved', 'rejected'];
        
        for ($i = 0; $i < 280; $i++) {
            $randomStatus = $statuses[array_rand($statuses)];
            $randomClass = $classes->random();

            Student::create([
                'fullname' => $faker->name,
                'fathersname' => $faker->firstNameMale,
                'phone' => '09' . $faker->unique()->randomNumber(8, true),
                'parent_phone' => '09' . $faker->randomNumber(8, true),
                'level' => $randomStatus === 'approved' ? $randomClass->level : ['ninth', 'twelfth'][rand(0, 1)],
                'class_id' => $randomStatus === 'approved' ? $randomClass->id : null,
                'status' => $randomStatus,
                'DocumentaryEvidence' => 'proof_random.jpg',
            ]);
        }
    }
}
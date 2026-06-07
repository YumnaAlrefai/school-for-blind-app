<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;
use App\Models\Teacher; // تأكد من أن مسار المودل صحيح لديك

/*
|--------------------------------------------------------------------------
| قائمة بـ 10 حسابات جاهزة للاستخدام الفوري (الحالة: Approved)
|--------------------------------------------------------------------------
| كلمة المرور الموحدة لجميع الحسابات في هذا السيدر هي: password123
|
| الحسابات الجاهزة (جاهزة لتسجيل الدخول):
| 1. رقم الهاتف: 0900000001
| 2. رقم الهاتف: 0900000002
| 3. رقم الهاتف: 0900000003
| 4. رقم الهاتف: 0900000004
| 5. رقم الهاتف: 0900000005
| 6. رقم الهاتف: 0900000006
| 7. رقم الهاتف: 0900000007
| 8. رقم الهاتف: 0900000008
| 9. رقم الهاتف: 0900000009
| 10. رقم الهاتف: 0900000010
|
| سيتم طباعة الـ Bearer Tokens الخاصة بهذه الحسابات في الـ Terminal عند تشغيل السيدر.
*/

class TeacherSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $levels = ['ninth', 'twelfth'];
        $statuses = ['pending', 'approved', 'rejected'];
        $subjects = ['الرياضيات', 'الفيزياء', 'العلوم', 'اللغة العربية', 'اللغة الإنجليزية'];

        $password = Hash::make('password123');


        for ($i = 1; $i <= 10; $i++) {
            $phone = '09000000' . str_pad($i, 2, '0', STR_PAD_LEFT);

            $teacher = Teacher::create([
                'full_name' => "أستاذ جاهز $i",
                'phone' => $phone,
                'password' => $password,
                'subjects' => $subjects[array_rand($subjects)],
                'level' => $levels[array_rand($levels)],
                'status' => 'approved',
                'cv_path' => "cvs/ready_teacher_$i.pdf",
                'fcm_token' => Str::random(40),
            ]);

            if (method_exists($teacher, 'createToken')) {
                $token = $teacher->createToken('Test-Token')->plainTextToken;
                $this->command->warn("Phone: $phone | Token: $token");
            }
        }


        for ($i = 11; $i <= 30; $i++) {
            Teacher::create([
                'full_name' => "أستاذ تجريبي $i",
                'phone' => '09' . rand(10000000, 99999999),
                'password' => $password,
                'subjects' => $subjects[array_rand($subjects)],
                'level' => $levels[array_rand($levels)],
                'status' => $statuses[array_rand($statuses)],
                'cv_path' => "cvs/random_teacher_$i.pdf",
                'fcm_token' => null,
            ]);
        }

    }
}
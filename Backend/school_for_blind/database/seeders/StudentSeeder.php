<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Str;
use Carbon\Carbon;
use App\Models\Student; // تأكد من أن مسار المودل صحيح

/*
|--------------------------------------------------------------------------
| قائمة بـ 10 حسابات طلاب جاهزة للاستخدام الفوري (الحالة: Approved)
|--------------------------------------------------------------------------
| تم تأكيد أرقام الهواتف لهذه الحسابات (phone_verified_at).
|
| الحسابات الجاهزة:
| 1. رقم الهاتف: 0950000001
| 2. رقم الهاتف: 0950000002
| 3. رقم الهاتف: 0950000003
| 4. رقم الهاتف: 0950000004
| 5. رقم الهاتف: 0950000005
| 6. رقم الهاتف: 0950000006
| 7. رقم الهاتف: 0950000007
| 8. رقم الهاتف: 0950000008
| 9. رقم الهاتف: 0950000009
| 10. رقم الهاتف: 0950000010
|
| سيتم طباعة الـ Bearer Tokens الخاصة بهذه الحسابات في الـ Terminal.
*/

class StudentSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $levels = ['ninth', 'twelfth'];
        $statuses = ['pending', 'approved', 'rejected'];


        for ($i = 1; $i <= 10; $i++) {
            $phone = '09500000' . str_pad($i, 2, '0', STR_PAD_LEFT);
            
            $student = Student::create([
                'fullname'            => "طالب جاهز $i",
                'fathersname'         => "والد الطالب $i",
                'phone'               => $phone,
                'parent_phone'        => '09600000' . str_pad($i, 2, '0', STR_PAD_LEFT),
                'points'              => rand(50, 500),
                'fcm_token'           => Str::random(40),
                'level'               => $levels[array_rand($levels)],
                'phone_verified_at'   => Carbon::now(), 
                'status'              => 'approved',    
                'verification_token'  => null,
                'token_expires_at'    => null,
                'DocumentaryEvidence' => "evidence/ready_student_$i.pdf",
            ]);

            if (method_exists($student, 'createToken')) {
                $token = $student->createToken('Student-Test-Token')->plainTextToken;
                $this->command->warn("Student Phone: $phone | Token: $token");
            }
        }


        for ($i = 11; $i <= 30; $i++) {
            $status = $statuses[array_rand($statuses)];
            $isVerified = rand(0, 1) == 1; 
            
            Student::create([
                'fullname'            => "طالب تجريبي $i",
                'fathersname'         => "والد التجريبي $i",
                'phone'               => '09' . rand(10000000, 99999999),
                'parent_phone'        => '09' . rand(10000000, 99999999),
                'points'              => rand(0, 100),
                'fcm_token'           => null,
                'level'               => $levels[array_rand($levels)],
                'phone_verified_at'   => $isVerified ? Carbon::now() : null,
                'status'              => $status,
                'verification_token'  => !$isVerified ? Str::random(6) : null,
                'token_expires_at'    => !$isVerified ? Carbon::now()->addMinutes(10) : null,
                'DocumentaryEvidence' => "evidence/random_student_$i.pdf",
            ]);
        }

    }
}
<?php

namespace Database\Seeders;

use App\Models\Classes;
use App\Models\Subject;
use App\Models\Teacher;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class SpecialTeacherSeeder extends Seeder
{
    public function run(): void
    {
        $allSubjectIds = Subject::pluck('id')->toArray();
        $allClassIds = Classes::pluck('id')->toArray();

        $ninthClassIds = Classes::where('level', 'ninth')->pluck('id')->toArray();
        $ninthSubjectIds = Subject::where('grade_level', 'ninth')->pluck('id')->toArray();

        $twelfthClassIds = Classes::where('level', 'twelfth')->pluck('id')->toArray();
        $twelfthSubjectIds = Subject::where('grade_level', 'twelfth')->pluck('id')->toArray();

        $commonPassword = Hash::make('00000000');

        $adminTeacher = Teacher::firstOrCreate(
            ['phone' => '0000000000'],
            [
                'full_name' => 'الإدارة العامة',
                'password' => $commonPassword,
                'subjects' => 'كل المواد',
                'level' => 'twelfth',
                'status' => 'approved',
                'cv_path' => 'system/admin_cv.pdf',
            ]
        );
        $adminTeacher->subjects()->sync($allSubjectIds);
        $adminTeacher->classes()->sync($allClassIds);

        $ghaliaTeacher = Teacher::firstOrCreate(
            ['phone' => '0943576695'],
            [
                'full_name' => 'غالية الياسين',
                'password' => $commonPassword,
                'subjects' => 'الفلسفة',
                'level' => 'twelfth',
                'status' => 'approved',
                'cv_path' => 'system/ghalia_cv.pdf',
            ]
        );
        $ghaliaTeacher->subjects()->sync($allSubjectIds);
        $ghaliaTeacher->classes()->sync($allClassIds);


        $yumnaTeacher = Teacher::firstOrCreate(
            ['phone' => '0989898989'],
            [
                'full_name' => 'يمنى الرقاعي',
                'password' => $commonPassword,
                'subjects' => 'كل المواد',
                'level' => 'twelfth',
                'status' => 'approved',
                'cv_path' => 'system/ghalia_cv.pdf',
            ]
        );
        $yumnaTeacher->subjects()->sync($allSubjectIds);
        $yumnaTeacher->classes()->sync($allClassIds);


        // $allSubjectsTeacher = Teacher::firstOrCreate(
        //     ['phone' => '0900000000'],
        //     [
        //         'full_name' => 'أستاذ كل المواد',
        //         'password' => $commonPassword,
        //         'subjects' => 'كل المواد',
        //         'level' => 'twelfth',
        //         'status' => 'approved',
        //         'cv_path' => 'system/all_cv.pdf',
        //     ]
        // );
        // $allSubjectsTeacher->subjects()->sync($allSubjectIds);
        // $allSubjectsTeacher->classes()->sync($allClassIds);

        // $ninthTeacher = Teacher::firstOrCreate(
        //     ['phone' => '0900000009'],
        //     [
        //         'full_name' => 'أستاذ مواد التاسع',
        //         'password' => $commonPassword,
        //         'subjects' => 'مواد التاسع',
        //         'level' => 'ninth',
        //         'status' => 'approved',
        //         'cv_path' => 'system/ninth_cv.pdf',
        //     ]
        // );
        // $ninthTeacher->subjects()->sync($ninthSubjectIds);
        // $ninthTeacher->classes()->sync($ninthClassIds);

        // $twelfthTeacher = Teacher::firstOrCreate(
        //     ['phone' => '0900000012'],
        //     [
        //         'full_name' => 'أستاذ مواد البكالوريا',
        //         'password' => $commonPassword,
        //         'subjects' => 'مواد البكالوريا',
        //         'level' => 'twelfth',
        //         'status' => 'approved',
        //         'cv_path' => 'system/twelfth_cv.pdf',
        //     ]
        // );
        // $twelfthTeacher->subjects()->sync($twelfthSubjectIds);
        // $twelfthTeacher->classes()->sync($twelfthClassIds);
    }
}
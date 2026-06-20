<?php

namespace Database\Seeders;

use App\Models\Subject;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class SubjectLessonsCountSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $subjects = [
            1 => 24,   
            2 => 29,    
            3 => 30, 
            4 => 28,
            5 => 25,
            6 => 27,
            7 => 26,
            8 => 24,
            9 => 30,
            10 => 28,
            11 => 25,
            12 => 27,
            13 => 26,
            14 => 24,
            15 => 30,
            16 => 28,
             ];

        foreach ($subjects as $id => $count) {
            $subject = Subject::find($id);
            if ($subject) {
                $subject->total_lessons = $count;
                $subject->save();
            }
        }
    }
}
    


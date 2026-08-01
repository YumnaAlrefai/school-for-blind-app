<?php

namespace Database\Seeders;

use App\Models\Exam;
use App\Models\Question;
use App\Models\Subject;
use Carbon\Carbon;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class ExamSeeder extends Seeder
{
    
    public function run(): void
    {
       $subject = Subject::create([
        'name' => 'الرياضيات',
        'grade_level' => 'الصف الأول',       
        'number_of_lessons' => '5',         
        'total_lessons' => 20,
    ]);
        $exam = Exam::create([
            'title' => 'مذاكرة الرياضيات للفصل الأول',
            'description' => 'ما هو ناتج جمع 5 + 7؟',
            'subject_id' => $subject->id,
            'exam_date' => Carbon::now()->addDays(7), 
            'duration_minutes' => 45,
            'is_published' => true,
        ]);

        $question1 = Question::create([
            'description' => 'ما هو ناتج جمع 5 + 7؟',
            'correct_answer' => '12',
            'teacher_id' => 1,           
    'type' => 'TEXT',            
    'status' => 'publish',
        ]);

        $question2 = Question::create([
            'description' => 'ما هو الجذر التربيعي للرقم 16؟',
            'correct_answer' => '4',
            'teacher_id' => 1,      
    'type' => 'TEXT',            
    'status' => 'publish',
        ]);

        $exam->questions()->attach([$question1->id, $question2->id]);
    }
}
    


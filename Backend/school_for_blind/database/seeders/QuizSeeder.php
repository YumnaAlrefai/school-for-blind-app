<?php

namespace Database\Seeders;

use App\Models\Choice;
use App\Models\Classes;
use App\Models\Lesson;
use App\Models\Question;
use App\Models\Quiz;
use App\Models\Subject;
use App\Models\Teacher;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class QuizSeeder extends Seeder
{
    public function run(): void
    {
        $teacher = Teacher::firstOrCreate(
            ['phone' => '099889999999'],
            [
                'full_name' => 'الأستاذ التجريبي الشامل',
                'password' => Hash::make('12345678'),
                'subjects' => '',
                'level' => 'twelfth',
                'status' => 'approved',
                'cv_path' => 'teacher_cv.pdf',
            ]
        );

        // ربطه مع جميع الشعب
        $teacher->classes()->sync(Classes::pluck('id'));

        foreach (Subject::all() as $subject) {

            $teacher->subjects()->syncWithoutDetaching([
                $subject->id => [
                    'price_for_lesson' => 0
                ]
            ]);



            foreach (Classes::all() as $cls) {
                $lesson = Lesson::create([
                    'title' => "كويزات مادة {$subject->name}",
                    'subject_id' => $subject->id,
                    'teacher_id' => $teacher->id,
                    'class_id' => $cls->id,
                ]);

                $quiz = Quiz::create([
                    'numofquestions' => 12,
                    'timelimit' => 15,
                    'totalmark' => 12,
                    'subject_id' => $subject->id,
                    'lesson_id' => $lesson->id,
                    'teacher_id' => $teacher->id,
                ]);

                /*
                |--------------------------------------------------------------------------
                | MCQ
                |--------------------------------------------------------------------------
                */

                for ($i = 1; $i <= 4; $i++) {

                    $question = Question::create([
                        'teacher_id' => $teacher->id,
                        'type' => 'mcq',
                        'description' => "اختر الخيار الصحيح رقم {$i}",
                        'points' => 1,
                        'status' => 'publish',
                    ]);

                    $choices = [
                        ['الخيار الأول', false],
                        ['الخيار الثاني', false],
                        ['الخيار الثالث', false],
                        ['الخيار الرابع', true],
                    ];

                    shuffle($choices);

                    foreach ($choices as $choice) {

                        Choice::create([
                            'question_id' => $question->id,
                            'choice_text' => $choice[0],
                            'is_correct' => $choice[1],
                        ]);
                    }

                    $quiz->questions()->attach($question->id);
                }

                /*
                |--------------------------------------------------------------------------
                | True False
                |--------------------------------------------------------------------------
                */

                for ($i = 1; $i <= 4; $i++) {

                    $answer = rand(0, 1) ? 'True' : 'False';

                    $question = Question::create([
                        'teacher_id' => $teacher->id,
                        'type' => 'TF',
                        'description' => "العبارة رقم {$i} صحيحة.",
                        'correct_answer' => $answer,
                        'points' => 1,
                        'status' => 'publish',
                    ]);

                    $quiz->questions()->attach($question->id);
                }

                /*
                |--------------------------------------------------------------------------
                | Text
                |--------------------------------------------------------------------------
                */

                $texts = [

                    [
                        'q' => 'اكتب اسم عاصمة سوريا.',
                        'a' => 'دمشق'
                    ],

                    [
                        'q' => 'ما لون السماء في النهار؟',
                        'a' => 'أزرق'
                    ],

                    [
                        'q' => 'اكتب كلمة الترحيب.',
                        'a' => 'أهلاً وسهلاً'
                    ],

                    [
                        'q' => 'ما حاصل 2 + 2 ؟',
                        'a' => '4'
                    ],

                ];

                foreach ($texts as $text) {

                    $question = Question::create([
                        'teacher_id' => $teacher->id,
                        'type' => 'TEXT',
                        'description' => $text['q'],
                        'correct_answer' => $text['a'],
                        'points' => 1,
                        'status' => 'publish'
                    ]);

                    $quiz->questions()->attach($question->id);
                }

            }
        }
    }
}
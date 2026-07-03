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
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;

class ContentSeeder extends Seeder
{
    public function run(): void
    {
        $source = database_path('seeders/files/default_audio.ogg');
        if (!Storage::disk('public')->exists('lessons/default_audio.ogg')) {
            if (file_exists($source)) {
                Storage::disk('public')->put('lessons/default_audio.ogg', file_get_contents($source));
            } else {
                Storage::disk('public')->put('lessons/default_audio.ogg', 'dummy audio content');
            }
        }

        $realLessons = [
            [
                'subject_name' => 'اللغة العربية',
                'level' => 'twelfth',
                'lessons' => ['حتى لا تضيع الهوية', 'الربيع العائد']
            ],
            [
                'subject_name' => 'الفلسفة',
                'level' => 'twelfth',
                'lessons' => ['المعرفة ومصادرها', 'المعرفة العلمية والمعرفة العامية']
            ],
            [
                'subject_name' => 'التاريخ',
                'level' => 'twelfth',
                'lessons' => ['الفكر السياسي وبناء الدولة']
            ],
            [
                'subject_name' => 'الجغرافيا',
                'level' => 'twelfth',
                'lessons' => ['الكون ومكوناته (المنظومة الشمسية)']
            ],
            [
                'subject_name' => 'اللغة الإنكليزية',
                'level' => 'twelfth',
                'lessons' => ['Migration and Human Migration', 'The History of Paper and Writing']
            ],
            [
                'subject_name' => 'اللغة الفرنسية',
                'level' => 'twelfth',
                'lessons' => ['Les fêtes traditionnelles et les festivals culturels']
            ],
            [
                'subject_name' => 'التربية الدينية',
                'level' => 'twelfth',
                'lessons' => ['منهج التفكير العلمي في القرآن الكريم']
            ],
            [
                'subject_name' => 'الرياضيات (جبر)',
                'level' => 'ninth',
                'lessons' => ['القاسم المشترك الأكبر (GCD)']
            ],
            [
                'subject_name' => 'الفيزياء والكيمياء',
                'level' => 'ninth',
                'lessons' => ['الحركة الكيميائية وتأثير القوى (عزم القوة)', 'مزدوجة القوى وأثرها الدورانى']
            ],
            [
                'subject_name' => 'علم الأحياء والأرض',
                'level' => 'ninth',
                'lessons' => ['الجهاز العصبي المركزي (البنية والوظيفة)']
            ],
            [
                'subject_name' => 'التاريخ',
                'level' => 'ninth',
                'lessons' => ['المراكز الحضارية الأولى وإشعاعها', 'الممالك السورية القديمة والإرث البشري']
            ],
            [
                'subject_name' => 'الجغرافيا',
                'level' => 'ninth', // تم تصحيح هذا السطر
                'lessons' => ['الأرض في الفضاء والحركات الفلكية', 'الخريطة وأدوات الجغرافيا الحديثة']
            ],
            [
                'subject_name' => 'اللغة العربية',
                'level' => 'ninth',
                'lessons' => ['قصيدة الناعورة (بدر الدين الحامد)', 'قصيدة روعة الآثار (شفيق جبري)']
            ],
            [
                'subject_name' => 'اللغة الإنكليزية',
                'level' => 'ninth',
                'lessons' => ['Healthy Eating Habits and Nutrition']
            ],
            [
                'subject_name' => 'اللغة الفرنسية',
                'level' => 'ninth',
                'lessons' => ['Les habitudes alimentaires et les activités sportives']
            ],
            [
                'subject_name' => 'التربية الدينية',
                'level' => 'ninth',
                'lessons' => ['منهج الحياة في سورة الحجرات', 'العلم والعمل أساس النهضة']
            ]
        ];

        $specialTeacherPhones = [
            '0943576695',
            '0989898989',
            '0900000000',
            '0900000009',
            '0900000012',
        ];

        $teachers = Teacher::whereIn('phone', $specialTeacherPhones)->get();

        DB::beginTransaction();

        $globalQuestionsPool = [];
        foreach ($teachers as $teacher) {
            $globalQuestionsPool[$teacher->id] = [];
            
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
                $globalQuestionsPool[$teacher->id][] = $question->id;
            }

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
                $globalQuestionsPool[$teacher->id][] = $question->id;
            }

            $texts = [
                ['q' => 'اكتب اسم عاصمة سوريا.', 'a' => 'دمشق'],
                ['q' => 'ما لون السماء في النهار؟', 'a' => 'أزرق'],
                ['q' => 'اكتب كلمة الترحيب.', 'a' => 'أهلاً وسهلاً'],
                ['q' => 'ما حاصل 2 + 2 ؟', 'a' => '4'],
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
                $globalQuestionsPool[$teacher->id][] = $question->id;
            }
        }

        foreach ($teachers as $teacher) {
            $subjectIndex = 0;

            foreach ($teacher->subjects()->get() as $subject) {
                $subjectLessons = [];
                foreach ($realLessons as $rl) {
                    if ($rl['subject_name'] === $subject->name && $rl['level'] === $subject->grade_level) {
                        $subjectLessons = $rl['lessons'];
                        break;
                    }
                }

                if (empty($subjectLessons)) {
                    $subjectLessons = ['الدرس الأول', 'الدرس الثاني'];
                }

                $classes = $teacher->classes()->where('level', $subject->grade_level)->get();

                foreach ($classes as $cls) {
                    foreach ($subjectLessons as $index => $lessonTitle) {
                        $lesson = Lesson::create([
                            'title' => $lessonTitle,
                            'subject_id' => $subject->id,
                            'teacher_id' => $teacher->id,
                            'class_id' => $cls->id,
                        ]);

                        $lesson->records()->create([
                            'record_path' => 'lessons/default_audio.ogg',
                            'record_mime' => 'audio/ogg',
                            'record_description' => null,
                            'duration' => 18,
                        ]);

                        if ($index % 2 == 0) {
                            $lesson->records()->create([
                                'record_path' => 'lessons/default_audio.ogg',
                                'record_mime' => 'audio/ogg',
                                'record_description' => null,
                                'duration' => 20,
                            ]);

                            $lesson->records()->create([
                                'record_path' => 'lessons/default_audio.ogg',
                                'record_mime' => 'audio/ogg',
                                'record_description' => null,
                                'duration' => 12,
                            ]);
                        }

                        $numberOfQuizzes = ($subjectIndex % 2 == 0) ? 0 : 1;

                        for ($q = 1; $q <= $numberOfQuizzes; $q++) {
                            $quiz = Quiz::create([
                                'numofquestions' => 12,
                                'timelimit' => 15,
                                'totalmark' => 12,
                                'subject_id' => $subject->id,
                                'lesson_id' => $lesson->id,
                                'teacher_id' => $teacher->id,
                            ]);

                            if (isset($globalQuestionsPool[$teacher->id])) {
                                $quiz->questions()->attach($globalQuestionsPool[$teacher->id]);
                            }
                        }
                    }
                }
                $subjectIndex++;
            }
        }

        DB::commit();
    }
}
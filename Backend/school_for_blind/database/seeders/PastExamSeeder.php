<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use App\Models\PastExam;
use App\Models\Question;
use App\Models\Subject;

class PastExamSeeder extends Seeder
{
    public function run(): void
    {
        $subject = Subject::firstOrCreate(
            ['name' => 'الكيمياء']
        );

        $teacherId = DB::table('teachers')->value('id') ?? 1;

        $pastExam = PastExam::create([
            'title' => 'امتحان شهادة الدراسة الثانوية - كيمياء',
            'subject_id' => $subject->id,
            'year' => '2021',
            'session' => 'second', 
            'voice_solution_path' => null,
            'is_published' => true,
        ]);

        $questionsData = [
            [
                'teacher_id' => $teacherId,
                'type' => 'mcq',
                'status' => 'publish',
                'description' => 'السؤال الأول: اختر الإجابة الصحيحة: 1- من خاصيات أشعة غاما: a) تتأثر بالحقل المغناطيسي b) تتأثر بالحقل الكهربائي c) تنتشر بسرعة الضوء d) تحمل شحنة سالبة',
                'correct_answer' => <<<'EOT'
(c) تنتشر بسرعة الضوء $c$
EOT
            ],
            [
                'teacher_id' => $teacherId,
                'type' => 'mcq',
                'status' => 'publish',
                'description' => 'السؤال الأول: اختر الإجابة الصحيحة: 2- في التفاعل المتوازن الآتي: $A_{(g)} + x B_{(g)} \rightleftarrows 3C_{(g)}$ يكون $K_p = K_c(RT)$ عندما تكون قيمة $x$ مساوية: a) 1 b) 2 c) 3 d) 4',
                'correct_answer' => <<<'EOT'
(c) 3
EOT
            ],
            [
                'teacher_id' => $teacherId,
                'type' => 'mcq',
                'status' => 'publish',
                'description' => 'السؤال الأول: اختر الإجابة الصحيحة: 3- كل مادة كيميائية قادرة على منح زوج إلكتروني أو أكثر لمادة أخرى تتفاعل معها هي: a) حمض برونشتد - لوري b) حمض لويس c) أساس برونشتد - لوري d) أساس لويس',
                'correct_answer' => <<<'EOT'
(d) أساس لويس
EOT
            ],

            [
                'teacher_id' => $teacherId,
                'type' => 'TEXT',
                'status' => 'publish',
                'description' => 'السؤال الثاني: نعاير حمض النمل $HCOOH$ بهدروكسيد الصوديوم $NaOH$ والمطلوب: a) ما طبيعة الوسط عند نهاية المعايرة؟ ولماذا؟ b) حدّد المشعر المناسب لهذه المعايرة.',
                'correct_answer' => <<<'EOT'
a) الوسط أساسي، بسبب احتواء المحلول على أيونات النملات $HCOO^-$ الذي يسلك سلوك أساس (ضعيف).
b) المشعر المناسب: فينول فتالئين.
EOT
            ],
            [
                'teacher_id' => $teacherId,
                'type' => 'TEXT',
                'status' => 'publish',
                'description' => 'السؤال الثالث: أكمل ووازن التفاعل النووي الآتي، ثم حدد نوع هذا التفاعل: $4 ^1_1H \longrightarrow ^4_2He + 2 ^0_{+1}e + \dots$',
                'correct_answer' => <<<'EOT'
المعادلة:
$$4 ^1_1H \longrightarrow ^4_2He + 2 ^0_{+1}e + Energy$$
النوع: إندماج نووي.
EOT
            ],
            [
                'teacher_id' => $teacherId,
                'type' => 'TEXT',
                'status' => 'publish',
                'description' => 'السؤال الرابع: يحدث التفاعل المتوازن الآتي في شروط مناسبة: $2NO_{(g)} + O_{2(g)} \rightleftarrows 2NO_{2(g)}$ ، $\Delta H < 0$. المطلوب: a) اكتب علاقة ثابت التوازن $K_p$ لهذا التفاعل المتوازن بدلالة الضغوط الجزئية. b) بيّن أثر زيادة درجة الحرارة على كلّ من: (حالة التوازن ، قيمة ثابت التوازن $K_c$).',
                'correct_answer' => <<<'EOT'
a) علاقة ثابت التوازن:
$$K_p = \frac{P^2_{(NO_2)}}{P^2_{(NO)} \times P_{(O_2)}}$$

b) أثر زيادة درجة الحرارة:
يرجح التفاعل العكسي، وتنقص قيمة $K_c$.
EOT
            ],
            [
                'teacher_id' => $teacherId,
                'type' => 'TEXT',
                'status' => 'publish',
                'description' => 'السؤال الخامس: أجب عن أحد السؤالين الآتيين: 1- محلول مائي لملح نترات الأمونيوم. المطلوب: a) اكتب معادلة إماهة هذا الملح. b) اكتب معادلة حلمهة هذا الملح. c) اكتب عبارة ثابت حلمهة هذا الملح $K_h$ بدلالة التراكيز. 2- اكتب المعادلة الكيميائية المعبّرة عن تفاعل ضمّ الماء إلى البروبين-1 بوجود حمض الكبريت كحفّاز، ثمّ اكتب اسم المركب العضوي الناتج.',
                'correct_answer' => <<<'EOT'
حل الخيار الأول (ملح نترات الأمونيوم):
a) معادلة الإماهة:
$$NH_4NO_3 \longrightarrow NH_4^+ + NO_3^-$$
b) معادلة الحلمهة:
$$NH_4^+ + H_2O \rightleftarrows NH_3 + H_3O^+$$
c) عبارة ثابت الحلمهة:
$$K_h = \frac{[NH_3][H_3O^+]}{[NH_4^+]}$$

حل الخيار الثاني (تفاعل الضم):
المعادلة:
$$CH_3-CH=CH_2 + H_2O \longrightarrow CH_3-CH(OH)-CH_3$$
اسم المركب العضوي الناتج: بروبان - 2 - ول.
EOT
            ],
            [
                'teacher_id' => $teacherId,
                'type' => 'TEXT',
                'status' => 'publish',
                'description' => 'المسألة الأولى: يحوي وعاء مغلق حجمه 41 L مزيجاً غازياً مكوّن من 48 g من غاز الميتان $CH_4$ و 60 g من غاز الايتان $C_2H_6$. المطلوب حساب: الضغط الكلي للمزيج الغازي عند الدرجة 300 K. الكسر المولي لغاز الميتان عند درجة الحرارة السابقة.',
                'correct_answer' => <<<'EOT'
الطلب الأول (الضغط الكلي):
$n = \frac{m}{M}$
$n_{CH_4} = \frac{48}{16} = 3 (mol)$
$n_{C_2H_6} = \frac{60}{30} = 2 (mol)$
$P_t = \frac{n_t R T}{V}$
$P_t = \frac{(3+2) \times 0.082 \times 300}{41}$
$P_t = 3 \text{ atm}$

الطلب الثاني (الكسر المولي):
$$X_{(CH_4)} = \frac{n_{CH_4}}{n_t}$$
$$X_{(CH_4)} = \frac{3}{5}$$
EOT
            ],
            [
                'teacher_id' => $teacherId,
                'type' => 'TEXT',
                'status' => 'publish',
                'description' => 'المسألة الثانية: يحدث التفاعل الأوّلي الآتي في شروط مناسبة: $2A_{(g)} + B_{(g)} \longrightarrow 2C_{(g)}$ فإذا علمت أنّ التراكيز الابتدائية: $[A]_0 = 0.4 mol.L^{-1}$ ، $[B]_0 = 0.2 mol.L^{-1}$ ، $[C]_0 = 0$ ، وثابت سرعة التفاعل $k = 10^{-2}$. المطلوب حساب: السرعة الابتدائية للتفاعل السابق، وحدّد رتبته. تركيز المادة $C$ وسرعة التفاعل بعد زمن يصبح فيه: $[B] = 0.15 mol.L^{-1}$.',
                'correct_answer' => <<<'EOT'
الطلب الأول:
$v = k[A]^2[B]$
$v_0 = 10^{-2}(0.4)^2(0.2)$
$v_0 = 32 \times 10^{-5} mol.L^{-1}.s^{-1}$
رتبة التفاعل: 3

الطلب الثاني (عندما يصبح تركيز B يساوي 0.15):
نحسب التغير $x$ من معادلة التفاعل:
$[B] = 0.2 - x = 0.15 \Rightarrow x = 0.05 (mol.L^{-1})$
$[C] = 2x = 2(0.05) = 0.1 mol.L^{-1}$
$[A] = 0.4 - 2(0.05) = 0.3 (mol.L^{-1})$
السرعة الجديدة:
$v = 10^{-2}(0.3)^2(0.15)$
$v = 13.5 \times 10^{-5} mol.L^{-1}.s^{-1}$
EOT
            ],
            [
                'teacher_id' => $teacherId,
                'type' => 'TEXT',
                'status' => 'publish',
                'description' => 'المسألة الثالثة: تُذاب عينة غير نقية من هدروكسيد البوتاسيوم كتلتها 5.6 g في الماء المقطّر، ويُكمل الحجم إلى 800 mL، فإذا كان تركيز محلول هدروكسيد البوتاسيوم السابق $0.1 mol.L^{-1}$. المطلوب حساب: قيمة $pH$ محلول هدروكسيد البوتاسيوم المستعمل. كتلة هدروكسيد البوتاسيوم النقي في العينة. النسبة المئوية للشوائب في العينة السابقة.',
                'correct_answer' => <<<'EOT'
الطلب الأول (قيمة pH):
$[KOH] = 10^{-1} mol.L^{-1}$
$[OH^-] = 10^{-1} (mol.L^{-1})$
$[H_3O^+] = \frac{10^{-14}}{[OH^-]}$
$[H_3O^+] = \frac{10^{-14}}{10^{-1}} = 10^{-13} (mol.L^{-1})$
$[H_3O^+] = 10^{-pH} \Rightarrow pH = 13$

الطلب الثاني (الكتلة النقية):
$M_{KOH} = 39 + 16 + 1 = 56 (g.mol^{-1})$
$m = C \times V \times M$
$m = 0.1 \times 0.8 \times 56 = 4.48 \text{ g}$

الطلب الثالث (نسبة الشوائب):
كتلة الشوائب $m' = 5.6 - 4.48 = 1.12 (g)$
كل $5.6 (g)$ تحوي شوائب $1.12 (g)$
كل $100 (g)$ تحوي شوائب $y$
$y = \frac{1.12 \times 100}{5.6} = 20\%$
EOT
            ],
            [
                'teacher_id' => $teacherId,
                'type' => 'TEXT',
                'status' => 'publish',
                'description' => 'المسألة الرابعة: محلول مائي مشبع لملح كلوريد الفضة $AgCl$ ، ذوبانيته $s = 2.5 \times 10^{-5} mol.L^{-1}$. المطلوب: اكتب معادلة التوازن غير المتجانس لهذا الملح. احسب قيمة ثابت جداء الذوبان $K_{sp(AgCl)}$ لهذا الملح. يُضاف إلى محلول الملح السابق مسحوق من ملح كلوريد البوتاسيوم $KCl$ حتى يصبح تركيز هذا الملح في المحلول $0.5 \times 10^{-5} mol.L^{-1}$ بيّن بالحساب إن كان قسم من ملح كلوريد الفضة يترسب أم لا.',
                'correct_answer' => <<<'EOT'
الطلب الأول (معادلة التوازن):
$$AgCl_{(s)} \rightleftarrows Ag^+_{(aq)} + Cl^-_{(aq)}$$

الطلب الثاني (جداء الذوبان):
$K_{sp} = [Ag^+][Cl^-]$
$K_{sp} = (2.5 \times 10^{-5})^2$
$K_{sp} = 6.25 \times 10^{-10}$

الطلب الثالث (إضافة KCl):
$[KCl] = [Cl^-] = 0.5 \times 10^{-5} (mol.L^{-1})$
التركيز الجديد للكلوريد:
$[Cl^-]' = 2.5 \times 10^{-5} + 0.5 \times 10^{-5} = 3 \times 10^{-5} (mol.L^{-1})$
نحسب الجداء الأيوني Q:
$Q = [Ag^+][Cl^-]'$
$Q = 2.5 \times 10^{-5} \times 3 \times 10^{-5} = 7.5 \times 10^{-10}$
بما أن $Q > K_{sp}$ ، إذن يترسب ملح كلوريد الفضة.
EOT
            ],
        ];

        foreach ($questionsData as $data) {
            $question = Question::create($data);
            $pastExam->questions()->attach($question->id);
        }
    }
}
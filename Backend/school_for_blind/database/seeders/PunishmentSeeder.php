<?php
namespace Database\Seeders;

use App\Models\Punishment;
use Illuminate\Database\Seeder;

class PunishmentSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $punishments = [
            [
                'name' => 'Mute',
                'level' => 1,
                'description' => 'منع من المحادثات - درجة أولى (لمدة يوم واحد)',
                'duration_minutes' => 1440, // 24 ساعة × 60 دقيقة
            ],
            [
                'name' => 'Mute',
                'level' => 2,
                'description' => 'منع من المحادثات - درجة ثانية (لمدة 3 أيام)',
                'duration_minutes' => 4320,
            ],
            [
                'name' => 'Mute',
                'level' => 3,
                'description' => 'منع من المحادثات - درجة ثالثة (لمدة أسبوع)',
                'duration_minutes' => 10080,
            ],

            [
                'name' => 'Warning',
                'level' => 1,
                'description' => 'إنذار أكاديمي أو سلوكي - درجة أولى (تنبيه أول)',
                'duration_minutes' => null,
            ],
            [
                'name' => 'Warning',
                'level' => 2,
                'description' => 'إنذار أكاديمي أو سلوكي - درجة ثانية (تنبيه ثاني خطير)',
                'duration_minutes' => null,
            ],
            [
                'name' => 'Warning',
                'level' => 3,
                'description' => 'إنذار أكاديمي أو سلوكي - درجة ثالثة (تنبيه نهائي قبل الحظر)',
                'duration_minutes' => null,
            ],

            [
                'name' => 'Report Ban',
                'level' => 1,
                'description' => 'منع من إرسال البلاغات - درجة أولى (لمدة 3 أيام)',
                'duration_minutes' => 4320,
            ],
            [
                'name' => 'Report Ban',
                'level' => 2,
                'description' => 'منع من إرسال البلاغات - درجة ثانية (لمدة أسبوع)',
                'duration_minutes' => 10080,
            ],
            [
                'name' => 'Report Ban',
                'level' => 3,
                'description' => 'منع من إرسال البلاغات - درجة ثالثة (لمدة شهر كامل)',
                'duration_minutes' => 43200,
            ],
        ];

        foreach ($punishments as $punishment) {
            Punishment::create($punishment);
        }
    }
}
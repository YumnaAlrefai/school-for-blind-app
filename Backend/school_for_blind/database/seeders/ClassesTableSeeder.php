<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class ClassesTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $levels =  ['ninth', 'twelfth'];

        $divisions = [
            'First Division',
            'Second Division',
            'Third Division',
            'Fourth Division',
            'Fifth Division',
            'Sixth Division',
            'Seventh Division',
            'Eighth Division',
            'Ninth Division',
            'Tenth Division'
        ];

        foreach ($levels as $level) {
            foreach ($divisions as $index => $divisionName) {

                $divisionNumber = $index + 1;
                $classId = DB::table('classes')->insertGetId([
                    'name' => $divisionName,
                    'level' => $level,
                    'number' => $divisionNumber,
                    'created_at' => now(),
                    'updated_at' => now(),
                ]);
            }
        }
    }
}

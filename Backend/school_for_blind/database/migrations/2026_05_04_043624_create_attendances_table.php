<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('attendances', function (Blueprint $table) {
            $table->id();
//$table->foreignId('student_id')->constrained('students');
//$table->foreignId('schedule_id')->constrained('schedules');
$table->enum('status',['present','absent','late']);
$table->integer('minutes_attended')->nullable();
$table->date('date');




            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('attendances');
    }
};

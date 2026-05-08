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
        Schema::create('reports', function (Blueprint $table) {
            $table->id();
//$table->foreignId('student_id')->constrained('students')->onDelete('cascade');
//$table->unsignedBigInteger('from_who');
$table->string('to_who')->default('administration');
$table->text('reason');
//$table->foreignId('punishment_id')->nullable()->constrained('punishments');
$table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('reports');
    }
};

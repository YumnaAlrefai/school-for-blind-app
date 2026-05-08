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
        Schema::create('records', function (Blueprint $table) {
            $table->id();
$table->enum('recordabletype', ['Lesson', 'Quiz', 'SupportTicket']);
    $table->unsignedBigInteger('recordable_id');
    $table->string('recordpath');
    $table->string('recordmime');
    $table->string('recorddescription');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('records');
    }
};

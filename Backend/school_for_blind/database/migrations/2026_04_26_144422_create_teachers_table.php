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
        Schema::create('teachers', function (Blueprint $table) {
             $table->id();
            $table->timestamps();
            $table->string('full_name');
            $table->string('phone')->unique();
            // $table->date('date_of_birth');
            $table->string('subjects');
            $table->enum('level', ['ninth', 'twelfth']);
            $table->enum('status', ['pending', 'approved', 'rejected'])->default('pending');
            $table->string('cv_path');
            $table->text('fcm_token')->nullable();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('teachers');
    }
};

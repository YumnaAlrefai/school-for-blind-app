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
        Schema::create('students', function (Blueprint $table) {
            $table->id();
 $table->string('fullname');
         $table->string('phone')->unique();
           $table->string('parent_phone');
            $table->integer('points')->default(0);
            $table->string('fcm_token')->nullable();
           $table->string('level');
           $table->timestamp('phone_verified_at')->nullable();
$table->enum('status', ['active', 'not_active', 'pending_approval'])->default('not_active');           $table->string('DocumentaryEvidence');

           $table->string('otp')->nullable();
        $table->timestamp('otp_expires_at')->nullable();
        $table->string('verification_token')->nullable();
        $table->timestamp('token_expires_at')->nullable();
           /* $table->foreignId('class_id')
             ->nullable()
             ->constrained('classes')
                  ->onDelete('set null');
 $table->foreignId('parent_id')
                  ->nullable()
                  ->constrained('parents')
                  ->onDelete('set null');*/

            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('students');
    }
};

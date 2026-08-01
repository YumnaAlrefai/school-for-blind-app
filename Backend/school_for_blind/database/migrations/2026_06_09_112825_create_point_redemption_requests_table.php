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
        Schema::create('point_redemption_requests', function (Blueprint $table) {
            $table->id();


            $table->integer('points_to_redeem');
            $table->decimal('amount_paid', 10, 2)->nullable();
            $table->enum('status', ['pending', 'approved', 'rejected'])->default('pending');
            $table->foreignId('student_id')->constrained('students')->onDelete('cascade'); // ربط الطلب بالطالب يلي قدمه
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('point_redemption_requests');
    }
};

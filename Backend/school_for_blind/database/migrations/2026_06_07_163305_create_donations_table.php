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
        Schema::create('donations', function (Blueprint $table) {
            $table->id();
            $table->string('donor_name')->nullable();
            $table->decimal('amount', 10, 2);
            $table->string('currency')->default('USD');
            $table->string('stripe_session_id')->unique();
            $table->string('status')->default('pending');
            $table->foreignId('user_id')->nullable()->constrained('students')->onDelete('cascade');
            $table->timestamps();
        });

        /**
         * Reverse the migrations.
         */
        function down(): void
        {
            Schema::dropIfExists('donations');
        }
    }};

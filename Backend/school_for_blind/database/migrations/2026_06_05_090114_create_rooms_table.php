<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('rooms', function (Blueprint $table) {
            $table->id();
            $table->morphs('creator');
            $table->foreignId('class_id')->constrained('classes')->onDelete('cascade');
            $table->string('room_name')->unique();
            $table->enum('status', ['active', 'ended'])->default('active');
            $table->json('kicked_participants')->nullable();
            $table->json('muted_participants')->nullable();
            $table->timestamp('started_at')->useCurrent();
            $table->timestamp('ended_at')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('rooms');
    }
};

<?php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('punishables', function (Blueprint $table) {
            $table->id();
            $table->foreignId('punishment_id')->constrained('punishments')->cascadeOnDelete();
            $table->morphs('punishable');
            $table->foreignId('admin_id')->constrained('admins')->cascadeOnDelete();
            $table->timestamp('expires_at')->nullable();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('punishables');
    }
};
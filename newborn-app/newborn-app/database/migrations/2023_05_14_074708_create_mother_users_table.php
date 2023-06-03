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
        Schema::create('mother_users', function (Blueprint $table) {
            $table->id();
            $table->string('identity_number')->unique();
            $table->string('username');
            $table->string('password')->nullable(); // Allow null values for the password column
            $table->string('phone')->nullable();
            $table->foreignId('role_id')->unsignedBigInteger()->default(1);
            $table->rememberToken();
            $table->timestamps();
        });

    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('mother_users');
    }
};

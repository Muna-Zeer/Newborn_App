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
        Schema::create('HealthCenters', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('name')->nullable();
            $table->string('address')->nullable();
            $table->string('phone_number')->nullable();
            $table->unsignedBigInteger('ministry_id')->nullable();
            $table->string('responsible_doctors')->nullable();
            $table->string('responsible_nurses')->nullable();
            $table->unsignedInteger('total_vaccinations')->default(0);
            $table->unsignedInteger('total_positive_cases')->default(0);
            $table->unsignedBigInteger('ministry_of_health_id')->nullable();
            $table->unsignedBigInteger('nurse_id')->nullable();
            $table->unsignedBigInteger('doctor_id')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('health_centers');
    }
};

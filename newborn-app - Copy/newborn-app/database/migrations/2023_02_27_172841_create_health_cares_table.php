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
        Schema::create('HealthCares', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('disease_type')->nullable();
            $table->text('symptoms')->nullable();
            $table->text('care_tips')->nullable();
            $table->unsignedBigInteger('ministry_id')->nullable();

            $table->timestamps();
        });
      
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('health_cares');
    }
};

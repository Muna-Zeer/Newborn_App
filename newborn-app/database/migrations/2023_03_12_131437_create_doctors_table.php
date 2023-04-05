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
        Schema::create('doctors', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('name')->nullable();
            $table->integer('salary')->nullable();
            $table->unsignedBigInteger('nurse_id')->nullable();
            $table->unsignedBigInteger('midwife_id')->nullable();
            $table->unsignedBigInteger('specialization_id')->nullable();
            $table->unsignedBigInteger('ministry_of_health_id')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('doctors');
    }
};

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
        Schema::create('midwives', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('name')->nullable();
            $table->integer('hours')->nullable();
            $table->integer('salary')->nullable();
            $table->string('communication_skills')->nullable();

            $table->string('mother_name')->nullable();
            $table->string('newborn_bracelet_hand')->nullable();
            $table->string('newborn_bracelet_leg')->nullable();
            $table->text('report')->nullable();
            $table->unsignedBigInteger('doctor_id')->nullable();
            $table->unsignedBigInteger('hospital_id')->nullable();
            $table->text('schedule')->nullable();
            $table->time('startTime')->nullable();
            $table->time('endTime')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('midwives');
    }
};

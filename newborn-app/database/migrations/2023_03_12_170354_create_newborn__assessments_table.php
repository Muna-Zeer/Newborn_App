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
        Schema::create('NewbornAssessments', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('Birth_Weight')->nullable();
            $table->date('date_of_delivery')->nullable();
            $table->enum('mode_of_delivery',['C.S','V.D'])->nullable();
            $table->string('Gestational_age_at_delivery')->nullable();
            $table->string('Temp')->nullable();
            $table->string('Pulse')->nullable();
            $table->string('Resp_rate')->nullable();
            $table->integer('Weight')->nullable();
            $table->integer('height')->nullable();
            $table->integer('HC')->nullable();
            $table->string('Sex')->nullable();
            $table->enum('Congenital_Malformation',['Yes','No','Referred'])->nullable();
            $table->enum('Jaundice',['Yes','No','Referred'])->nullable();
            $table->enum('Cyanosis',['Yes','No','Referred'])->nullable();
            $table->enum('Umbilical_stump',['Clean','Infected','Referred'])->nullable();
            $table->enum('Feeding',['Mixed','Artificial','Exclusive'])->nullable();
            $table->text('Remarks')->nullable();
            $table->unsignedBigInteger('doctor_id')->nullable();
            $table->unsignedBigInteger('midwife_id')->nullable();
            $table->unsignedBigInteger('nurse_id')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('newborn__assessments');
    }
};

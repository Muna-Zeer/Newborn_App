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
        Schema::create('NewbornExaminations', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('newbornName')->nullable();
            $table->enum('Sex',['Female','Male'])->nullable();
            $table->enum('Birth_outcome',['Alive','Abortion','Stillbirth','Late_Neonatal','Early_Neonatal'])->nullable();
            $table->string('H_C')->nullable();
            $table->string('Length')->nullable();
            $table->string('Weight_gr')->nullable();
            $table->string('Pulse')->nullable();
            $table->string('Temp')->nullable();
            $table->string('Respiratory_Rate')->nullable();
            $table->decimal('Apgar_score')->nullable();
            $table->string('breastfeeding_ft')->nullable();
            $table->text('Congenital_Malformation')->nullable();
            $table->text('Medication')->nullable();
            $table->unsignedBigInteger('vaccine_id')->nullable();
            $table->text('Complication_after_birth')->nullable();
            $table->text('Diagnosis')->nullable();
            $table->text('Referred')->nullable();
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
        Schema::dropIfExists('newborn_examinations');
    }
};

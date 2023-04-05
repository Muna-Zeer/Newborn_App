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
        Schema::create('PostnatalExaminations', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->integer('day_after_delivery')->nullable();
            $table->date('date_of_visit')->nullable();
            $table->string('Temp')->nullable();
            $table->string('Pulse')->nullable();
            $table->string('B_P')->nullable();
            $table->string('bleeding_after_delivery')->nullable();
            $table->string('Hb')->nullable();
            $table->boolean('DVT')->nullable();
            $table->boolean('Rupture_Uterus')->nullable();
            $table->enum('if_yes',['Repaired','Hysterectomy_Done'])->nullable();
            $table->enum('Lochia_color',['White','Yellow','Red'])->nullable();
            $table->enum('Incision',['Clean','Infected'])->nullable();
            $table->boolean('Seizures')->nullable();
            $table->boolean('Blood_Transfusion')->nullable();
            $table->enum('Breasts',['pain','redness','Hot','Abnormal_Secretions'])->nullable();
            $table->integer('Fundal_Height')->nullable();
            $table->string('Family_Planing_Counseling')->nullable();
            $table->date('FP_Appointment')->nullable();
            $table->text('Recommendations')->nullable();
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
        Schema::dropIfExists('postantal_examinations');
    }
};

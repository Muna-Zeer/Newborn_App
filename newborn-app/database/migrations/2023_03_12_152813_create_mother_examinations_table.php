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
        Schema::create('MotherExaminations', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('name_of_mother')->nullable();
            $table->integer('age')->nullable();
            $table->enum('place_of_birth',['Home','Clinic','Hospital','Other'])->nullable();
            $table->time('time_of_delivery')->nullable();
            $table->date('date_of_delivery')->nullable();
            $table->integer('weeks_of_pregnancy')->nullable();
            $table->enum('method_of_delivery',['Normal','Vaccum','Forceps','C.S']);
            $table->boolean('Episiotomy')->nullable();
            $table->enum('Perineal_Tear',['grade1','grade2','grade3','grade4'])->nullable();
            $table->boolean('Bleeding_after_delivery')->nullable();
            $table->boolean('Blood_transfusion')->nullable();
            $table->string('Temp')->nullable();
            $table->string('B_P')->nullable();
            $table->text('Complication_after_delivery')->nullable();
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
        Schema::dropIfExists('mother_examinations');
    }
};

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
        Schema::create('NewbornHospitalNurseries', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->unsignedBigInteger('newborn_id');
            $table->unsignedBigInteger('hospital_center_id');
            $table->dateTime('admission_date');
            $table->dateTime('discharge_date')->nullable();
            $table->unsignedBigInteger('doctor_id')->nullable(); // Add doctor_id column
            $table->unsignedBigInteger('midwife_id')->nullable(); // Add doctor_id column
            $table->unsignedBigInteger('newborn_bath_id')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('newborn_hospital_nurseries');
    }
};

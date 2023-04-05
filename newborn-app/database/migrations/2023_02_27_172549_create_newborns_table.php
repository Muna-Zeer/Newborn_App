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
        Schema::create('newborns', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('firstName')->nullable();
            $table->string('lastName')->nullable();
            $table->date('date_of_birth')->nullable();
            $table->string('gender')->nullable();
            $table->string('identity_number')->nullable();
            $table->decimal('weight')->nullable();
            $table->decimal('length')->nullable();
            $table->enum('status',['Normal','Abnormal'])->nullable();
            $table->string('delivery_method')->nullable();
            $table->unsignedBigInteger('mother_id')->nullable();
            $table->unsignedBigInteger('location_id')->nullable();
            $table->unsignedBigInteger('health_center_id')->nullable();
            $table->unsignedBigInteger('hospital_center_id')->nullable();
            $table->unsignedBigInteger('measurement_id')->nullable();
            $table->unsignedBigInteger('ministry_center_id')->nullable();
            $table->unsignedBigInteger('doctor_id')->nullable();
            $table->unsignedBigInteger('nurse_id')->nullable();
            $table->unsignedBigInteger('midwife_id')->nullable();
            $table->unsignedBigInteger('newborn_hospital_nursery_id')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('newborns');
    }
};

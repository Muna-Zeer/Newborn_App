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
        Schema::create('mothers', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('first_name')->nullable();
            $table->string('last_name')->nullable();
            $table->string('address')->nullable();
            $table->string('phone_number')->nullable();
            $table->string('email')->nullable();
            $table->date('date-of_birth')->nullable();
            $table->string('husband_name')->nullable();
            $table->string('identity_number')->nullable();
            $table->string('husband_phone_number')->nullable();
            $table->unsignedInteger('number_of_newborns')->default(0);
            $table->string('city')->nullable();
            $table->string('country')->nullable();
            $table->string('blood_type')->nullable();
            $table->string('HR')->nullable();
            $table->unsignedBigInteger('location_id')->nullable();
            $table->unsignedBigInteger('newborn_id')->nullable();
            $table->unsignedBigInteger('health_center_id')->nullable();
            $table->unsignedBigInteger('hospital_center_id')->nullable();
            $table->unsignedBigInteger('guideline_id')->nullable();
            $table->unsignedBigInteger('doctor_id')->nullable();
            $table->unsignedBigInteger('nurse_id')->nullable();

            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('mothers');
    }
};

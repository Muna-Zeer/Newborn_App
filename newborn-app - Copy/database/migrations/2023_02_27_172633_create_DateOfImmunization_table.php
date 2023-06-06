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
        Schema::create('DateOfImmunization', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('name')->nullable();
            $table->date('date_administrated')->nullable();
            $table->date('next_dose_date')->nullable();
            $table->string('administered_by')->nullable(); // added column for name of person who administered the vaccine
            $table->string('lot_no')->nullable(); // added column for lot number
            $table->unsignedBigInteger('newborn_id')->nullable();
            $table->unsignedBigInteger('vaccine_id')->nullable();
            $table->unsignedBigInteger('nurse_id')->nullable();
            $table->unsignedBigInteger('doctor_id')->nullable();
            $table->unsignedBigInteger('health_center_id')->nullable();
            $table->timestamps();
        });
    
    
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('vaccinations');
    }
};

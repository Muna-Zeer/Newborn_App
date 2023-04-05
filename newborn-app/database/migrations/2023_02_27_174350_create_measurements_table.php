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
        Schema::create('measurements', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->decimal('height')->nullable();
            $table->decimal('weight')->nullable();
            $table->decimal('head_circumference')->nullable();
            $table->date('date')->nullable();
            $table->time('time')->nullable();
            $table->string('nurse_name')->nullable();// added column for name of nurse who made the measurement
            $table->text('remarks')->nullable(); // added column for remarks
            $table->integer('age')->nullable(); // added column for age in monthsd
            $table->string('tonics')->nullable();// added column for any tonics given
            $table->unsignedBigInteger('newborn_id')->nullable();
            $table->unsignedBigInteger('nurse_id')->nullable();
            $table->unsignedBigInteger('midwife_id')->nullable();
            $table->unsignedBigInteger('health_center_id')->nullable();
            $table->unsignedBigInteger('ministry_id')->nullable();
            $table->unsignedBigInteger('hospital_id')->nullable();

            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('measurements');
    }
};

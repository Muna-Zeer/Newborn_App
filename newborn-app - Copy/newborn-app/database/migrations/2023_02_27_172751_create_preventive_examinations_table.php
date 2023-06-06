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
        Schema::create('PreventiveExaminations', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('exam_type')->nullable();
            $table->date('date')->nullable();
            $table->time('time')->nullable();
            $table->text('result')->nullable();
            $table->unsignedBigInteger('newborn_id')->nullable();
            $table->unsignedBigInteger('health_center_id')->nullable()->default(1);
            $table->unsignedBigInteger('ministry_id')->nullable()->default(1);
            $table->unsignedBigInteger('nurse_id')->nullable()->default(1);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('preventive_examinations');
    }
};

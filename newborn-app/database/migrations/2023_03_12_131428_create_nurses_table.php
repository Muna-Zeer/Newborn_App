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
        Schema::create('nurses', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('name')->nullable();
            $table->integer('salary')->nullable();
            $table->unsignedBigInteger('health_center_id')->nullable();
            $table->unsignedBigInteger('hospital_center_id')->nullable();
            $table->unsignedBigInteger('specialization_id')->nullable();
            $table->unsignedBigInteger('ministry_of_health_id')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('nurses');
    }
};

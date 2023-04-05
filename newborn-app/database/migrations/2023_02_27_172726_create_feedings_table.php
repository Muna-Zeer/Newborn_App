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
        Schema::create('feedings', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('feeding_type')->nullable();
            $table->decimal('quantity')->nullable();
            $table->date('date')->nullable();
            $table->time('time')->nullable();
            $table->unsignedBigInteger('newborn_id')->nullable();
            $table->string('month')->nullable();
            $table->text('instructions')->nullable();
            $table->unsignedBigInteger('ministry_id')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('feedings');
    }
};

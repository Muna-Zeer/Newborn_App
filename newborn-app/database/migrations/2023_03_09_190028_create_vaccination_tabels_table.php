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
        Schema::create('VaccinationTables', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('name')->nullable();
            $table->integer('doses')->nullable();
            $table->string('place')->nullable();
            $table->string('diseases')->nullable();
            $table->string('method')->nullable();
            $table->string('month')->nullable();
            $table->text('month_vaccinations')->nullable();
            $table->unsignedBigInteger('newborn_id')->nullable();
            $table->unsignedBigInteger('ministry_id')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('vaccination_tabels');
    }
};

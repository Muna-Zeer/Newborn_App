<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('newborn_vaccines', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->unsignedBigInteger('newborn_id');
            $table->unsignedBigInteger('vaccination_table_id')->default(1);
            $table->string('doctor_name');
            $table->date('vaccination_date')->default(DB::raw('CURRENT_TIMESTAMP'));

            $table->boolean('taken')->default(false);
            $table->timestamps();
            $table->foreign('newborn_id')->references('id')->on('newborns')->onDelete('cascade');
            $table->foreign('vaccination_table_id')->references('id')->on('VaccinationTables')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('newborn_vaccines');
    }
};

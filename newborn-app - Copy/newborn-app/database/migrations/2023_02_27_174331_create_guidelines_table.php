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
        Schema::create('guidelines', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('vaccine_name')->nullable(); // added column for the name of the vaccine
            $table->text('side_effects')->nullable(); // added column for the side effects of the vaccine
            $table->text('care_instructions')->nullable(); // added column for care instructions after vaccination
            $table->text('prevention_method')->nullable(); // added column for prevention method
            $table->unsignedBigInteger('ministry_id')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('guidelines');
    }
};

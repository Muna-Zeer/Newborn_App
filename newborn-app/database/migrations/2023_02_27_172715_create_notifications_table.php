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
        Schema::create('notifications', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('notification_type')->nullable();
            $table->text('message')->nullable();
            $table->unsignedBigInteger('recipient_id')->nullable();
            $table->unsignedBigInteger('immunization_id')->nullable();
            $table->unsignedBigInteger('health_center_id')->nullable();
            $table->unsignedBigInteger('hospital_center_id')->nullable();
            $table->unsignedBigInteger('vaccine_id')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('notifications');
    }
};

<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class HealthCare extends Model
{
    use HasFactory;
    protected $table ='HealthCares';
    protected $fillable = ['disease_type','symptoms','care_tips', 'ministry_id' ];

    // define the connection function to Ministry model
    public function ministry()
    {
        return $this->belongsTo(MinistryOfHealth::class);
    }
}

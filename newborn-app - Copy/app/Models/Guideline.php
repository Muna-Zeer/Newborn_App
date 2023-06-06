<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Guideline extends Model
{
    use HasFactory;
    protected $table = 'guidelines';

    protected $fillable = [ 'vaccine_name','side_effects','care_instructions','prevention_method', 'ministry_id'
    ];

    // define the connection function to Ministry model
    public function ministry()
    {
        return $this->belongsTo(MinistryOfHealth::class);
    }
}

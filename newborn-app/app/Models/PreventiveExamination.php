<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class PreventiveExamination extends Model
{
    use HasFactory;
    protected $table = 'PreventiveExaminations';

    protected $fillable = ['exam_type','date','time','result','newborn_id','hospital_id','health_center_id','ministry_id',  'nurse_id',];

    // define the connection function to Newborn model
    public function newborn()
    {
        return $this->belongsTo(Newborn::class);
    }

    // define the connection function to Hospital model
    public function hospital()
    {
        return $this->belongsTo(Hospital::class);
    }

    // define the connection function to HealthCenter model
    public function healthCenter()
    {
        return $this->belongsTo(HealthCenter::class);
    }

    // define the connection function to Ministry model
    public function ministry()
    {
        return $this->belongsTo(MinistryOfHealth::class);
    }
    public function nurse()
    {
        return $this->belongsTo(Nurse::class);
    }
}

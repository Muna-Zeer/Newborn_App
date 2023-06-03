<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class PostnatalExaminations extends Model
{
    use HasFactory;
    protected $table ='postnatalexaminations';
    protected $fillable = [ 'day_after_delivery','date_of_visit','Temp','Pulse','B_P', 'bleeding_after_delivery','Hb','DVT','Rupture_Uterus','if_yes','Lochia_color', 'Incision','Seizures','Blood_Transfusion','Breasts','Fundal_Height','Family_Planing_Counseling', 'FP_Appointment','Recommendations','Remarks','doctor_id','midwife_id','nurse_id'
    ];

    public function doctor()
    {
        return $this->belongsTo(Doctor::class,'doctor_id');
    }

    public function midwife()
    {
        return $this->belongsTo(Midwife::class,'midwife_id');
    }

    public function nurse()
    {
        return $this->belongsTo(Nurse::class,'nurse_id');
    }
}

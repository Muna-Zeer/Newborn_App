<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class newborn_hospital_nursery extends Model
{
    use HasFactory;
    protected $table ='NewbornHospitalNurseries';
    protected $fillable = ['newborn_id','hospital_center_id','admission_date','discharge_date','midwife_id','doctor_id','newborn_bath_id'
    ];

    public function newborn()
    {
        return $this->belongsTo(Newborn::class);
    }

    public function hospitalCenter()
    {
        return $this->belongsTo(Hospital::class);
    }

    public function midwife()
    {
        return $this->belongsTo(Midwife::class);
    }

    public function doctor()
    {
        return $this->belongsTo(Doctor::class);
    }

      /**
     * Get the newborn bath associated with the emergency.
     */
    public function newbornBath()
    {
        return $this->belongsTo(Newborn_bath::class);
    }
}

<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Measurements extends Model
{
    use HasFactory;
    protected $table = 'measurements';
    protected $fillable = ['height','weight','head_circumference','date','time', 'nurse_name', 'remarks','age', 'tonics','newborn_id','nurse_id', 'midwife_id', 'health_center_id','ministry_id','hospital_id',
    ];

    public function newborn()
    {
        return $this->belongsTo(Newborn::class);
    }
    public function HospitalCenter()
    {
        return $this->belongsTo(Hospital::class);
    }

    public function nurse()
    {
        return $this->belongsTo(Nurse::class);
    }

    public function midwife()
    {
        return $this->belongsTo(Midwife::class);
    }

    public function healthCenter()
    {
        return $this->belongsTo(HealthCenter::class);
    }

    public function ministry()
    {
        return $this->belongsTo(MinistryOfHealth::class);
    }

}

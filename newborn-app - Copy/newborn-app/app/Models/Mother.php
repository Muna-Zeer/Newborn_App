<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Mother extends Model
{
    use HasFactory;
    protected $table = 'mothers';
    protected $fillable = [
        'first_name', 'last_name', 'address', 'phone_number',
        'email', 'date_of_birth',
        'husband_name',
        'identity_number',
        'husband_phone_number',
        'number_of_newborns', 'city', 'country',
        'blood_type', 'HR', 'location_id',
        'newborn_id', 'health_center_id',
        'hospital_id',
        'guideline_id',
        'doctor_id', 'midwife_id',
    ];

    public function newborn()
    {
        return $this->hasOne(Newborn::class, 'identity_number', 'identity_number');
    }
    public function location()
    {
        return $this->belongsTo(Location::class);
    }



    public function healthCenter()
    {
        return $this->belongsTo(HealthCenter::class);
    }

    public function hospitalCenter()
    {
        return $this->belongsTo(Hospital::class, 'hospital_id');
    }

    public function guideline()
    {
        return $this->belongsTo(Guideline::class);
    }

    public function doctor()
    {
        return $this->belongsTo(Doctor::class);
    }

    public function nurse()
    {
        return $this->belongsTo(Nurse::class);
    }



}

<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class HealthCenter extends Model
{
    use HasFactory;
    protected $table ='HealthCenters';
    protected $fillable = ['name','address','phone_number','ministry_id','responsible_doctors','responsible_nurses','total_vaccinations',
        'total_positive_cases','ministry_of_health_id','nurse_id','doctor_id'
    ];

  

    public function ministryOfHealth()
    {
        return $this->belongsTo(MinistryOfHealth::class);
    }

    public function nurse()
    {
        return $this->belongsTo(Nurse::class);
    }

    public function doctor()
    {
        return $this->belongsTo(Doctor::class);
    }

    public function appointments()
    {
        return $this->hasMany(Appointment::class);
    }
}

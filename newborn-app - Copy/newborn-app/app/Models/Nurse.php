<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Nurse extends Model
{
    use HasFactory;
    protected $table ='nurses';
    protected $fillable = [
        'name', 'salary', 'hospital_id', 'ministry_of_health_id', 'doctor_id', 'specialization',
    ];


    public function healthCenter()
    {
        return $this->belongsTo('App\Models\HealthCenter');
    }

    public function hospitalCenter()
    {
        return $this->belongsTo('App\Models\Hospital');
    }


    public function ministryOfHealth()
    {
        return $this->belongsTo('App\Models\MinistryOfHealth');
    }
    public function doctor()
    {
        return $this->belongsTo(Doctor::class);
    }
}

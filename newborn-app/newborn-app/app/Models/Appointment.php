<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Appointment extends Model
{
    use HasFactory;
    protected $table ='appointments';
    protected $fillable = [ 'appointment_date','appointment_time', 'appointment_type', 'newborn_id','hospital_id', 'health_center_id'
    ];

    public function newborn()
    {
        return $this->belongsTo(Newborn::class);
    }

    public function hospital()
    {
        return $this->belongsTo(Hospital::class);
    }

    public function healthCenter()
    {
        return $this->belongsTo(HealthCenter::class);
    }
}

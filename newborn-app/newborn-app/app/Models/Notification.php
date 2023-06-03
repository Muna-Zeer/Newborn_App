<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Notification extends Model
{
    use HasFactory;
    protected $table ='notifications';
    protected $fillable = ['notification_type','message','recipient_id','immunization_id','health_center_id','hospital_center_id', 'vaccine_id'
    ];

    public function recipient()
    {
        return $this->belongsTo(User::class, 'recipient_id');
    }

    public function immunization()
    {
        return $this->belongsTo(DateOfImmunization::class);
    }

    public function healthCenter()
    {
        return $this->belongsTo(HealthCenter::class);
    }

    public function hospitalCenter()
    {
        return $this->belongsTo(Hospital::class);
    }

    public function vaccine()
    {
        return $this->belongsTo(VaccinationTabel::class);
    }
}

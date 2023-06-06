<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class DateOfImmunization extends Model
{
    use HasFactory;
    protected $table ='DateOfImmunization';
    protected $fillable = [ 'name','date_administrated', 'next_dose_date', 'administered_by', 'lot_no','newborn_id', 'vaccine_id','nurse_id', 'doctor_id', 'health_center_id'
    ];

    public function newborn()
    {
        return $this->belongsTo(Newborn::class);
    }
    public function nurse()
    {
        return $this->belongsTo(Nurse::class);
    }
    public function doctor()
    {
        return $this->belongsTo(Doctor::class);
    }
      public function healthCenter()
    {
        return $this->belongsTo(HealthCenter::class);
    }
    public function vaccine()
    {
        return $this->belongsTo(VaccinationTabel::class);
    }
}

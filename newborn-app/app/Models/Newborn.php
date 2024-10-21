<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Newborn extends Model
{
    use HasFactory;
    protected $table = 'newborns';
    protected $fillable = [
        'firstName', 'lastName', 'date_of_birth', 'gender', 'identity_number', 'weight', 'length',
        'status', 'delivery_method', 'location_id', 'health_center_id', 'hospital_center_id',  'measurement_id', 'ministry_center_id', 'doctor_id', 'nurse_id', 'midwife_id', 'newborn_hospital_nursery_id','mother_id','vaccination_table_id'
    ];

    public function vaccinationTable()
    {
        return $this->hasOne(VaccinationTabel::class, 'newborn_id');
    }
    public function mother()
    {
        return $this->belongsTo(Mother::class, 'mother_id', 'identity_number');
    }
//     public function newbornVaccines()
// {
//     return $this->hasMany(newbornVaccines::class, 'newborn_id');
// }


    public function location()
    {
        return $this->belongsTo(Location::class);
    }
    public function HealthCenter()
    {
        return $this->belongsTo(HealthCenter::class);
    }
    public function measurement()
    {
        return $this->hasOne(Measurements::class);
    }
    public function midwife()
    {
        return $this->belongsTo(Midwife::class);
    }
    public function ministry()
    {
        return $this->belongsTo(MinistryOfHealth::class);
    }



}

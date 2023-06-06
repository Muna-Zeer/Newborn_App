<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Children_Emergency extends Model
{
    use HasFactory;
    protected $table ='ChildrenEmergencies';
    protected $fillable = ['name','location','contact_number', 'risk', 'status','Referred','number_newborns','newborn_id',
        'doctor_id','midwife_id','nurse_id','newborn_bath_id',
     ];
     /**
     * Get the newborn associated with the emergency.
     */
    public function newborn()
    {
        return $this->belongsTo(Newborn::class);
    }

    /**
     * Get the doctor associated with the emergency.
     */
    public function doctor()
    {
        return $this->belongsTo(Doctor::class);
    }

    /**
     * Get the midwife associated with the emergency.
     */
    public function midwife()
    {
        return $this->belongsTo(Midwife::class);
    }

    /**
     * Get the nurse associated with the emergency.
     */
    public function nurse()
    {
        return $this->belongsTo(Nurse::class);
    }

    /**
     * Get the newborn bath associated with the emergency.
     */
    public function newbornBath()
    {
        return $this->belongsTo(NewbornBath::class);
    }
}

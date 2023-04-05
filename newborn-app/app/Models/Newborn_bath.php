<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Newborn_bath extends Model
{
    use HasFactory;
    protected $table ='NewbornBaths';
    protected $fillable = ['newborn_id','midwife_id','nurse_id','bath_date',
    ];

    /**
     * Get the newborn associated with the bath.
     */
    public function newborn()
    {
        return $this->belongsTo(Newborn::class);
    }

    /**
     * Get the midwife who gave the bath.
     */
    public function midwife()
    {
        return $this->belongsTo(Midwife::class);
    }

    /**
     * Get the nurse who assisted with the bath.
     */
    public function nurse()
    {
        return $this->belongsTo(Nurse::class);
    }
}

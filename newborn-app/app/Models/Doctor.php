<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Doctor extends Model
{
    use HasFactory;
    protected $table ='doctors';
    protected $fillable = ['name', 'salary','nurse_id','midwife_id', 'specialization_id', 'ministry_of_health_id',
    ];

    public function nurse()
    {
        return $this->belongsTo(Nurse::class);
    }

    public function midwife()
    {
        return $this->belongsTo(Midwife::class);
    }

    public function specialization()
    {
        return $this->belongsTo(Specialization::class);
    }

    public function ministryOfHealth()
    {
        return $this->belongsTo(MinistryOfHealth::class);
    }
}

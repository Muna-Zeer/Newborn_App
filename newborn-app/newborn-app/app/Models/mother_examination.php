<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class mother_examination extends Model
{
    use HasFactory;
    protected $table ='MotherExaminations';
    protected $fillable = ['name_of_mother','age','place_of_birth','time_of_delivery','date_of_delivery','weeks_of_pregnancy','method_of_delivery','Episiotomy', 'Perineal_Tear','Bleeding_after_delivery',
        'Blood_transfusion','Temp','B_P','Complication_after_delivery','Diagnosis','Referred', 'doctor_id', 'midwife_id','nurse_id',
    ];

    public function doctor()
    {
        return $this->belongsTo(Doctor::class);
    }

    public function midwife()
    {
        return $this->belongsTo(Midwife::class);
    }

    public function nurse()
    {
        return $this->belongsTo(Nurse::class);
    }
}

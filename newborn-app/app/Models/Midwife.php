<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Midwife extends Model
{
    use HasFactory;
    protected $table ='midwives';
    protected $fillable = ['name','hours','salary','communication_skills','period', 'mother_name','newborn_bracelet_hand',
        'newborn_bracelet_leg','report','doctor_id','newborn_id','mother_id','hospital_center_id',
    ];

    public function doctor()
    {
        return $this->belongsTo(Doctor::class);
    }

    public function newborn()
    {
        return $this->belongsTo(Newborn::class);
    }

    public function mother()
    {
        return $this->belongsTo(Mother::class);
    }

    public function hospital_center()
    {
        return $this->belongsTo(Hospital
        ::class);
    }
}

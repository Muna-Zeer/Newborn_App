<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Newborn_Assessment extends Model
{
    use HasFactory;
    protected $table ='NewbornAssessments';
    protected $fillable = ['Birth_Weight','date_of_delivery','mode_of_delivery','Gestational_age_at_delivery','Temp',
        'Pulse','Resp_rate','Weight','height', 'HC','Sex', 'Congenital_Malformation','Jaundice','Cyanosis', 'Umbilical_stump','Feeding','Remarks','doctor_id','midwife_id','nurse_id',
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

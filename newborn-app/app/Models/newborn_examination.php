<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class newborn_examination extends Model
{
    use HasFactory;
    protected $table ='NewbornExaminations';
    protected $fillable = [ 'Sex','Birth_outcome','H_C','Length','Weight_gr','Pulse', 'Temp','Respiratory_Rate','Apgar_score',
        'breastfeeding_ft','Congenital_Malformation','Medication','vaccine_id','Complication_after_birth','Diagnosis','Referred','doctor_id','midwife_id','nurse_id',
    ];

    
    public function vaccine()
    {
        return $this->belongsTo(VaccinationTabel::class);
    }

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

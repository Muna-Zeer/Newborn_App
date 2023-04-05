<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Nurse extends Model
{
    use HasFactory;
    protected $table ='nurses';
    protected $fillable = ['name','salary','health_center_id','hospital_center_id','specialization_id','ministry_of_health_id',
    ];

    public function healthCenter()
    {
        return $this->belongsTo('App\Models\HealthCenter');
    }

    public function hospitalCenter()
    {
        return $this->belongsTo('App\Models\Hospital');
    }

    public function specialization()
    {
        return $this->belongsTo('App\Models\Specialization');
    }

    public function ministryOfHealth()
    {
        return $this->belongsTo('App\Models\MinistryOfHealth');
    }
}

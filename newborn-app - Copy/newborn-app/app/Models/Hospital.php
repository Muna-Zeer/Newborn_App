<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Hospital extends Model
{
    use HasFactory;
    protected $table ='hospitals';
    protected $fillable = ['name','address','phone_number','email','registered_with_ministry','ministry_of_health_id'
    ];

    public function ministryOfHealth()
    {
        return $this->belongsTo(MinistryOfHealth::class);
    }

    public function appointments()
    {
        return $this->hasMany(Appointment::class);
    }
}

<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class VaccinationTabel extends Model
{
    use HasFactory;
    protected $table='VaccinationTables';
    
    protected $fillable = [
        'name','doses','place','diseases', 'method','month', 'month_vaccinations','newborn_id','ministry_id',
    ];

    public function newborn()
    {
        return $this->belongsTo(Newborn::class);
    }

    public function ministry()
    {
        return $this->belongsTo(Ministry::class);
    }
}

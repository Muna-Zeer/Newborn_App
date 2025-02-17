<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class VaccinationTable extends Model
{
    use HasFactory;
    protected $table='VaccinationTables';

    protected $fillable = [
        'name','doses','place','diseases', 'method','month', 'month_vaccinations','vaccination_date','newborn_id','ministry_id',
    ];

    public function newborn()
{
    return $this->belongsTo(Newborn::class, 'newborn_id');
}

    public function ministry()
    {
        return $this->belongsTo(MinistryOfHealth::class);
    }




}

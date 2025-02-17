<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class NewbornVaccine extends Model
{
    use HasFactory;
    protected $table = 'newborn_vaccines';

    protected $fillable = [
        'newborn_id',
        'vaccination_table_id',
        'doctor_name',
        'vaccination_date',
        'taken',
        'identity_number',
        'notified',
        'overdue_days',
        'due_date',
        'vaccineName'
    ];

    public function newborn()
    {
        return $this->belongsTo(Newborn::class);
    }
    public function vaccinationTable()
    {
        return $this->belongsTo(VaccinationTable::class, 'vaccination_table_id');
    }


}


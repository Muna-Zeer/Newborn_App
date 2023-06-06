<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Feeding extends Model
{
    use HasFactory;
    protected $table ='feedings';
    protected $fillable = ['feeding_type','quantity','date', 'time','newborn_id','month', 'instructions','ministry_id'
    ];

    public function newborn()
    {
        return $this->belongsTo(Newborn::class);
    }
}

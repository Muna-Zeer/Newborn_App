<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class MinistryOfHealth extends Model
{
    use HasFactory;
    protected $table = 'ministryofhealths';

    protected $fillable = ['name','address','phone_number', 'email',];
}

<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class adminPrevExam extends Model
{
    use HasFactory;
    protected $table="admin_prev_examination";
    protected $fillable=[ 'exam_type',
    'description',];
}

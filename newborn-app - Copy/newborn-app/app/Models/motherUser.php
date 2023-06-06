<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Notifications\Notifiable;

class motherUser extends Model
{
    use HasFactory, Notifiable;
    protected $table='mother_users';
    protected $fillable=['password','phone','username','identity_number'];
    public function role()
    {
        return $this->belongsTo(Role::class);
    }
}

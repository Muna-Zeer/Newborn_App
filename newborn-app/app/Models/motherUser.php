<?php

namespace App\Models;

use Laravel\Sanctum\HasApiTokens;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Notifications\Notifiable;

class MotherUser extends Model
{
    use HasApiTokens, HasFactory, Notifiable;

    protected $table = 'mother_users';
    protected $fillable = ['password', 'phone', 'username', 'identity_number','device_token'];

    public function role()
    {
        return $this->belongsTo(Role::class);
    }
    public function mother()
    {
        return $this->belongsTo(Mother::class, 'identity_number', 'identity_number');
    }
}

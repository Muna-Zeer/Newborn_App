<?php

namespace Database\Seeders;

use App\Models\MinistryOfHealth;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class centerSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        //
        MinistryOfHealth::create([
            'name'=>'Palestinian Ministry of Health',
            'address'=>'Ramallah Palestine ',
            'phone_number'=>'+972 2-2345678',
            'email'=>'ministry@moh.gov.ps',
        ]);
    }
}

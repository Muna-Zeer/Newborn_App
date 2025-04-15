<?php

namespace Database\Seeders;

use App\Models\Hospital;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
 use \App\Models\MinistryOfHealth;
class hospitalsSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        //
        $ministry = MinistryOfHealth::first();
        Hospital::create([
            'name'=>'Al-Makassed Hospital',
            'address'=>'Jerusalem Palestine',
            'phone_number'=>'1234567890',
            'email'=>'makassed@gmail.gov',
            'registered_with_ministry' => true,
            'ministry_of_health_id' => $ministry ? $ministry->id : null,
        ]);
        Hospital::create([
            'name' => 'Palestine Medical Complex',
            'address' => 'Ramallah, Palestine',
            'phone_number' => '+970-2-2981234',
            'email' => 'info@pmc.ps',
            'registered_with_ministry' => true,
            'ministry_of_health_id' => $ministry ? $ministry->id : null,
        ]);
    }
}

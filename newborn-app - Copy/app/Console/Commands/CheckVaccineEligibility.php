<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;

class CheckVaccineEligibility extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'vaccine:check-eligibility';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description ='Check eligibility of newborns for vaccines';

    /**
     * Execute the console command.
     */
    public function handle(): void
    {
        //
    }
}

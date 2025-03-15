<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\NewbornVaccine;
use Carbon\Carbon;
use Illuminate\Support\Facades\Notification;
use App\Notifications\VaccineReminder;

class NotifyUpcomingVaccines extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'app:notify-upcoming-vaccines';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Send notifications about upcoming due dates of the vaccine';

    /**
     * Execute the console command.
     */
    public function handle()
    {
        $upcomingVaccines=NewbornVaccine::whereDate('due_date',Carbon::now()->addDays(2))->get();
        foreach($upcomingVaccines as $vaccine){
            Notification::send($vaccine->doctor, new VaccineReminder($vaccine));
        }
        $this->info('Notification sent successfully');

        //
    }
}

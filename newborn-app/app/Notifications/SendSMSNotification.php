<?php

namespace App\Notifications;

use Illuminate\Bus\Queueable;
use Illuminate\Notifications\Notification;
use Illuminate\Notifications\Messages\MailMessage;
use Illuminate\Support\Facades\Http;

class SendSMSNotification extends Notification
{
    use Queueable;

    protected $notifiable;

    /**
     * Create a new notification instance.
     */
    public function __construct($notifiable)
    {
        $this->notifiable = $notifiable;
    }

    /**
     * Get the notification's delivery channels.
     *
     * @return array<int, string>
     */
    public function via($notifiable)
    {
        return ['sms'];
    }

    /**
     * Send the SMS notification.
     *
     * @return void
     */
    public function toSms($notifiable)
    {
        $message = 'Please take the ' . $this->notifiable->vaccineName . ' vaccine for your newborn. Name: ' . $this->notifiable->firstName . ' ' . $this->notifiable->lastName;

        $response = Http::post('https://api.twilio.com/2010-04-01/Accounts/{YOUR_TWILIO_ACCOUNT_SID}/Messages.json', [
            'From' => '{YOUR_TWILIO_PHONE_NUMBER}',
            'To' => $this->notifiable->phone,
            'Body' => $message,
        ])->throw();

        return $response;
    }
}

<?php

namespace App\Notifications;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Messages\MailMessage;
use Illuminate\Notifications\Notification;

class VaccineReminder extends Notification
{
    use Queueable;

    protected $vaccine;
    /**
     * Create a new notification instance.
     */
    public function __construct($vaccine)
    {
        $this->vaccine = $vaccine;
        //
    }

    /**
     * Get the notification's delivery channels.
     *
     * @return array<int, string>
     */
    public function via(object $notifiable): array
    {
        return ['mail'];
    }

    /**
     * Get the mail representation of the notification.
     */
    public function toMail(object $notifiable): MailMessage
    {
        return (new MailMessage)
            ->subject('تنبيه: موعد تطعيم قادم')
            ->line("تطعيم: {$this->vaccine->vaccine_name}")
            ->line("تاريخ الاستحقاق: {$this->vaccine->due_date}")
            ->line('يرجى التأكد من تسجيل التطعيم.');
            // ->action('عرض التفاصيل', url('/dashboard'));
    }

    /**
     * Get the array representation of the notification.
     *
     * @return array<string, mixed>
     */
    public function toArray(object $notifiable): array
    {
        return [
            //
        ];
    }
}

<?php

namespace App\Notifications;

use Illuminate\Notifications\Notification;
use Illuminate\Notifications\Messages\MailMessage;

class SendNewPasswordNotification extends Notification
{
    protected $newPassword;

    public function __construct($newPassword)
    {
        $this->newPassword = $newPassword;
    }

    public function via($notifiable)
    {
        return ['mail'];
    }

    public function toMail($notifiable)
    {
        return (new MailMessage)
            ->subject('Your New Password')
            ->greeting('Hello ' . $notifiable->name . ',')
            ->line('You requested a password reset.')
            ->line('Your new password is:')
            ->line('**' . $this->newPassword . '**')
            ->line('You can log in and change this password anytime from your profile settings.')
            ->line('If you didn\'t request this, please secure your account.');
    }
}

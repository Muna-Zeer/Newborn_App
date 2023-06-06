<?php

namespace App\Helpers;

use Kreait\Firebase\Factory;
use Kreait\Firebase\Messaging\CloudMessage;
use Kreait\Firebase\Messaging\Notification;

use App\Models\MotherUser;

class FirebaseHelper
{
    public static function sendNotification($userId, $title, $body, $data = [])
    {
        // Retrieve the device token for the user
        $user = MotherUser::find($userId);
        $deviceToken = $user->device_token;

        $factory = (new Factory)->withServiceAccount(config('services.firebase.credentials.file'));

        $messaging = $factory->createMessaging();

        // Create the notification
        $notification = Notification::create($title, $body);

        $message = CloudMessage::withTarget('token', $deviceToken)
            ->withNotification($notification)
            ->withData($data);

        try {
            $messaging->send($message);
        } catch (\Exception $e) {
            // Handle the exception, e.g., log the error or return an error response
            return response()->json([
                'status' => 'error',
                'message' => 'Failed to send notification.',
                'error' => $e->getMessage(),
            ]);
        }

        return response()->json([
            'status' => 'success',
            'message' => 'Notification sent successfully.',
        ]);
    }

}

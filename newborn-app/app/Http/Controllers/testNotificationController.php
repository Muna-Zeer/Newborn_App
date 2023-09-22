<?php

namespace App\Http\Controllers;

use Exception;
use Twilio\Rest\Client;



class testNotificationController extends Controller
{


    // Find your Account SID and Auth Token at twilio.com/console
    // and set the environment variables. See http://twil.io/secure
    public function sendsms()
    {
        $accountSId = config("services.twilio.account_sid");
        $token = config("services.twilio.auth_token");
        $sendernumber = config("services.twilio.phone_number");
        // dd($accountSId) ;

        $twilio = new Client($accountSId, $token);

        try {
            $twilio->messages->create(
                "+970 569 132 721", // to
                array(
                    "from" => $sendernumber,
                    "body" => "This is the ship that made the Kessel Run in fourteen parsecs?",
                )
            );

            dd("message send successful");
        } catch (Exception $e) {
            dd($e->getMessage());
        }

        dd("message send successful");
    }
}

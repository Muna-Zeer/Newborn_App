<?php

return [

    /*
    |--------------------------------------------------------------------------
    | Third Party Services
    |--------------------------------------------------------------------------
    |
    | This file is for storing the credentials for third party services such
    | as Mailgun, Postmark, AWS and more. This file provides the de facto
    | location for this type of information, allowing packages to have
    | a conventional file to locate the various service credentials.
    |
    */

    'mailgun' => [
        'domain' => env('MAILGUN_DOMAIN'),
        'secret' => env('MAILGUN_SECRET'),
        'endpoint' => env('MAILGUN_ENDPOINT', 'api.mailgun.net'),
        'scheme' => 'https',
    ],

    'postmark' => [
        'token' => env('POSTMARK_TOKEN'),
    ],

    'ses' => [
        'key' => env('AWS_ACCESS_KEY_ID'),
        'secret' => env('AWS_SECRET_ACCESS_KEY'),
        'region' => env('AWS_DEFAULT_REGION', 'us-east-1'),
    ],
    'firebase' => [
        'credentials' => [
            'apiKey' => 'AIzaSyC_JMG6koOiDVUrymKq2ArG8ICbd1ojSzA',
            'authDomain' => 'myvaccine-90458.firebaseapp.com',
            'projectId' => 'myvaccine-90458',
            'storageBucket' => 'myvaccine-90458.appspot.com',
            'messagingSenderId' => '239023568069',
            'appId' => '1:239023568069:web:769167c089a5b6750f6cac',
            'measurementId' => 'G-K0BV2M91GB',
        ],
        'database_url' => '',
    ],

];

<?php

return [
    'credentials' => [
        'file' => env('FIREBASE_JSON_KEY', ''), // Path to your Firebase credentials JSON file
        'auto_discovery' => env('FIREBASE_AUTO_DISCOVERY', true),
    ],
    'database' => [
        'url' => env('FIREBASE_DATABASE_URL', ''), // Firebase Realtime Database URL
    ],
    'http' => [
        'client' => env('FIREBASE_CLIENT', 'guzzle'), // HTTP client to use (guzzle, curl, etc.)
        // Add any additional HTTP client configuration options here
    ],
    'dynamic_links' => [
        'default_domain' => env('FIREBASE_DYNAMIC_LINKS_DOMAIN', ''), // Your Firebase Dynamic Links domain
    ],
    // Add any other Firebase configuration options here
];

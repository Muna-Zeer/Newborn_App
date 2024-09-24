<?php

use App\Http\Controllers\testNotificationController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "web" middleware group. Make something great!
|
*/
Route::get('/', function () {
    // dd('cc');
    return view('welcome');
});

// Auth::routes();

Route::get('/home', [App\Http\Controllers\HomeController::class, 'index'])->name('home');

// Auth::routes();
Route::get('/test-twilio', function () {
    $message = 'This is a test message from Twilio.';
    $to = '+13614902816'; // Replace with the phone number you want to send the test message to

    $twilio = new Twilio\Rest\Client(
        config('services.twilio.account_sid'),
        config('services.twilio.auth_token')
    );

    try {
        $twilio->messages->create($to, ['from' => config('services.twilio.phone_number'), 'body' => $message]);
        return 'Test message sent successfully.';
    } catch (Exception $e) {
        return 'Error sending test message: ' . $e->getMessage();
    }
});

Route::get('/sendsms', [testNotificationController::class, 'sendsms']);


// Route::get('/compare-newborn-age', [NewbornVaccineController::class, 'compareNewbornAgeWithVaccineMonth']);

<?php

namespace App\Http\Controllers;

use App\Models\Newborn;
use App\Models\newborn_vaccine;
use App\Models\VaccinationTabel;
use DateTime;
use Illuminate\Http\Request;
use Kreait\Firebase\Messaging\CloudMessage;
use Kreait\Firebase\Messaging\Notification;

class NewbornVaccineController extends Controller
{
    //
    public function NewbornVaccine(Request $request)
    {
        $request->validate([
            'identity_number' => 'required',
            'vaccination_table_id' => 'required',
            'doctor_name' => 'required',
            'vaccination_date' => 'required',
            'taken' => 'required',
        ]);

        $newborn = Newborn::where('identity_number', $request->input('identity_number'))->firstOrFail();
        $vaccinationTable = VaccinationTabel::findOrFail($request->input('vaccination_table_id'));

        $newbornVaccine = Newborn_Vaccine::create([
            'newborn_id' => $newborn->id, // Assign newborn_id from the Newborn model
            'vaccination_table_id' => $vaccinationTable->id,
            'doctor_name' => $request->input('doctor_name'),
            'vaccination_date' => $request->input('vaccination_date'),
            'taken' => $request->input('taken'),
        ]);

        return response()->json([
            'status' => 'success',
            'message' => 'Newborn vaccine record inserted successfully',
            'data' => $newbornVaccine,
        ], 201);
    }




    public function compareNewbornAgeWithVaccineMonth(Request $request)
    {
        $birthdate = $request->input('date_of_birth');

        $birthDateTime = new DateTime($birthdate);

        $currentDateTime = new DateTime();
        $ageInterval = $birthDateTime->diff($currentDateTime);
        $ageInMonths = $ageInterval->y * 12 + $ageInterval->m;
        $ageInDays = $ageInterval->days;

        $remainingDays = $ageInDays % 30;

        $newborns = Newborn::all();

        if ($newborns->isEmpty()) {
            return response()->json([
                'status' => 'error',
                'message' => 'No newborns found.',
            ]);
        }

        $vaccines = VaccinationTabel::all();

        if ($vaccines->isEmpty()) {
            return response()->json([
                'status' => 'error',
                'message' => 'No vaccines found.',
            ]);
        }


        $matchingNewborns = [];
        $nonMatchingNewborns = [];

        foreach ($newborns as $newborn) {
            $newbornBirthDateTime = new DateTime($newborn->date_of_birth);

            $newbornAgeInterval = $newbornBirthDateTime->diff($currentDateTime);
            $newbornAgeInMonths = $newbornAgeInterval->y * 12 + $newbornAgeInterval->m;
            $newbornAgeInDays = $newbornAgeInterval->days;

            $newbornRemainingDays = $newbornAgeInDays % 30;

            foreach ($vaccines as $vaccine) {
                $vaccineDays = intval($vaccine->month_vaccinations) * 30;
                // echo (' days:' . $vaccineDays);
                if ($newbornAgeInDays == $vaccineDays) {
                    $matchingNewborns[] = [
                        'firstName' => $newborn->firstName,
                        'lastName' => $newborn->lastName,
                        'identity_number' => $newborn->identity_number,
                        'date_of_birth' => $newborn->date_of_birth,
                        'ageInMonths' => $newbornAgeInMonths,
                        'gender' => $newborn->gender,
                        'ageInDays' => $newbornAgeInDays,
                        'remainingDays' => $newbornRemainingDays,
                        'vaccineName' => $vaccine->name, // Modify the field name to match the actual field containing the vaccine name
                        'vaccineDays' => $vaccineDays,
                    ];
                } else {
                    $nonMatchingNewborns[] = [
                        'firstName' => $newborn->firstName,
                        'lastName' => $newborn->lastName,
                        'ageInMonths' => $newbornAgeInMonths,
                        'ageInDays' => $newbornAgeInDays,
                        'remainingDays' => $newbornRemainingDays,
                        'vaccineName' => $vaccine->name,
                        'vaccineDays' => $vaccineDays,
                        'date_of_birth' => $newborn->date_of_birth,
                    ];
                }
            }
        }
        return response()->json([
            'status' => 'success',
            'message' => 'Newborns age and vaccines retrieved successfully.',
            'matchingNewborns' => $matchingNewborns,
            'nonMatchingNewborns' => $nonMatchingNewborns,

        ]);
    }
}
$firebase = app('firebase')->messaging();
$token = 'MOTHER_DEVICE_TOKEN'; // Replace with the actual device token

foreach ($matchingNewborns as $newborn) {
    $notification = Notification::create('Vaccine Reminder')
        ->body('Please take ' . $newborn['vaccineName'] . ' vaccine for your newborn.');

    $message = CloudMessage::withTarget('token', $token)
        ->withNotification($notification)
        ->withData(['vaccineName' => $newborn['vaccineName']]);

    try {
        $firebase->send($message);
    } catch (\Exception $e) {
        // Handle the exception, e.g., log the error or return an error response
        return response()->json([
            'status' => 'error',
            'message' => 'Failed to send notification.',
            'error' => $e->getMessage(),
        ]);
    }

}

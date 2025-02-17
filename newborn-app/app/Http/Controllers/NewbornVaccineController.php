<?php

namespace App\Http\Controllers;

use App\Helpers\FirebaseHelper;
use App\Models\motherUser;
use App\Models\Newborn;
use App\Models\newborn_vaccine;
use App\Models\NewbornVaccine;
use App\Models\VaccinationTabel;
use App\Models\VaccinationTable;
use DateTime;
use Illuminate\Http\Request;
use Kreait\Firebase\Messaging\CloudMessage;
use Kreait\Firebase\Messaging\Notification;
use Illuminate\Notifications\Messages\TwilioMessage;
use App\Notifications\SendSMSNotification;
use Twilio\Rest\Client;

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
        $vaccinationTable = VaccinationTable::findOrFail($request->input('vaccination_table_id'));

        $newborn->vaccines()->create([
            'newborn_id' => $newborn->id,
            'identity_number' => $request->input('identity_number'),
            'vaccination_table_id' => $vaccinationTable->id,
            'doctor_name' => $request->input('doctor_name'),
            'vaccination_date' => $request->input('vaccination_date'),
            'vaccineName' => $request->input('vaccineName'),
            'taken' => $request->input('taken'),
        ]);

        return response()->json(['status' => 'success', 'message' => 'Vaccine record added successfully']);
    }




    public function getVaccinesOfNewborn($identity_number)
    {
        $newborn = Newborn::where('identity_number', $identity_number)->firstOrFail();

        $vaccines = NewbornVaccine::where('newborn_id', $newborn->id)
            ->where('taken', true)
            ->with('vaccinationTable')
            ->get()->map(function ($vaccine) use ($newborn) {
                return [
                    'identity_number' => $newborn->identity_number,
                    'due_date' => $vaccine->due_date,
                    'vaccineName' => $vaccine->vaccineName,
                    'overdue_days' => $vaccine->overdue_days ?? 0,
                    'notified' => (bool) ($vaccine->notified ?? false),
                    'taken' => (bool) ($vaccine->taken ?? false),
                    'vaccination_date' => $vaccine->vaccination_date,
                    'doctor_name' => $vaccine->doctor_name ?? 'Unknown',
                ];
            });


        return response()->json([
            'status' => 'success',
            'vaccines' => $vaccines
        ]);
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

        $vaccines = VaccinationTable::all();

        if ($vaccines->isEmpty()) {
            return response()->json([
                'status' => 'error',
                'message' => 'No vaccines found.',
            ]);
        }

        $matchingNewborns = [];
        $nonMatchingNewborns = [];
        $beforeOneDayNewborns = [];
        $twilioSid = 'ACaa9721c4fc90937ae7af626ce4ed1739';
        $twilioAuthToken = 'bca5059529756fa54b2612dd59686dbe';
        $twilioPhoneNumber = '+13614902816';
        $client = new Client($twilioSid, $twilioAuthToken);

        foreach ($newborns as $newborn) {
            $newbornBirthDateTime = new DateTime($newborn->date_of_birth);
            $newbornAgeInterval = $newbornBirthDateTime->diff($currentDateTime);
            $newbornAgeInMonths = $newbornAgeInterval->y * 12 + $newbornAgeInterval->m;
            $newbornAgeInDays = $newbornAgeInterval->days;
            $motherUser = $newborn->mother->phone_number;
            $newbornRemainingDays = $newbornAgeInDays % 30;

            foreach ($vaccines as $vaccine) {
                $vaccineDays = intval($vaccine->month_vaccinations) * 30;

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
                        'vaccineName' => $vaccine->name,
                        'vaccineDays' => $vaccineDays,
                        'vaccineName' => $vaccine->name,
                        'vaccineDays' => $vaccineDays,
                        'motherName' => $newborn->mother->first_name, // Add mother's name
                        'motherPhoneNumber' => $newborn->mother->phone_number, // Add mother's phone number
                    ];

                    // Retrieve the mother associated with the newborn
                    $mother = $newborn->mother;
                    if ($mother) {
                        $motherUser = $mother->motherUser;
                        if ($motherUser) {
                        }
                    }
                    // print($motherphoneMathcing);
                } elseif ($newbornAgeInDays == $vaccineDays - 1) {
                    $beforeOneDayNewborns[] = [
                        'firstName' => $newborn->firstName,
                        'lastName' => $newborn->lastName,
                        'ageInMonths' => $newbornAgeInMonths,
                        'ageInDays' => $newbornAgeInDays,
                        'remainingDays' => $newbornRemainingDays,
                        'vaccineName' => $vaccine->name,
                        'vaccineDays' => $vaccineDays,
                        'date_of_birth' => $newborn->date_of_birth,
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
            'newbornagebeforeVaccine' => $beforeOneDayNewborns,

        ]);
    }
}

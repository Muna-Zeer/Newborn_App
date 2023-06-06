<?php

namespace App\Http\Controllers;

use App\Models\Doctor;
use App\Models\Hospital;
use App\Models\Midwife;
use App\Models\MinistryOfHealth;
use App\Models\Mother;
use App\Models\Newborn;
use App\Models\Nurse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class NewbornController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $newborns = Newborn::get();

        return response()->json([
            'status' => 'success',
            'message' => 'All newborns records retrieved successfully',
            'data' => $newborns,
        ]);
    }


    public function fetchNewbornsWithDetails()
{
    $newborns = Newborn::with('mother')->get();

    $dataRows = [];
    foreach ($newborns as $newborn) {
        $dataRows[] = [
            'id' => $newborn->id,
            'firstName' => $newborn->firstName,
            'lastName' => $newborn->lastName,
            'identityNumber' => $newborn->identityNumber,
            'motherName' => $newborn->mother->name,  // Assuming the mother model has a `name` attribute
            // 'midwifeName' => $newborn->midwife->name,  // Assuming the doctor model has a `name` attribute
            'dateOfBirth' => $newborn->dateOfBirth,
            'deliveryMethod' => $newborn->deliveryMethod,
        ];
    }

    return response()->json([

        'data'=>$dataRows
    ]);
}

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        // Validate the request data
        $validator = Validator::make($request->all(), [
            'firstName' => 'required|string',
            'lastName' => 'required|string',
            'date_of_birth' => 'required|date',
            'gender' => 'required|in:Male,Female',
            'identity_number' => 'required|string|exists:mothers,identity_number',
            'weight' => 'required|numeric',
            'length' => 'required|numeric',
            'status' => 'required|in:Normal,Abnormal',
            'delivery_method' => 'required|in:Normal,Vaccum,Forceps,C_S',
            'mother_id' => 'nullable|exists:mothers,id', // Update the column name to 'id'
            'location_id' => 'nullable|exists:locations,id',
            'health_center_id' => 'nullable|exists:health_centers,id',
            'hospital_center_id' => 'nullable|exists:hospitals,id',
            'measurement_id' => 'nullable|exists:measurements,id',
            'ministry_center_id' => 'nullable|exists:ministry_centers,id',
            'doctor_id' => 'nullable|exists:doctors,id',
            'nurse_id' => 'nullable|exists:nurses,id',
            'midwife_id' => 'nullable|exists:midwives,id',
            'newborn_hospital_nursery_id' => 'nullable|exists:newborn_hospital_nurseries,id',
        ]);

        // If validation fails, return error response
        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 400);
        }

        // Find the mother instance by identity number
        $mother = Mother::where('identity_number', $request->input('identity_number'))->first();

        // Create a new newborn instance with the validated data
        $newborn = new Newborn();
        $newborn->firstName = $request->input('firstName');
        $newborn->lastName = $request->input('lastName');
        $newborn->date_of_birth = $request->input('date_of_birth');
        $newborn->gender = $request->input('gender');
        $newborn->identity_number = $request->input('identity_number');
        $newborn->weight = $request->input('weight');
        $newborn->length = $request->input('length');
        $newborn->status = $request->input('status');
        $newborn->delivery_method = $request->input('delivery_method');
        $newborn->mother_id = $mother ? $mother->id : null;
        $newborn->health_center_id = $request->input('health_center_id');
        $newborn->measurement_id = $request->input('measurement_id');
        $newborn->nurse_id = $request->input('nurse_id');
        $newborn->newborn_hospital_nursery_id = $request->input('newborn_hospital_nursery_id');

        $newborn->vaccination_table_id = 1;
        $newborn->newborn_hospital_nursery_id = $request->input('newborn_hospital_nursery_id');
        $motherName = $request->input('mother_id');
        if ($motherName ) {
            $mother = Mother::where('identity_number', $motherName )->first();
            if (!$mother) {

                $mother = new Mother();
                $mother->identity_number = $motherName ;
                $mother->save();
            }
            $mother->mother_id = $mother->identity_number;
        }
        $ministryName = $request->input('ministry_id');
        if ($ministryName) {
            $ministry = MinistryOfHealth::where('name', $ministryName)->first();
            if (!$ministry) {
                $ministry = new MinistryOfHealth();
                $ministry->name = $ministryName;
                $ministry->save();
            }
            $mother->ministry_center_id = $ministry->id;
        }
        //get hospital Name
        $hospitalName = $request->input('hospital_id');
        if ($hospitalName) {
            $hospital = Hospital::where('name', $hospitalName)->first();
            if (!$hospital) {
                // return response()->json(['errors' => 'Invalid hospital Name'], 422);
                $hospital = new Hospital();
                $hospital->name = $hospitalName;
                $hospital->save();
            }
            $mother->hospital_center_id = $hospital->id;
        }

        //get nurse Name
        $midwifeName = $request->input('midwife_id');
        if ($midwifeName) {
            $nurse = Midwife::where('name', $midwifeName)->first();
            if (!$nurse) {
                $nurse = new Midwife();
                $nurse->name = $midwifeName;
                $nurse->save();
                // return response()->json(['errors' => 'Invalid nurse Name'], 422);
            }
            $mother->midwife_id = $nurse->id;
        }
        //get doctor Name
        $doctorName = $request->input('doctor_id');
        if ($doctorName) {
            $doctor = Doctor::where('name', $doctorName)->first();
            if (!$doctor) {
                // Doctor doesn't exist, so create a new record
                $doctor = new Doctor();
                $doctor->name = $doctorName;
                $doctor->save();
            }
            $mother->doctor_id = $doctor->id;
        }

        // Return success response with the created newborn instance
        return response()->json(['newborn' => $newborn], 201);
    }



    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $newborn = newborn::find($id);

        if (!$newborn) {
            return response()->json([
                'status' => 'error',
                'message' => 'newborn id not found',
            ], 404);
        } else {

            return response()->json([
                'status' => 'success',
                'message' => 'newborn id retrieved successfully',
                'data' => $newborn,
            ]);
        }
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
        // Retrieve the newborn record by ID
        $newborn = newborn::find($id);

        // Check if the record exists
        if (!$newborn) {
            // If the newborn record doesn't exist, return an error message
            return response()->json([
                'status' => 'error',
                'message' => 'newborn id record not found',
            ], 404);
        }

        // If the record exists, return the record data in JSON format with a success message
        return response()->json([
            'status' => 'success',
            'message' => 'newborn id record found',
            'data' => $newborn,
        ]);
    }

    /**
     * Update the specified resource in storage.
     */


    public function update(Request $request, $id)
    {
        $validator = Validator::make($request->all(), [
            'firstName' => 'nullable|string|max:255',
            'lastName' => 'nullable|string|max:255',
            'date_of_birth' => 'nullable|date',
            'gender' => 'nullable|in:Male,Female',
            'identity_number' => 'nullable|string|max:255',
            'weight' => 'nullable|numeric',
            'length' => 'nullable|numeric',
            'status' => 'nullable|in:Normal,Abnormal',
            'delivery_method' => 'nullable|string|max:255',
            'mother_id' => 'nullable|exists:mothers,id',
            'location_id' => 'nullable|exists:locations,id',
            'health_center_id' => 'nullable|exists:health_centers,id',
            'hospital_center_id' => 'nullable|exists:hospitals,id',
            'measurement_id' => 'nullable|exists:measurements,id',
            'ministry_center_id' => 'nullable|exists:ministry_centers,id',
            'doctor_id' => 'nullable|exists:doctors,id',
            'nurse_id' => 'nullable|exists:nurses,id',
            'midwife_id' => 'nullable|exists:midwives,id',
            'newborn_hospital_nursery_id' => 'nullable|exists:newborn_hospital_nurseries,id',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 400);
        }

        $newborn = Newborn::find($id);
        if (!$newborn) {
            return response()->json(['message' => 'Newborn not found'], 404);
        }

        $newborn->fill($request->all());
        $newborn->save();

        return response()->json(['message' => 'Newborn updated successfully'], 200);
    }


    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        // Retrieve the newborns table record with the given ID
        $newborn = Newborn::find($id);

        // Check if the newborns table record exists
        if (!$newborn) {
            return response()->json([
                'status' => 'error',
                'message' => 'newborn record record not found',
            ], 404);
        }

        // Delete the newborn record record
        $newborn->delete();

        // Return a success message
        return response()->json([
            'status' => 'success',
            'message' => 'newborn record record deleted successfully',
        ]);
    }
}

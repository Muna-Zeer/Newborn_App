<?php

namespace App\Http\Controllers;

use App\Models\Doctor;
use App\Models\Hospital;
use App\Models\MinistryOfHealth;
use App\Models\Nurse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class NurseController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        //
        $nurse = Nurse::all();

        return response()->json([
            'status' => 'success',
            'message' => 'all nurses record  retrieved successfully',
            'data' => $nurse,
        ]);
    }

    public function nurseTable()
    {
        $midwife = DB
            ::table('nurses')
            ->select('id', 'name', 'salary', 'specialization')
            ->get();

        return response()->json([
            'data' => $midwife,
        ]);
    }

    public function fetchDoctors()
    {
        $doctor = Doctor::all(['id', 'name'])->toArray();
        return response()->json($doctor);
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
        $validator = Validator::make($request->all(), [
            'name' => 'required|string',
            'salary' => 'required|integer',
            'hospital_id' => 'nullable|exists:hospitals,id',
            'specialization' => 'nullable|string',
            'ministry_of_health_id' => 'nullable|exists:ministryofhealths,id',
            'schedule' => 'required|array',
            'doctor_id' => 'nullable|exists:doctors,id',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $schedule = collect($request->input('schedule'))->keyBy('day')->map(function ($value) {
            return [
                'startTime' => $value['start'],
                'endTime' => $value['end'],
            ];
        })->toArray();


        $nurse =  new Nurse();
        $nurse = new Nurse();
        $nurse->name = $request->input('name');
        $nurse->salary = $request->input('salary');
        $nurse->specialization = $request->input('specialization');
        $nurse->hospital_id = $request->input('hospital_id');
        $nurse->ministry_of_health_id = $request->input('ministry_of_health_id');
        $nurse->doctor_id = $request->input('doctor_id');
        $nurse->schedule = json_encode($schedule);



        // Set the related entities
        $ministryOfHealthName = $request->input('ministryOfHealthName');
        if ($ministryOfHealthName) {
            $ministryOfHealth = MinistryOfHealth::where('name', $ministryOfHealthName)->first();
            if (!$ministryOfHealth) {
                $ministryOfHealth = new MinistryOfHealth();
                $ministryOfHealth->name = $ministryOfHealthName;
                $ministryOfHealth->save();
            }
            $nurse->ministry_of_health_id = $ministryOfHealth->id;
        }

        $hospitalName = $request->input('hospitalName');
        if ($hospitalName) {
            $hospital = Hospital::where('name', $hospitalName)->first();
            if (!$hospital) {
                $hospital = new Hospital();
                $hospital->name = $hospitalName;
                $hospital->save();
            }
            $nurse->hospital_id = $hospital->id;
        }
        $doctorName = $request->input('doctorName');
        if ($doctorName) {
            $doctor = Doctor::where('name', $doctorName)->first();
            if (!$doctor) {
                $doctor = new Doctor();
                $doctor->name = $doctorName;
                $doctor->save();
            }
            $nurse->doctor_id = $doctor->id;
        }

        return response()->json(['message' => 'Nurse record created successfully', 'nurse' => $nurse], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $nurse = nurse::find($id);

        if (!$nurse) {
            return response()->json([
                'status' => 'error',
                'message' => 'nurse id not found',
            ], 404);
        } else {

            return response()->json([
                'status' => 'success',
                'message' => 'nurse id retrieved successfully',
                'data' => $nurse,
            ]);
        }
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
        // Retrieve the nurse record by ID
        $nurse = nurse::find($id);

        // Check if the record exists
        if (!$nurse) {
            // If the nurse record doesn't exist, return an error message
            return response()->json([
                'status' => 'error',
                'message' => 'nurse id record not found',
            ], 404);
        }

        // If the record exists, return the record data in JSON format with a success message
        return response()->json([
            'status' => 'success',
            'message' => 'nurse id record found',
            'data' => $nurse,
        ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        // Retrieve the nurse record by ID
        $nurse = Nurse::find($id);

        // Check if the record exists
        if (!$nurse) {
            return response()->json([
                'status' => 'error',
                'message' => 'Nurse record not found',
            ], 404);
        }

        // Validate the request data
        $validator = Validator::make($request->all(), [
            'name' => 'nullable|string',
            'salary' => 'nullable|integer',
            'health_center_id' => 'nullable|integer|exists:health_centers,id',
            'hospital_id' => 'nullable|integer|exists:hospitals,id',
            'specialization' => 'nullable|string',
            'ministry_of_health_id' => 'nullable|integer|exists:ministryofhealths,id',
        ]);

        // Check if the validation fails
        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => 'Validation error',
                'errors' => $validator->errors(),
                'data' => [],
            ], 400);
        }

        $data = $request->all();

        // Update the nurse record with the new data
        $nurse->update($data);

        // Load the related models

        return response()->json([
            'status' => 'success',
            'message' => 'Nurse record updated successfully',
            'data' => $nurse,
        ]);
    }


    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        //
        // Retrieve the nurse record with the given ID
        $nurse = Nurse::find($id);

        // Check if the nurse record exists
        if (!$nurse) {
            return response()->json([
                'status' => 'error',
                'message' => 'nurse record not found',
            ], 404);
        }

        // Delete the nurse record
        $nurse->delete();

        // Return a success message
        return response()->json([
            'status' => 'success',
            'message' => 'nurse record deleted successfully',
        ]);
    }
}

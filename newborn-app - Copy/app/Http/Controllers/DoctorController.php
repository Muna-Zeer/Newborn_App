<?php

namespace App\Http\Controllers;

use App\Models\Doctor;
use App\Models\Hospital;
use App\Models\Midwife;
use App\Models\MinistryOfHealth;
use App\Models\Nurse;
use App\Models\Specialization;
use App\Models\VaccinationTabel;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rule;

class DoctorController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $doctors = DB
            ::table('doctors')
            ->select('id', 'name', 'specialization', 'country', 'city', 'email', 'phone', 'salary')
            ->get();

        return response()->json([
            'data' => $doctors,
        ]);
    }

    public function allDoctors($id)
    {
        $doctor = Doctor::find($id);

        if ($doctor === null) { // Check if $doctor is null
            return response()->json(['message' => 'Doctor not found'], 404);
        }

        return response()->json(['status' => 'success', 'message' => 'Doctor retrieved successfully', 'data' => $doctor]);
    }

    public function fetchDoctors()
    {
        $doctors = Doctor::all();

        return response()->json(['status' => 'success', 'message' => 'Doctors retrieved successfully', 'data' => $doctors]);
    }

    public function fetchHospitals()
    {
        $hospitals = Hospital::all(['id', 'name'])->toArray();
        return response()->json($hospitals);
    }
    public function fetchVaccines()
    {
        $hospitals = VaccinationTabel::all(['id', 'name'])->toArray();
        return response()->json($hospitals);
    }

    public function fetchMinistriesOfHealth()
    {
        $ministriesOfHealth = MinistryOfHealth::all(['id', 'name'])->toArray();
        return response()->json($ministriesOfHealth);
    }
    public function fetchNurse()
    {
        $ministriesOfHealth = Nurse::all(['id', 'name'])->toArray();
        return response()->json($ministriesOfHealth);
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
    }

    public function createRecordOfDoctor(Request $request)
    {
        // Validate request data
        $validator = Validator::make($request->all(), [
            'name' => 'required|string',
            'salary' => 'required|string',

            'country' => 'required|string',
            'city' => 'required|string',
            'phone' => 'required|string',
            'email' => 'required|string',

            'specialization' => 'required|string',
            'ministry_of_health_id' => 'required|exists:ministryofhealths,id',
            'hospital_id' => 'required|exists:hospitals,id',
            'about' => 'required|string',
            'schedule' => 'required|array',
            'image' => 'nullable|image|max:2048'
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

        // Create new Doctor record
        $doctor = new Doctor;
        $doctor->name = $request->input('name');
        $doctor->salary = $request->input('salary');
        $doctor->about = $request->input('about');
        $doctor->country = $request->input('country');
        $doctor->city = $request->input('city');
        $doctor->email = $request->input('email');
        $doctor->phone = $request->input('phone');
        $doctor->specialization = $request->input('specialization');
        $doctor->schedule = $schedule;
        // $doctor->startTime = $request->input('startTime');
        if ($request->hasFile('image')) {
            $image = $request->file('image');
            $filename = time() . '.' . $image->getClientOriginalExtension();
            $path = $image->storeAs('public/images/doctors', $filename);
            $doctor->image = $filename;
            $doctor->save();
        }
        // $doctor->endTime = $request->input('endTime');




        // Set the related entities
        $ministryOfHealthId = $request->input('ministry_of_health_id');
        if ($ministryOfHealthId) {
            $ministryOfHealth = MinistryOfHealth::find($ministryOfHealthId);
            if (!$ministryOfHealth) {
                $ministryOfHealth = new MinistryOfHealth();
                $ministryOfHealth->name = $request->input('ministryOfHealthName');
                $ministryOfHealth->save();
            }
            $doctor->ministry_of_health_id = $ministryOfHealth->id;
        }

        $hospitalId = $request->input('hospital_id');
        if ($hospitalId) {
            $hospital = Hospital::find($hospitalId);
            if (!$hospital) {
                $hospital = new Hospital();
                $hospital->name = $request->input('hospitalName');
                $hospital->save();
            }
            $doctor->hospital_id = $hospital->id;
        }
        // Save Doctor record to database
        $doctor->save();

        // Handle image upload, if any

        return response()->json(['message' => 'Doctor record created successfully', 'doctor' => $doctor], 201);
    }




    public function createRecordOfDoctorNew(Request $request)
    {
        // Validate request data
        $validator = Validator::make($request->all(), [
            'name' => 'required|string',
            'salary' => 'required|string',

            'country' => 'required|string',
            'city' => 'required|string',
            'phone' => 'required|string',
            'email' => 'required|string',

            'specialization' => 'required|string',
            'ministry_of_health_id' => 'required|exists:ministryofhealths,id',
            'hospital_id' => 'required|exists:hospitals,id',

            'about' => 'required|string',
            'schedule' => 'required|array',
            'image' => 'nullable|image|max:2048'
        ]);


        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        // Create new Doctor record
        $doctor = new Doctor;
        $doctor->name = $request->input('name');
        $doctor->salary = $request->input('salary');
        $doctor->about = $request->input('about');
        $doctor->country = $request->input('country');
        $doctor->city = $request->input('city');
        $doctor->email = $request->input('email');
        $doctor->phone = $request->input('phone');

        // Set the related entities
        $ministryOfHealthName = $request->input('ministryOfHealthName');
        if ($ministryOfHealthName) {
            $ministryOfHealth = MinistryOfHealth::where('name', $ministryOfHealthName)->first();
            if (!$ministryOfHealth) {
                $ministryOfHealth = new MinistryOfHealth();
                $ministryOfHealth->name = $ministryOfHealthName;
                $ministryOfHealth->save();
            }
            $doctor->ministry_of_health_id = $ministryOfHealth->id;
        }

        $hospitalName = $request->input('hospitalName');
        if ($hospitalName) {
            $hospital = Hospital::where('name', $hospitalName)->first();
            if (!$hospital) {
                $hospital = new Hospital();
                $hospital->name = $hospitalName;
                $hospital->save();
            }
            $doctor->hospital_id = $hospital->id;
        }



        // Save the doctor
        $doctor->save();

        // Return the response or redirect
        return response()->json(['message' => 'Doctor created successfully'], 200);
    }





    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        // validate the request data
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'about_info' => 'required|string|max:255',
            'salary' => 'required|integer',
            'nurse_id' => 'nullable|exists:nurses,id',
            'midwife_id' => 'nullable|exists:midwives,id',
            'specialization_id' => 'nullable|exists:specializations,id',
            'ministry_of_health_id' => 'nullable|exists:ministry_of_healths,id',
            'schedule_days' => 'nullable|string',
            'image' => 'nullable|image|mimes:jpeg,png,jpg|max:2048',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'errors' => $validator->errors(),
                'message' => 'Validation error',
            ], 422);
        }

        // Create new doctor object
        $doctor = new Doctor();
        $doctor->name = $request->name;
        $doctor->salary = $request->salary;
        $doctor->about_info = $request->about_info;

        // Check if the nurse_id exists in the input request
        if ($request->filled('nurse_id')) {
            $nurse = Nurse::find($request->nurse_id);
            if (!$nurse) {
                return response()->json([
                    'status' => 'error',
                    'message' => 'Nurse not found',
                ], 404);
            }
            $doctor->nurse()->associate($nurse);
        }

        // Check if the midwife_id exists in the input request
        if ($request->filled('midwife_id')) {
            $midwife = Midwife::find($request->midwife_id);
            if (!$midwife) {
                return response()->json([
                    'status' => 'error',
                    'message' => 'Midwife not found',
                ], 404);
            }
            $doctor->midwife()->associate($midwife);
        }

        // Check if the specialization_id exists in the input request
        if ($request->filled('specialization_id')) {
            $specialization = Specialization::find($request->specialization_id);
            if (!$specialization) {
                return response()->json([
                    'status' => 'error',
                    'message' => 'Specialization not found',
                ], 404);
            }
            $doctor->specialization()->associate($specialization);
        }

        // Check if the ministry_of_health_id exists in the input request
        if ($request->filled('ministry_of_health_id')) {
            $ministry_of_health = MinistryOfHealth::find($request->ministry_of_health_id);
            if (!$ministry_of_health) {
                return response()->json([
                    'status' => 'error',
                    'message' => 'Ministry of Health not found',
                ], 404);
            }
            $doctor->ministryOfHealth()->associate($ministry_of_health);
        }

        // Handle image upload
        if ($request->hasFile('image')) {
            $image = $request->file('image');
            $imageName = time() . '.' . $image->getClientOriginalExtension();
            $image->storeAs('public/uploads/doctors', $imageName);
            $doctor->image = 'uploads/doctors/' . $imageName;
        }

        // Save the doctor object
        $doctor->save();


        return response()->json([
            'status' => 'success',
            'message' => 'Successfully created new doctor',
            'data' => $doctor,
        ], 201);
    }


    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $doctor = doctor::find($id);

        if (!$doctor) {
            return response()->json([
                'status' => 'error',
                'message' => 'doctor id not found',
            ], 404);
        } else {

            return response()->json([
                'status' => 'success',
                'message' => 'doctor id retrieved successfully',
                'data' => $doctor,
            ]);
        }
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
        // Retrieve the doctor record by ID
        $doctor = doctor::find($id);

        // Check if the record exists
        if (!$doctor) {
            // If the doctor record doesn't exist, return an error message
            return response()->json([
                'status' => 'error',
                'message' => 'doctor id record not found',
            ], 404);
        }

        // If the record exists, return the record data in JSON format with a success message
        return response()->json([
            'status' => 'success',
            'message' => 'doctor id record found',
            'data' => $doctor,
        ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        // Validate the request data
        $validator = Validator::make($request->all(), [
            'name' => 'nullable|string',
            'salary' => 'nullable|string',
            'country' => 'nullable|string',
            'city' => 'nullable|string',
            'phone' => 'nullable|string',
            'email' => 'nullable|string',
            'specialization' => 'nullable|string',
            'ministry_of_health_id' => 'nullable|exists:ministryofhealths',
            'hospital_id' => 'nullable|exists:hospitals,id',
            'about' => 'nullable|string',
            // 'schedule' => 'nullable|array',
            'schedule.*.day' => 'required|string',
            'schedule.*.start' => 'nullable|string',
            'schedule.*.end' => 'nullable|string',
            'image' => 'nullable|image|max:2048'
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $doctor = Doctor::findOrFail($id);

        $doctor->name = $request->input('name');
        $doctor->salary = $request->input('salary');
        $doctor->about = $request->input('about');
        $doctor->country = $request->input('country');
        $doctor->city = $request->input('city');
        $doctor->email = $request->input('email');
        $doctor->phone = $request->input('phone');
        $doctor->specialization = $request->input('specialization');
        // Update related entities
        $hospitalId = $request->input('hospital_id');
        if ($hospitalId) {
            $hospital = Hospital::find($hospitalId);
            if (!$hospital) {
                $hospital = new Hospital();
                $hospital->name = $request->input('hospitalName');
                $hospital->save();
            }
            $doctor->hospital_id = $hospital->id;
        } else {
            $doctor->hospital_id = null; // Handle the case when hospital_id is not provided
        }
        $ministry_of_health_id = $request->input('ministry_of_health_id');
        if ($ministry_of_health_id) {
            $ministry = MinistryOfHealth::find($ministry_of_health_id);
            if (!$ministry) {
                $ministry = new MinistryOfHealth();
                $ministry->name = $request->input('ministryName');
                $ministry->save();
            }
            $doctor->ministry_of_health_id = $ministry->id;
        } else {
            $doctor->ministry_of_health_id = null; // Handle the case when ministry_of_health_id is not provided
        }

        // Update schedule
        $schedule = $request->input('schedule');
        if ($schedule) {
            $doctor->schedule = $schedule;
        }

        // Handle image upload
        if ($request->hasFile('image')) {
            $image = $request->file('image');
            $imageName = time() . '.' . $image->getClientOriginalExtension();
            $image->move(public_path('images'), $imageName);
            $doctor->image = $imageName;
        }

        $doctor->save();

        // Assuming you have a response structure for successful updates, you can return a success response here
        return response()->json(['message' => 'Doctor updated successfully']);
    }



    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        // Retrieve the doctor table record with the given ID
        $doctor = doctor::find($id);

        // Check if the doctor table record exists
        if (!$doctor) {
            return response()->json([
                'status' => 'error',
                'message' => 'doctor record record not found',
            ], 404);
        }

        // Delete the doctor  record record
        $doctor->delete();

        // Return a success message
        return response()->json([
            'status' => 'success',
            'message' => 'doctor  record record deleted successfully',
        ]);
    }
}

<?php

namespace App\Http\Controllers;

use App\Models\Doctor;
use App\Models\Midwife;
use App\Models\MinistryOfHealth;
use App\Models\Nurse;
use App\Models\Specialization;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rule;

class DoctorController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        //
        $doctor = Doctor::all();

        return response()->json([
            'status' => 'success',
            'message' => 'all doctors record  retrieved successfully',
            'data' => $doctor,
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
        // validate the request data
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'salary' => 'required|integer',
            'nurse_id' => 'nullable|exists:nurses,id',
            'midwife_id' => 'nullable|exists:midwives,id',
            'specialization_id' => 'nullable|exists:specializations,id',
            'ministry_of_health_id' => 'nullable|exists:ministry_of_healths,id',
        ]);
    
        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'errors' => $validator->errors(),
                'message' => 'Validation error',
            ], 422);
        }
    
        $data = $request->all();
    
        // Create new doctor object
        $doctor = new Doctor();
        $doctor->name = $data['name'];
        $doctor->salary = $data['salary'];
    
        // Check if the nurse_id exists in the input request
        if (isset($data['nurse_id'])) {
            $nurse = Nurse::find($data['nurse_id']);
            if (!$nurse) {
                return response()->json([
                    'status' => 'error',
                    'message' => 'Nurse not found',
                ], 404);
            }
            $doctor->nurse()->associate($nurse);
        }
    
        // Check if the midwife_id exists in the input request
        if (isset($data['midwife_id'])) {
            $midwife = Midwife::find($data['midwife_id']);
            if (!$midwife) {
                return response()->json([
                    'status' => 'error',
                    'message' => 'Midwife not found',
                ], 404);
            }
            $doctor->midwife()->associate($midwife);
        }
    
        // Check if the specialization_id exists in the input request
        if (isset($data['specialization_id'])) {
            $specialization = Specialization::find($data['specialization_id']);
            if (!$specialization) {
                return response()->json([
                    'status' => 'error',
                    'message' => 'Specialization not found',
                ], 404);
            }
            $doctor->specialization()->associate($specialization);
        }
    
        // Check if the ministry_of_health_id exists in the input request
        if (isset($data['ministry_of_health_id'])) {
            $ministry_of_health = MinistryOfHealth::find($data['ministry_of_health_id']);
            if (!$ministry_of_health) {
                return response()->json([
                    'status' => 'error',
                    'message' => 'Ministry of Health not found',
                ], 404);
            }
            $doctor->ministryOfHealth()->associate($ministry_of_health);
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
        //validate the request data
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'salary' => 'required|integer',
            'nurse_id' => 'nullable|exists:nurses,id',
            'midwife_id' => 'nullable|exists:midwives,id',
            'specialization_id' => 'nullable|exists:specializations,id',
            'ministry_of_health_id' => [
                'nullable',
                Rule::exists('ministries_of_health', 'id')->where(function ($query) use ($request) {
                    $query->where('country', $request->input('country'));
                }),
            ],
        ]);
        
        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'errors' => $validator->errors(),
                'message' => 'validation error',
            ], 422);
        }
        
        $doctor = Doctor::findOrFail($id);
        
        $doctor->name = $request->input('name');
        $doctor->salary = $request->input('salary');
        $doctor->nurse_id = $request->input('nurse_id');
        $doctor->midwife_id = $request->input('midwife_id');
        $doctor->specialization_id = $request->input('specialization_id');
        $doctor->ministry_of_health_id = $request->input('ministry_of_health_id');
        
        $doctor->save();
        
        return response()->json([
            'status' => 'success',
            'message' => 'successfully updated doctor record',
            'data' => $doctor,
        ], 200);
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

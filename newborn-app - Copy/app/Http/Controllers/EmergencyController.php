<?php

namespace App\Http\Controllers;

use App\Models\Children_Emergency;
use App\Models\Doctor;
use App\Models\Midwife;
use App\Models\Newborn;
use App\Models\Newborn_bath;
use App\Models\Nurse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class EmergencyController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        //
        $emergency = Children_Emergency::all();

        return response()->json([
            'status' => 'success',
            'message' => 'all newborn in the emergency record  retrieved successfully',
            'data' => $emergency,
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
        $validator = Validator::make($request->all(), [
            'name' => 'required|string',
            'location' => 'required|string',
            'contact_number' => 'required|string',
            'risk' => 'required|string',
            'status' => 'required|string',
            'Referred' => 'required|string',
            'number_newborns' => 'required|integer',
            'newborn_id' => 'nullable|exists:newborns,id',
            'doctor_id' => 'nullable|exists:doctors,id',
            'midwife_id' => 'nullable|exists:midwives,id',
            'nurse_id' => 'nullable|exists:nurses,id',
            'newborn_bath_id' => 'nullable|exists:newborn_baths,id',
        ]);
    
        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => 'validation error',
                'errors' => $validator->errors(),
            ], 422);
        }
    
        $emergency = Children_Emergency::create($request->all());
    
        if ($request->has('newborn_id')) {
            $emergency->newborn()->associate(Newborn::find($request->input('newborn_id')));
        }
    
        if ($request->has('doctor_id')) {
            $emergency->doctor()->associate(Doctor::find($request->input('doctor_id')));
        }
    
        if ($request->has('midwife_id')) {
            $emergency->midwife()->associate(Midwife::find($request->input('midwife_id')));
        }
    
        if ($request->has('nurse_id')) {
            $emergency->nurse()->associate(Nurse::find($request->input('nurse_id')));
        }
    
        if ($request->has('newborn_bath_id')) {
            $emergency->newbornBath()->associate(Newborn_bath::find($request->input('newborn_bath_id')));
        }
    
        $emergency->save();
    
        return response()->json([
            'status' => 'success',
            'message' => 'emergency created successfully',
            'data' => $emergency,
        ], 201);
    }
    

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $emergencyNewborn = Children_Emergency::find($id);

        if (!$emergencyNewborn) {
            return response()->json([
                'status' => 'error',
                'message' => 'emergencyNewborn id not found',
            ], 404);
        } else {

            return response()->json([
                'status' => 'success',
                'message' => 'emergencyNewborn id retrieved successfully',
                'data' => $emergencyNewborn,
            ]);
        }
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
            // Retrieve the emergencyNewborn record by ID
            $emergencyNewborn = Children_Emergency::find($id);

            // Check if the record exists
            if (!$emergencyNewborn) {
                // If the emergencyNewborn record doesn't exist, return an error message
                return response()->json([
                    'status' => 'error',
                    'message' => 'emergencyNewborn id record not found',
                ], 404);
            }
    
            // If the record exists, return the record data in JSON format with a success message
            return response()->json([
                'status' => 'success',
                'message' => 'emergencyNewborn id record found',
                'data' => $emergencyNewborn,
            ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        // Retrieve the Emergency record by ID
        $emergency = Children_Emergency::find($id);
    
        // Check if the record exists
        if (!$emergency) {
            return response()->json([
                'status' => 'error',
                'message' => 'Emergency record not found',
            ], 404);
        }
    
        // Validate the request data
        $validator = Validator::make($request->all(), [
            'patient_id' => 'nullable|integer|exists:patients,id',
            'description' => 'nullable|string',
            'status' => 'nullable|in:open,closed',
            'hospital_id' => 'nullable|integer|exists:hospitals,id',
            'ambulance_id' => 'nullable|integer|exists:ambulances,id',
            'start_time' => 'nullable|date',
            'end_time' => 'nullable|date|after:start_time',
            'notes' => 'nullable|string',
            'updated_by' => 'nullable|string',
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
    
        // Update the Emergency record with the new data
        $emergency->update($data);
    
        return response()->json([
            'status' => 'success',
            'message' => 'Emergency record updated successfully',
            'data' => $emergency,
        ]);
    }
    

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
         // Retrieve the emergencyNewborn table record with the given ID
         $emergencyNewborn = Children_Emergency::find($id);

         // Check if the emergencyNewborn table record exists
         if (!$emergencyNewborn) {
             return response()->json([
                 'status' => 'error',
                 'message' => 'emergencyNewborn record record not found',
             ], 404);
         }
 
         // Delete the emergencyNewborn  record record
         $emergencyNewborn->delete();
 
         // Return a success message
         return response()->json([
             'status' => 'success',
             'message' => 'emergencyNewborn  record record deleted successfully',
         ]);
    }
}

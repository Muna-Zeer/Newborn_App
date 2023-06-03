<?php

namespace App\Http\Controllers;

use App\Models\Appointment;
use Illuminate\Database\QueryException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rule;

class AppointmentController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        //
        $appointment = Appointment::all();

        return response()->json([
            'status' => 'success',
            'message' => 'all appointments record  retrieved successfully',
            'data' => $appointment,
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
            'appointment_date' => 'required|date',
            'appointment_time' => 'required|date_format:H:i',
            'appointment_type' => 'required|string',
            'newborn_id' => [
                'nullable',
                Rule::exists('newborns', 'id')->where(function ($query) use ($request) {
                    $query->where('ministry_id', $request->input('ministry_id'));
                }),
            ],
            'hospital_id' => [
                'nullable',
                Rule::exists('hospitals', 'id')->where(function ($query) use ($request) {
                    $query->where('ministry_id', $request->input('ministry_id'));
                }),
            ],
            'health_center_id' => [
                'nullable',
                Rule::exists('HealthCenters', 'id')->where(function ($query) use ($request) {
                    $query->where('ministry_id', $request->input('ministry_id'));
                }),
            ],
        ]);
    
        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }
    
        try {
            $appointment = Appointment::create($request->all());
        } catch (QueryException $exception) {
            return response()->json(['errors' => ['database' => [$exception->getMessage()]]], 422);
        }
    
        return response()->json(['appointment' => $appointment], 201);
    }
    

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $appointment = appointment::find($id);

        if (!$appointment) {
            return response()->json([
                'status' => 'error',
                'message' => 'appointment id not found',
            ], 404);
        } else {

            return response()->json([
                'status' => 'success',
                'message' => 'appointment id retrieved successfully',
                'data' => $appointment,
            ]);
        }
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
            // Retrieve the appointment record by ID
            $appointment = appointment::find($id);

            // Check if the record exists
            if (!$appointment) {
                // If the appointment record doesn't exist, return an error message
                return response()->json([
                    'status' => 'error',
                    'message' => 'appointment id record not found',
                ], 404);
            }
    
            // If the record exists, return the record data in JSON format with a success message
            return response()->json([
                'status' => 'success',
                'message' => 'appointment id record found',
                'data' => $appointment,
            ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        // Retrieve the Appointment record by ID
        $appointment = Appointment::find($id);
    
        // Check if the record exists
        if (!$appointment) {
            return response()->json([
                'status' => 'error',
                'message' => 'Appointment record not found',
            ], 404);
        }
    
        // Validate the request data
        $validator = Validator::make($request->all(), [
            'appointment_date' => 'nullable|date',
            'appointment_time' => 'nullable|date_format:H:i',
            'appointment_type' => 'nullable|string',
            'newborn_id' => 'nullable|integer|exists:newborns,id',
            'hospital_id' => 'nullable|integer|exists:hospitals,id',
            'health_center_id' => 'nullable|integer|exists:health_centers,id',
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
    
        // Update the Appointment record with the new data
        $appointment->update($data);
    
        return response()->json([
            'status' => 'success',
            'message' => 'Appointment record updated successfully',
            'data' => $appointment,
        ]);
    }
    

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
         // Retrieve the appointment table record with the given ID
         $appointment = appointment::find($id);

         // Check if the appointment table record exists
         if (!$appointment) {
             return response()->json([
                 'status' => 'error',
                 'message' => 'appointment record record not found',
             ], 404);
         }
 
         // Delete the appointment  record record
         $appointment->delete();
 
         // Return a success message
         return response()->json([
             'status' => 'success',
             'message' => 'appointment  record record deleted successfully',
         ]);
    }
}

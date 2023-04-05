<?php

namespace App\Http\Controllers;

use App\Models\Nurse;
use Illuminate\Http\Request;
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
        $request->validate([
            'name' => 'required|string',
            'salary' => 'required|integer',
            'health_center_id' => 'nullable|exists:health_centers,id',
            'hospital_center_id' => 'nullable|exists:hospitals,id',
            'specialization_id' => 'nullable|exists:specializations,id',
            'ministry_of_health_id' => 'nullable|exists:ministry_of_healths,id',
        ]);
    
        $nurse = Nurse::create($request->all());
    
        return response()->json([
            'status' => 'success',
            'message' => 'Nurse created successfully',
            'data' => $nurse->load(['healthCenter', 'hospitalCenter', 'specialization', 'ministryOfHealth']),
        ], 201);
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
            'hospital_center_id' => 'nullable|integer|exists:hospitals,id',
            'specialization_id' => 'nullable|integer|exists:specializations,id',
            'ministry_of_health_id' => 'nullable|integer|exists:ministry_of_health,id',
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
        $nurse->load('healthCenter', 'hospitalCenter', 'specialization', 'ministryOfHealth');
    
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


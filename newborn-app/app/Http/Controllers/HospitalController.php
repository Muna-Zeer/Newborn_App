<?php

namespace App\Http\Controllers;

use App\Models\Hospital;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class HospitalController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        //
        $hospital = Hospital::all();

        return response()->json([
            'status' => 'success',
            'message' => 'all hospitals record  retrieved successfully',
            'data' => $hospital,
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
            'name' => 'required|string|max:255',
            'address' => 'required|string|max:255',
            'phone_number' => 'required|string|max:20',
            'email' => 'nullable|email|max:255',
            'registered_with_ministry' => 'boolean',
            'ministry_of_health_id' => 'nullable|integer|exists:ministry_of_health,id',
        ]);
    
        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => 'Validation error',
                'errors' => $validator->errors(),
                'data' => [],
            ], 400);
        }
    
        $data = $request->all();
    
        $hospital = Hospital::create($data);
    
        return response()->json([
            'status' => 'success',
            'message' => 'Hospital created successfully',
            'data' => $hospital,
        ]);
    }
    

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $hospital = hospital::find($id);

        if (!$hospital) {
            return response()->json([
                'status' => 'error',
                'message' => 'hospital id not found',
            ], 404);
        } else {

            return response()->json([
                'status' => 'success',
                'message' => 'hospital id retrieved successfully',
                'data' => $hospital,
            ]);
        }
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
            // Retrieve the hospital record by ID
            $hospital = hospital::find($id);

            // Check if the record exists
            if (!$hospital) {
                // If the hospital record doesn't exist, return an error message
                return response()->json([
                    'status' => 'error',
                    'message' => 'hospital id record not found',
                ], 404);
            }
    
            // If the record exists, return the record data in JSON format with a success message
            return response()->json([
                'status' => 'success',
                'message' => 'hospital id record found',
                'data' => $hospital,
            ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        // Retrieve the Hospital record by ID
        $hospital = Hospital::find($id);
    
        // Check if the record exists
        if (!$hospital) {
            return response()->json([
                'status' => 'error',
                'message' => 'Hospital record not found',
            ], 404);
        }
    
        // Validate the request data
        $validator = Validator::make($request->all(), [
            'name' => 'nullable|string|max:255',
            'address' => 'nullable|string|max:255',
            'phone_number' => 'nullable|string|max:255',
            'email' => 'nullable|email|max:255',
            'registered_with_ministry' => 'nullable|boolean',
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
    
        // Update the Hospital record with the new data
        $hospital->update($data);
    
        return response()->json([
            'status' => 'success',
            'message' => 'Hospital record updated successfully',
            'data' => $hospital,
        ]);
    }
    

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
         // Retrieve the hospital table record with the given ID
         $hospital = hospital::find($id);

         // Check if the hospital table record exists
         if (!$hospital) {
             return response()->json([
                 'status' => 'error',
                 'message' => 'hospital record record not found',
             ], 404);
         }
 
         // Delete the hospital  record record
         $hospital->delete();
 
         // Return a success message
         return response()->json([
             'status' => 'success',
             'message' => 'hospital  record record deleted successfully',
         ]);
    }
}

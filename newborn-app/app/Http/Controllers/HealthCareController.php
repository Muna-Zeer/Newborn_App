<?php

namespace App\Http\Controllers;

use App\Models\HealthCare;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rule;

class HealthCareController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        //
        $healthCare = HealthCare::all();

        return response()->json([
            'status' => 'success',
            'message' => 'all healthcare record  retrieved successfully',
            'data' => $healthCare,
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
            'disease_type' => 'nullable|string',
            'symptoms' => 'nullable|string',
            'care_tips' => 'nullable|string',
            'ministry_id' => [
                'nullable',
                Rule::exists('ministries_of_health', 'id'),
            ],
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
    
        // Create a new HealthCare record with the request data
        $healthCare = new HealthCare;
        $healthCare->fill($request->all());
        $healthCare->save();
    
        return response()->json([
            'status' => 'success',
            'message' => 'HealthCare record created successfully',
            'data' => $healthCare,
        ]);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $healthCare = healthCare::find($id);

        if (!$healthCare) {
            return response()->json([
                'status' => 'error',
                'message' => 'healthCare id not found',
            ], 404);
        } else {

            return response()->json([
                'status' => 'success',
                'message' => 'healthCare id retrieved successfully',
                'data' => $healthCare,
            ]);
        }
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
            // Retrieve the healthCare record by ID
            $healthCare = healthCare::find($id);

            // Check if the record exists
            if (!$healthCare) {
                // If the healthCare record doesn't exist, return an error message
                return response()->json([
                    'status' => 'error',
                    'message' => 'healthCare id record not found',
                ], 404);
            }
    
            // If the record exists, return the record data in JSON format with a success message
            return response()->json([
                'status' => 'success',
                'message' => 'healthCare id record found',
                'data' => $healthCare,
            ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        // Retrieve the HealthCare record by ID
        $healthCare = HealthCare::find($id);
    
        // Check if the record exists
        if (!$healthCare) {
            return response()->json([
                'status' => 'error',
                'message' => 'HealthCare record not found',
            ], 404);
        }
    
        // Validate the request data
        $validator = Validator::make($request->all(), [
            'disease_type' => 'nullable|string',
            'symptoms' => 'nullable|string',
            'care_tips' => 'nullable|string',
            'ministry_id' => [
                'nullable',
                Rule::exists('MinistryOfHealths', 'id')->where(function ($query) use ($request) {
                    $query->where('country', $request->input('country'));
                }),
            ],
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
    
        // Update the HealthCare record with the new data
        $healthCare->update($data);
    
        return response()->json([
            'status' => 'success',
            'message' => 'HealthCare record updated successfully',
            'data' => $healthCare,
        ]);
    }
  
    
    
    
    

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
         // Retrieve the healthCare table record with the given ID
         $healthCare = healthCare::find($id);

         // Check if the healthCare table record exists
         if (!$healthCare) {
             return response()->json([
                 'status' => 'error',
                 'message' => 'healthCare record record not found',
             ], 404);
         }
 
         // Delete the healthCare  record record
         $healthCare->delete();
 
         // Return a success message
         return response()->json([
             'status' => 'success',
             'message' => 'healthCare  record record deleted successfully',
         ]);
    }
}

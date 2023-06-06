<?php

namespace App\Http\Controllers;

use App\Models\DateOfImmunization;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class DateOfImmunizationController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        //
        $date= DateOfImmunization::all();

        return response()->json([
            'status' => 'success',
            'message' => 'all dates record  retrieved successfully',
            'data' => $date,
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
            'name' => 'nullable|string',
            'date_administrated' => 'nullable|date',
            'next_dose_date' => 'nullable|date|after:date_administrated',
            'administered_by' => 'nullable|string',
            'lot_no' => 'nullable|string',
            'newborn_id' => 'nullable|integer|exists:newborns,id',
            'vaccine_id' => 'nullable|integer|exists:vaccines,id',
            'nurse_id' => 'nullable|integer|exists:nurses,id',
            'doctor_id' => 'nullable|integer|exists:doctors,id',
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
    
        // Create a new DateOfImmunization record with the validated data
        $immunization = DateOfImmunization::create($data);
    
        return response()->json([
            'status' => 'success',
            'message' => 'DateOfImmunization record created successfully',
            'data' => $immunization,
        ]);
    }
    

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $dateOfImmunization = dateOfImmunization::find($id);

        if (!$dateOfImmunization) {
            return response()->json([
                'status' => 'error',
                'message' => 'dateOfImmunization id not found',
            ], 404);
        } else {

            return response()->json([
                'status' => 'success',
                'message' => 'dateOfImmunization id retrieved successfully',
                'data' => $dateOfImmunization,
            ]);
        }
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
            // Retrieve the dateOfImmunization record by ID
            $dateOfImmunization = dateOfImmunization::find($id);

            // Check if the record exists
            if (!$dateOfImmunization) {
                // If the dateOfImmunization record doesn't exist, return an error message
                return response()->json([
                    'status' => 'error',
                    'message' => 'dateOfImmunization id record not found',
                ], 404);
            }
    
            // If the record exists, return the record data in JSON format with a success message
            return response()->json([
                'status' => 'success',
                'message' => 'dateOfImmunization id record found',
                'data' => $dateOfImmunization,
            ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        // Retrieve the DateOfImmunization record by ID
        $immunization = DateOfImmunization::find($id);
    
        // Check if the record exists
        if (!$immunization) {
            return response()->json([
                'status' => 'error',
                'message' => 'DateOfImmunization record not found',
            ], 404);
        }
    
        // Validate the request data
        $validator = Validator::make($request->all(), [
            'name' => 'nullable|string',
            'date_administrated' => 'nullable|date',
            'next_dose_date' => 'nullable|date|after:date_administrated',
            'administered_by' => 'nullable|string',
            'lot_no' => 'nullable|string',
            'newborn_id' => 'nullable|integer|exists:newborns,id',
            'vaccine_id' => 'nullable|integer|exists:vaccines,id',
            'nurse_id' => 'nullable|integer|exists:nurses,id',
            'doctor_id' => 'nullable|integer|exists:doctors,id',
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
    
        // Update the DateOfImmunization record with the new data
        $immunization->update($data);
    
        return response()->json([
            'status' => 'success',
            'message' => 'DateOfImmunization record updated successfully',
            'data' => $immunization,
        ]);
    }
    

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
         // Retrieve the dateOfImmunization table record with the given ID
         $dateOfImmunization = dateOfImmunization::find($id);

         // Check if the dateOfImmunization table record exists
         if (!$dateOfImmunization) {
             return response()->json([
                 'status' => 'error',
                 'message' => 'dateOfImmunization record record not found',
             ], 404);
         }
 
         // Delete the dateOfImmunization  record record
         $dateOfImmunization->delete();
 
         // Return a success message
         return response()->json([
             'status' => 'success',
             'message' => 'dateOfImmunization  record record deleted successfully',
         ]);
    }
}

<?php

namespace App\Http\Controllers;

use App\Models\Measurements;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rule;

class MeasurementController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        //
        $measurement = Measurements::all();

        return response()->json([
            'status' => 'success',
            'message' => 'all measurement record  retrieved successfully',
            'data' => $measurement,
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
            'height' => 'nullable|numeric',
            'weight' => 'nullable|numeric',
            'head_circumference' => 'nullable|numeric',
            'date' => 'nullable|date',
            'time' => 'nullable|date_format:H:i',
            'nurse_name' => 'nullable|string|max:255',
            'remarks' => 'nullable|string',
            'age' => 'nullable|integer|min:0',
            'tonics' => 'nullable|string|max:255',
            'newborn_id' => 'nullable|exists:newborns,id',
            'nurse_id' => 'nullable|exists:nurses,id',
            'midwife_id' => 'nullable|exists:midwives,id',
            'health_center_id' => 'nullable|exists:health_centers,id',
            'ministry_id' => [
                'nullable',
                Rule::exists('ministries_of_health', 'id')->where(function ($query) use ($request) {
                    $query->where('country', $request->input('country'));
                }),
            ],
            'hospital_id' => 'nullable|exists:hospitals,id',
        ]);
    
        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation failed',
                'errors' => $validator->errors(),
            ], 422);
        }
    
        $measurement = new Measurements([
            'height' => $request->input('height'),
            'weight' => $request->input('weight'),
            'head_circumference' => $request->input('head_circumference'),
            'date' => $request->input('date'),
            'time' => $request->input('time'),
            'nurse_name' => $request->input('nurse_name'),
            'remarks' => $request->input('remarks'),
            'age' => $request->input('age'),
            'tonics' => $request->input('tonics'),
            'newborn_id' => $request->input('newborn_id'),
            'nurse_id' => $request->input('nurse_id'),
            'midwife_id' => $request->input('midwife_id'),
            'health_center_id' => $request->input('health_center_id'),
            'ministry_id' => $request->input('ministry_id'),
            'hospital_id' => $request->input('hospital_id'),
        ]);
    
        $measurement->save();
    
        return response()->json([
            'success' => true,
            'message' => 'Measurement created successfully',
            'measurement' => $measurement,
        ], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $measurement = Measurements::find($id);

        if (!$measurement) {
            return response()->json([
                'status' => 'error',
                'message' => 'measurement id not found',
            ], 404);
        } else {

            return response()->json([
                'status' => 'success',
                'message' => 'measurement id retrieved successfully',
                'data' => $measurement,
            ]);
        }
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
            // Retrieve the Measurement record by ID
            $Measurement = Measurements::find($id);

            // Check if the record exists
            if (!$Measurement) {
                // If the Measurement record doesn't exist, return an error message
                return response()->json([
                    'status' => 'error',
                    'message' => 'Measurement id record not found',
                ], 404);
            }
    
            // If the record exists, return the record data in JSON format with a success message
            return response()->json([
                'status' => 'success',
                'message' => 'Measurement id record found',
                'data' => $Measurement,
            ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        // Retrieve the Measurement record by ID
        $measurement = Measurements::find($id);
    
        // Check if the record exists
        if (!$measurement) {
            return response()->json([
                'status' => 'error',
                'message' => 'Measurement record not found',
            ], 404);
        }
    
        // Validate the request data
        $validator = Validator::make($request->all(), [
            'height' => 'nullable|numeric',
            'weight' => 'nullable|numeric',
            'head_circumference' => 'nullable|numeric',
            'date' => 'nullable|date',
            'time' => 'nullable|date_format:H:i',
            'nurse_name' => 'nullable|string',
            'remarks' => 'nullable|string',
            'age' => 'nullable|integer',
            'tonics' => 'nullable|string',
            'newborn_id' => [
                'nullable',
                Rule::exists('newborns', 'id')
            ],
            'nurse_id' => [
                'nullable',
                Rule::exists('nurses', 'id')
            ],
            'midwife_id' => [
                'nullable',
                Rule::exists('midwives', 'id')
            ],
            'health_center_id' => [
                'nullable',
                Rule::exists('health_centers', 'id')
            ],
            'ministry_id' => [
                'nullable',
                Rule::exists('MinistryOfHealths', 'id')->where(function ($query) use ($request) {
                    $query->where('country', $request->input('country'));
                }),
            ],
            'hospital_id' => [
                'nullable',
                Rule::exists('hospitals', 'id')->where(function ($query) use ($request) {
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
    
        // Update the Measurement record with the new data
        $measurement->update($request->all());
    
        return response()->json([
            'status' => 'success',
            'message' => 'Measurement record updated successfully',
            'data' => $measurement,
        ]);
    }
    

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
         // Retrieve the Measurement table record with the given ID
         $Measurement = Measurements::find($id);

         // Check if the Measurement table record exists
         if (!$Measurement) {
             return response()->json([
                 'status' => 'error',
                 'message' => 'Measurement record record not found',
             ], 404);
         }
 
         // Delete the Measurement  record record
         $Measurement->delete();
 
         // Return a success message
         return response()->json([
             'status' => 'success',
             'message' => 'Measurement  record record deleted successfully',
         ]);
    }
}

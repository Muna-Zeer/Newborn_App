<?php

namespace App\Http\Controllers;

use App\Models\Guideline;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rule;

class GuildelineController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        //
        $guideline = Guideline::all();

        return response()->json([
            'status' => 'success',
            'message' => 'all guidelines record  retrieved successfully',
            'data' => $guideline,
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
            'vaccine_name' => 'required|string|max:255',
            'side_effects' => 'required|string',
            'care_instructions' => 'required|string',
            'prevention_method' => 'required|string',
            'ministry_id' => 'nullable|exists:ministries_of_health,id',
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
    
        // Create a new guideline with the validated data
        $guideline = new Guideline([
            'vaccine_name' => $request->input('vaccine_name'),
            'side_effects' => $request->input('side_effects'),
            'care_instructions' => $request->input('care_instructions'),
            'prevention_method' => $request->input('prevention_method'),
            'ministry_id' => $request->input('ministry_id'),
        ]);
    
        // Save the guideline to the database
        $guideline->save();
    
        return response()->json([
            'status' => 'success',
            'message' => 'Guideline created successfully',
            'data' => $guideline,
        ]);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $Guideline = Guideline::find($id);

        if (!$Guideline) {
            return response()->json([
                'status' => 'error',
                'message' => 'Guideline id not found',
            ], 404);
        } else {

            return response()->json([
                'status' => 'success',
                'message' => 'Guideline id retrieved successfully',
                'data' => $Guideline,
            ]);
        }
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
            // Retrieve the Guideline record by ID
            $Guideline = Guideline::find($id);

            // Check if the record exists
            if (!$Guideline) {
                // If the Guideline record doesn't exist, return an error message
                return response()->json([
                    'status' => 'error',
                    'message' => 'Guideline id record not found',
                ], 404);
            }
    
            // If the record exists, return the record data in JSON format with a success message
            return response()->json([
                'status' => 'success',
                'message' => 'Guideline id record found',
                'data' => $Guideline,
            ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        // Find the guideline by ID
        $guideline = Guideline::find($id);
    
        // Check if the guideline exists
        if (!$guideline) {
            return response()->json([
                'status' => 'error',
                'message' => 'Guideline not found',
            ], 404);
        }
    
        // Validate the request data
        $validator = Validator::make($request->all(), [
            'vaccine_name' => 'nullable|string',
            'side_effects' => 'nullable|string',
            'care_instructions' => 'nullable|string',
            'prevention_method' => 'nullable|string',
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
    
        // Update the guideline with the new data
        $guideline->fill($request->all());
        $guideline->save();
    
        return response()->json([
            'status' => 'success',
            'message' => 'Guideline updated successfully',
            'data' => $guideline,
        ]);
    }
    

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
         // Retrieve the Guideline table record with the given ID
         $Guideline = Guideline::find($id);

         // Check if the Guideline table record exists
         if (!$Guideline) {
             return response()->json([
                 'status' => 'error',
                 'message' => 'Guideline record record not found',
             ], 404);
         }
 
         // Delete the Guideline  record record
         $Guideline->delete();
 
         // Return a success message
         return response()->json([
             'status' => 'success',
             'message' => 'Guideline  record record deleted successfully',
         ]);
    }
}

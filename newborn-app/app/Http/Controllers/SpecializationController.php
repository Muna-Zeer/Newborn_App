<?php

namespace App\Http\Controllers;

use App\Models\Specialization;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class SpecializationController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        //
        $specialization = Specialization::all();

        return response()->json([
            'status' => 'success',
            'message' => 'all specializations record  retrieved successfully',
            'data' => $specialization,
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
            'specialization_name' => 'required|string|unique:specializations',
        ]);
    
        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'errors' => $validator->errors(),
                'message' => 'Validation error',
            ], 422);
        }
    
        $data = $request->all();
        $specialization = Specialization::create($data);
    
        return response()->json([
            'status' => 'success',
            'message' => 'Successfully created new specialization',
            'data' => $specialization,
        ], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $specialization = Specialization::find($id);

        if (!$specialization) {
            return response()->json([
                'status' => 'error',
                'message' => 'specialization id not found',
            ], 404);
        } else {

            return response()->json([
                'status' => 'success',
                'message' => 'specialization id retrieved successfully',
                'data' => $specialization,
            ]);
        }
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
        // Retrieve the specialization record by ID
        $specialization = specialization::find($id);

        // Check if the record exists
        if (!$specialization) {
            // If the specialization record doesn't exist, return an error message
            return response()->json([
                'status' => 'error',
                'message' => 'specialization id record not found',
            ], 404);
        }

        // If the record exists, return the record data in JSON format with a success message
        return response()->json([
            'status' => 'success',
            'message' => 'specialization id record found',
            'data' => $specialization,
        ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        // validate request data
        $validator = Validator::make($request->all(), [
            'specialization_name' => 'string|nullable',
        ]);
    
        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'errors' => $validator->errors(),
                'message' => 'Validation error',
            ], 422);
        }
    
        // find the specialization with the given id
        $specialization = Specialization::find($id);
    
        if (!$specialization) {
            return response()->json([
                'status' => 'error',
                'message' => 'Specialization not found',
            ], 404);
        }
    
        // update specialization data
        $specialization->fill($request->all());
        $specialization->save();
    
        // return response with updated specialization data
        return response()->json([
            'status' => 'success',
            'message' => 'Specialization updated successfully',
            'data' => $specialization,
        ], 200);
    }
    
    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        //
        // Retrieve the specialization record with the given ID
        $specialization = Specialization::find($id);

        // Check if the specialization record exists
        if (!$specialization) {
            return response()->json([
                'status' => 'error',
                'message' => 'specialization record not found',
            ], 404);
        }

        // Delete the specialization record
        $specialization->delete();

        // Return a success message
        return response()->json([
            'status' => 'success',
            'message' => 'specialization record deleted successfully',
        ]);
    }
}

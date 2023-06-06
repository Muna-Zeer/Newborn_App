<?php

namespace App\Http\Controllers;

use App\Models\MinistryOfHealth;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class MinnistryOfHealthController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        //
        $ministry = MinistryOfHealth::all();

        return response()->json([
            'status' => 'success',
            'message' => 'all ministries record  retrieved successfully',
            'data' => $ministry,
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
        // Define validation rules
        $rules = [
            'name' => 'required|string|max:255',
            'address' => 'required|string|max:255',
            'phone_number' => 'required|string|max:20',
            'email' => 'nullable|email|max:255',
        ];

        // Validate request data against rules
        $validator = Validator::make($request->all(), $rules);

        // If validation fails, return error response
        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        // Create new MinistryOfHealth model with request data
        $ministryOfHealth = new MinistryOfHealth();
        $ministryOfHealth->name = $request->input('name');
        $ministryOfHealth->address = $request->input('address');
        $ministryOfHealth->phone_number = $request->input('phone_number');
        $ministryOfHealth->email = $request->input('email');
        $ministryOfHealth->save();

        // Return success response
        return response()->json(['message' => 'Ministry of Health created successfully'], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $ministryOfHealth = ministryOfHealth::find($id);

        if (!$ministryOfHealth) {
            return response()->json([
                'status' => 'error',
                'message' => 'ministryOfHealth id not found',
            ], 404);
        } else {

            return response()->json([
                'status' => 'success',
                'message' => 'ministryOfHealth id retrieved successfully',
                'data' => $ministryOfHealth,
            ]);
        }
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
        // Retrieve the ministryOfHealth record by ID
        $ministryOfHealth = ministryOfHealth::find($id);

        // Check if the record exists
        if (!$ministryOfHealth) {
            // If the ministryOfHealth record doesn't exist, return an error message
            return response()->json([
                'status' => 'error',
                'message' => 'ministryOfHealth id record not found',
            ], 404);
        }

        // If the record exists, return the record data in JSON format with a success message
        return response()->json([
            'status' => 'success',
            'message' => 'ministryOfHealth id record found',
            'data' => $ministryOfHealth,
        ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        // Find MinistryOfHealth model by ID
        $ministryOfHealth = MinistryOfHealth::findOrFail($id);

        // Define validation rules
        $rules = [
            'name' => 'required|string|max:255',
            'address' => 'required|string|max:255',
            'phone_number' => 'required|string|max:20',
            'email' => 'nullable|email|max:255',
        ];

        // Validate request data against rules
        $validator = Validator::make($request->all(), $rules);

        // If validation fails, return error response
        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        // Update MinistryOfHealth model with request data
        $ministryOfHealth->name = $request->input('name');
        $ministryOfHealth->address = $request->input('address');
        $ministryOfHealth->phone_number = $request->input('phone_number');
        $ministryOfHealth->email = $request->input('email');
        $ministryOfHealth->save();

        // Return success response
        return response()->json(['message' => 'Ministry of Health updated successfully'], 200);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        // Retrieve the ministryOfHealth table record with the given ID
        $ministry = MinistryOfHealth::find($id);

        // Check if the ministryOfHealth table record exists
        if (!$ministry) {
            return response()->json([
                'status' => 'error',
                'message' => 'ministryOfHealth record record not found',
            ], 404);
        }

        // Delete the ministryOfHealth  record record
        $ministry->delete();

        // Return a success message
        return response()->json([
            'status' => 'success',
            'message' => 'ministryOfHealth  record record deleted successfully',
        ]);
    }
}

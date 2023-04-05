<?php

namespace App\Http\Controllers;

use App\Models\Location;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class LocationController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        //
        $location = Location::all();

        return response()->json([
            'status' => 'success',
            'message' => 'all locations record  retrieved successfully',
            'data' => $location,
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
    // validate the request data
    $validator = Validator::make($request->all(), [
        'location_name' => 'required|string|max:255',
        'latitude' => 'required|numeric',
        'longitude' => 'required|numeric',
    ]);

    if ($validator->fails()) {
        return response()->json([
            'status' => 'error',
            'errors' => $validator->errors(),
            'message' => 'Validation error',
        ], 422);
    }

    // create new location record
    $location = new Location();
    $location->location_name = $request->input('location_name');
    $location->latitude = $request->input('latitude');
    $location->longitude = $request->input('longitude');
    $location->save();

    return response()->json([
        'status' => 'success',
        'message' => 'Location created successfully',
        'data' => $location,
    ], 201);
}
    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $location = location::find($id);

        if (!$location) {
            return response()->json([
                'status' => 'error',
                'message' => 'location id not found',
            ], 404);
        } else {

            return response()->json([
                'status' => 'success',
                'message' => 'location id retrieved successfully',
                'data' => $location,
            ]);
        }
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
            // Retrieve the location record by ID
            $location = location::find($id);

            // Check if the record exists
            if (!$location) {
                // If the location record doesn't exist, return an error message
                return response()->json([
                    'status' => 'error',
                    'message' => 'location id record not found',
                ], 404);
            }
    
            // If the record exists, return the record data in JSON format with a success message
            return response()->json([
                'status' => 'success',
                'message' => 'location id record found',
                'data' => $location,
            ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        // validate the request data
        $validator = Validator::make($request->all(), [
            'location_name' => 'nullable|string',
            'latitude' => 'nullable|numeric',
            'longitude' => 'nullable|numeric',
        ]);
    
        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'errors' => $validator->errors(),
                'message' => 'validation error',
            ], 422);
        }
    
        // find the location by id
        $location = Location::find($id);
    
        if (!$location) {
            return response()->json([
                'status' => 'error',
                'message' => 'location not found',
            ], 404);
        }
    
        // update the location with the request data
        $location->update($request->all());
    
        // return the updated location object
        return response()->json([
            'status' => 'success',
            'message' => 'location updated successfully',
            'data' => $location,
        ], 200);
    }
    

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
         // Retrieve the location table record with the given ID
         $location = location::find($id);

         // Check if the location table record exists
         if (!$location) {
             return response()->json([
                 'status' => 'error',
                 'message' => 'location record record not found',
             ], 404);
         }
 
         // Delete the location  record record
         $location->delete();
 
         // Return a success message
         return response()->json([
             'status' => 'success',
             'message' => 'location  record record deleted successfully',
         ]);
    }
}

<?php

namespace App\Http\Controllers;

use App\Models\HealthCenter;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class HealthCenterController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        //
        $healthCentre= HealthCenter::all();

        return response()->json([
            'status' => 'success',
            'message' => 'all health centers record  retrieved successfully',
            'data' => $healthCentre,
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
            'phone_number' => 'nullable|string|max:20',
            'ministry_id' => 'nullable|integer|exists:ministries,id',
            'responsible_doctors' => 'nullable|string|max:255',
            'responsible_nurses' => 'nullable|string|max:255',
            'health_center_id' => 'nullable|integer|exists:HealthCenters,id',
            'nurse_id' => 'nullable|integer|exists:nurses,id',
            'doctor_id' => 'nullable|integer|exists:doctors,id',
        ];

        // Validate the request data using the rules defined above
        $validator = Validator::make($request->all(), $rules);

        // If the validation fails, return an error response
        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => 'Validation error',
                'errors' => $validator->errors(),
                'data' => [],
            ], 400);
        }

        // Create a new HealthCenter instance and fill it with the request data
        $healthCenter = new HealthCenter();
        $healthCenter->fill($request->all());

        // Save the new HealthCenter to the database
        $healthCenter->save();

        // Return a success response with the newly created HealthCenter instance
        return response()->json([
            'status' => 'success',
            'message' => 'Health center created successfully',
            'data' => $healthCenter,
        ]);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $healthCenter = healthCenter::find($id);

        if (!$healthCenter) {
            return response()->json([
                'status' => 'error',
                'message' => 'healthCenter id not found',
            ], 404);
        } else {

            return response()->json([
                'status' => 'success',
                'message' => 'healthCenter id retrieved successfully',
                'data' => $healthCenter,
            ]);
        }
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
            // Retrieve the healthCenter record by ID
            $healthCenter = healthCenter::find($id);

            // Check if the record exists
            if (!$healthCenter) {
                // If the healthCenter record doesn't exist, return an error message
                return response()->json([
                    'status' => 'error',
                    'message' => 'healthCenter id record not found',
                ], 404);
            }

            // If the record exists, return the record data in JSON format with a success message
            return response()->json([
                'status' => 'success',
                'message' => 'healthCenter id record found',
                'data' => $healthCenter,
            ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        // Retrieve the Health Center record by ID
        $healthCenter = HealthCenter::find($id);

        // Check if the record exists
        if (!$healthCenter) {
            return response()->json([
                'status' => 'error',
                'message' => 'Health Center record not found',
            ], 404);
        }

        // Validate the request data
        $validator = Validator::make($request->all(), [
            'name' => 'nullable|string',
            'address' => 'nullable|string',
            'phone_number' => 'nullable|string',
            'ministry_id' => 'nullable|integer|exists:ministries,id',
            'responsible_doctors' => 'nullable|string',
            'responsible_nurses' => 'nullable|string',
            'total_vaccinations' => 'nullable|integer',
            'total_positive_cases' => 'nullable|integer',
            'ministry_of_health_id' => 'nullable|integer|exists:ministries,id',
            'nurse_id' => 'nullable|integer|exists:nurses,id',
            'doctor_id' => 'nullable|integer|exists:doctors,id',
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

        // Update the Health Center record with the new data
        $healthCenter->update($data);

        return response()->json([
            'status' => 'success',
            'message' => 'Health Center record updated successfully',
            'data' => $healthCenter,
        ]);
    }


    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
         // Retrieve the healthCenter table record with the given ID
         $healthCenter = HealthCenter::find($id);

         // Check if the healthCenter table record exists
         if (!$healthCenter) {
             return response()->json([
                 'status' => 'error',
                 'message' => 'healthCenter record record not found',
             ], 404);
         }

         // Delete the healthCenter  record record
         $healthCenter->delete();

         // Return a success message
         return response()->json([
             'status' => 'success',
             'message' => 'healthCenter  record record deleted successfully',
         ]);
    }
}

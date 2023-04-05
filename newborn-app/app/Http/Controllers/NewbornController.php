<?php

namespace App\Http\Controllers;

use App\Models\Newborn;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class NewbornController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        //
        $newborn = Newborn::all();

        return response()->json([
            'status' => 'success',
            'message' => 'all newborns record  retrieved successfully',
            'data' => $newborn,
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
            'firstName' => 'required|string',
            'lastName' => 'required|string',
            'date_of_birth' => 'required|date',
            'gender' => 'required|in:Male,Female',
            'identity_number' => 'required|string|unique:newborns',
            'weight' => 'required|numeric',
            'length' => 'required|numeric',
            'status' => 'required|in:Normal,Abnormal',
            'delivery_method' => 'required|string',
            'mother_id' => 'required|exists:mothers,id',
            'location_id' => 'required|exists:locations,id',
            'health_center_id' => 'required|exists:health_centers,id',
            'hospital_center_id' => 'required|exists:hospitals,id',
            'measurement_id' => 'required|exists:measurements,id',
            'ministry_center_id' => 'required|exists:ministry_centers,id',
            'doctor_id' => 'required|exists:doctors,id',
            'nurse_id' => 'required|exists:nurses,id',
            'midwife_id' => 'required|exists:midwives,id',
            'newborn_hospital_nursery_id' => 'required|exists:newborn_hospital_nurseries,id',
        ]);

        // If validation fails, return error response
        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 400);
        }

        // Create a new newborn instance with the validated data
        $newborn = Newborn::create([
            'firstName' => $request->input('firstName'),
            'lastName' => $request->input('lastName'),
            'date_of_birth' => $request->input('date_of_birth'),
            'gender' => $request->input('gender'),
            'identity_number' => $request->input('identity_number'),
            'weight' => $request->input('weight'),
            'length' => $request->input('length'),
            'status' => $request->input('status'),
            'delivery_method' => $request->input('delivery_method'),
            'mother_id' => $request->input('mother_id'),
            'location_id' => $request->input('location_id'),
            'health_center_id' => $request->input('health_center_id'),
            'hospital_center_id' => $request->input('hospital_center_id'),
            'measurement_id' => $request->input('measurement_id'),
            'ministry_center_id' => $request->input('ministry_center_id'),
            'doctor_id' => $request->input('doctor_id'),
            'nurse_id' => $request->input('nurse_id'),
            'midwife_id' => $request->input('midwife_id'),
            'newborn_hospital_nursery_id' => $request->input('newborn_hospital_nursery_id'),
        ]);

        // Return success response with the created newborn instance
        return response()->json(['newborn' => $newborn], 201);
    }


    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $newborn = newborn::find($id);

        if (!$newborn) {
            return response()->json([
                'status' => 'error',
                'message' => 'newborn id not found',
            ], 404);
        } else {

            return response()->json([
                'status' => 'success',
                'message' => 'newborn id retrieved successfully',
                'data' => $newborn,
            ]);
        }
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
        // Retrieve the newborn record by ID
        $newborn = newborn::find($id);

        // Check if the record exists
        if (!$newborn) {
            // If the newborn record doesn't exist, return an error message
            return response()->json([
                'status' => 'error',
                'message' => 'newborn id record not found',
            ], 404);
        }

        // If the record exists, return the record data in JSON format with a success message
        return response()->json([
            'status' => 'success',
            'message' => 'newborn id record found',
            'data' => $newborn,
        ]);
    }

    /**
     * Update the specified resource in storage.
     */


    public function update(Request $request, $id)
    {
        $validator = Validator::make($request->all(), [
            'firstName' => 'nullable|string|max:255',
            'lastName' => 'nullable|string|max:255',
            'date_of_birth' => 'nullable|date',
            'gender' => 'nullable|in:Male,Female',
            'identity_number' => 'nullable|string|max:255',
            'weight' => 'nullable|numeric',
            'length' => 'nullable|numeric',
            'status' => 'nullable|in:Normal,Abnormal',
            'delivery_method' => 'nullable|string|max:255',
            'mother_id' => 'nullable|exists:mothers,id',
            'location_id' => 'nullable|exists:locations,id',
            'health_center_id' => 'nullable|exists:health_centers,id',
            'hospital_center_id' => 'nullable|exists:hospitals,id',
            'measurement_id' => 'nullable|exists:measurements,id',
            'ministry_center_id' => 'nullable|exists:ministry_centers,id',
            'doctor_id' => 'nullable|exists:doctors,id',
            'nurse_id' => 'nullable|exists:nurses,id',
            'midwife_id' => 'nullable|exists:midwives,id',
            'newborn_hospital_nursery_id' => 'nullable|exists:newborn_hospital_nurseries,id',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 400);
        }

        $newborn = Newborn::find($id);
        if (!$newborn) {
            return response()->json(['message' => 'Newborn not found'], 404);
        }

        $newborn->fill($request->all());
        $newborn->save();

        return response()->json(['message' => 'Newborn updated successfully'], 200);
    }


    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        // Retrieve the newborns table record with the given ID
        $newborn = Newborn::find($id);

        // Check if the newborns table record exists
        if (!$newborn) {
            return response()->json([
                'status' => 'error',
                'message' => 'newborn record record not found',
            ], 404);
        }

        // Delete the newborn record record
        $newborn->delete();

        // Return a success message
        return response()->json([
            'status' => 'success',
            'message' => 'newborn record record deleted successfully',
        ]);
    }
}

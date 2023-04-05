<?php

namespace App\Http\Controllers;

use App\Models\Mother;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class MotherController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        //
        $mother = Mother::all();

        return response()->json([
            'status' => 'success',
            'message' => 'all mothers record  retrieved successfully',
            'data' => $mother,
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
            'first_name' => 'required|string|max:255',
            'last_name' => 'required|string|max:255',
            'address' => 'nullable|string|max:255',
            'phone_number' => 'nullable|string|max:255',
            'email' => 'nullable|email|max:255',
            'date_of_birth' => 'nullable|date',
            'husband_name' => 'nullable|string|max:255',
            'identity_number' => 'nullable|string|max:255',
            'husband_phone_number' => 'nullable|string|max:255',
            'number_of_newborns' => 'nullable|integer|min:0',
            'city' => 'nullable|string|max:255',
            'country' => 'nullable|string|max:255',
            'blood_type' => 'nullable|string|max:255',
            'HR' => 'nullable|string|max:255',
            'location_id' => 'nullable|exists:locations,id',
            'newborn_id' => 'nullable|exists:newborns,id',
            'health_center_id' => 'nullable|exists:health_centers,id',
            'hospital_center_id' => 'nullable|exists:hospital_centers,id',
            'guideline_id' => 'nullable|exists:guidelines,id',
            'doctor_id' => 'nullable|exists:doctors,id',
            'nurse_id' => 'nullable|exists:nurses,id',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $mother = new Mother();
        $mother->first_name = $request->input('first_name');
        $mother->last_name = $request->input('last_name');
        $mother->address = $request->input('address');
        $mother->phone_number = $request->input('phone_number');
        $mother->email = $request->input('email');
        $mother->date_of_birth = $request->input('date_of_birth');
        $mother->husband_name = $request->input('husband_name');
        $mother->identity_number = $request->input('identity_number');
        $mother->husband_phone_number = $request->input('husband_phone_number');
        $mother->number_of_newborns = $request->input('number_of_newborns', 0);
        $mother->city = $request->input('city');
        $mother->country = $request->input('country');
        $mother->blood_type = $request->input('blood_type');
        $mother->HR = $request->input('HR');
        $mother->location_id = $request->input('location_id');
        $mother->newborn_id = $request->input('newborn_id');
        $mother->health_center_id = $request->input('health_center_id');
        $mother->hospital_center_id = $request->input('hospital_center_id');
        $mother->guideline_id = $request->input('guideline_id');
        $mother->doctor_id = $request->input('doctor_id');
        $mother->nurse_id = $request->input('nurse_id');
        $mother->save();

        return response()->json(['mother' => $mother], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $mother = mother::find($id);

        if (!$mother) {
            return response()->json([
                'status' => 'error',
                'message' => 'mother id not found',
            ], 404);
        } else {

            return response()->json([
                'status' => 'success',
                'message' => 'mother id retrieved successfully',
                'data' => $mother,
            ]);
        }
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
        // Retrieve the mother record by ID
        $mother = mother::find($id);

        // Check if the record exists
        if (!$mother) {
            // If the mother record doesn't exist, return an error message
            return response()->json([
                'status' => 'error',
                'message' => 'mother id record not found',
            ], 404);
        }

        // If the record exists, return the record data in JSON format with a success message
        return response()->json([
            'status' => 'success',
            'message' => 'mother id record found',
            'data' => $mother,
        ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        $validator = Validator::make($request->all(), [
            'first_name' => 'nullable|string|max:255',
            'last_name' => 'nullable|string|max:255',
            'address' => 'nullable|string|max:255',
            'phone_number' => 'nullable|string|max:255',
            'email' => 'nullable|email|max:255',
            'date_of_birth' => 'nullable|date',
            'husband_name' => 'nullable|string|max:255',
            'identity_number' => 'nullable|string|max:255',
            'husband_phone_number' => 'nullable|string|max:255',
            'number_of_newborns' => 'nullable|integer|min:0',
            'city' => 'nullable|string|max:255',
            'country' => 'nullable|string|max:255',
            'blood_type' => 'nullable|string|max:255',
            'HR' => 'nullable|string|max:255',
            'location_id' => 'nullable|exists:locations,id',
            'newborn_id' => 'nullable|exists:newborns,id',
            'health_center_id' => 'nullable|exists:health_centers,id',
            'hospital_center_id' => 'nullable|exists:hospital_centers,id',
            'guideline_id' => 'nullable|exists:guidelines,id',
            'doctor_id' => 'nullable|exists:doctors,id',
            'nurse_id' => 'nullable|exists:nurses,id',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $mother = Mother::findOrFail($id);
        $mother->first_name = $request->input('first_name', $mother->first_name);
        $mother->last_name = $request->input('last_name', $mother->last_name);
        $mother->address = $request->input('address', $mother->address);
        $mother->phone_number = $request->input('phone_number', $mother->phone_number);
        $mother->email = $request->input('email', $mother->email);
        $mother->date_of_birth = $request->input('date_of_birth', $mother->date_of_birth);
        $mother->husband_name = $request->input('husband_name', $mother->husband_name);
        $mother->identity_number = $request->input('identity_number', $mother->identity_number);
        $mother->husband_phone_number = $request->input('husband_phone_number', $mother->husband_phone_number);
        $mother->number_of_newborns = $request->input('number_of_newborns', $mother->number_of_newborns);
        $mother->city = $request->input('city', $mother->city);
        $mother->country = $request->input('country', $mother->country);
        $mother->blood_type = $request->input('blood_type', $mother->blood_type);
        $mother->HR = $request->input('HR', $mother->HR);
        $mother->location_id = $request->input('location_id', $mother->location_id);
        $mother->newborn_id = $request->input('newborn_id', $mother->newborn_id);
        $mother->health_center_id = $request->input('health_center_id', $mother->health_center_id);
        $mother->hospital_center_id = $request->input('hospital_center_id', $mother->hospital_center_id);
        $mother->guideline_id = $request->input('guideline_id', $mother->guideline_id);
        $mother->doctor_id = $request->input('doctor_id', $mother->doctor_id);
        $mother->nurse_id = $request->input('nurse_id', $mother->nurse_id);

        $mother->save();

        return response()->json(['message' => 'Mother updated successfully'], 200);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        // Retrieve the mother table record with the given ID
        $mother = Mother::find($id);

        // Check if the mother table record exists
        if (!$mother) {
            return response()->json([
                'status' => 'error',
                'message' => 'mother record record not found',
            ], 404);
        }

        // Delete the mother  record record
        $mother->delete();

        // Return a success message
        return response()->json([
            'status' => 'success',
            'message' => 'mother  record record deleted successfully',
        ]);
    }
}

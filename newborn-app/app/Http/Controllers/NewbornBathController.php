<?php

namespace App\Http\Controllers;

use App\Models\Midwife;
use App\Models\Newborn;
use App\Models\Newborn_bath;
use App\Models\Nurse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class NewbornBathController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        //
        $newbornBath = Newborn_bath::all();

        return response()->json([
            'status' => 'success',
            'message' => 'all newborn baths record  retrieved successfully',
            'data' => $newbornBath,
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
            'newborn_id' => 'nullable|exists:newborns,id',
            'midwife_id' => 'nullable|exists:midwives,id',
            'nurse_id' => 'nullable|exists:nurses,id',
            'bath_date' => 'nullable|date',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => 'Validation error',
                'errors' => $validator->errors(),
            ], 400);
        }

        $newbornBath = Newborn_bath::create($request->all());

        if ($request->has('newborn_id')) {
            $newbornBath->newborn()->associate(Newborn::find($request->input('newborn_id')));
        }

        if ($request->has('midwife_id')) {
            $newbornBath->midwife()->associate(Midwife::find($request->input('midwife_id')));
        }

        if ($request->has('nurse_id')) {
            $newbornBath->nurse()->associate(Nurse::find($request->input('nurse_id')));
        }

        $newbornBath->save();

        return response()->json([
            'status' => 'success',
            'message' => 'Newborn bath record created successfully',
            'data' => $newbornBath,
        ], 201);
    }


    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $newbornBath = newborn_bath::find($id);

        if (!$newbornBath) {
            return response()->json([
                'status' => 'error',
                'message' => 'newbornBath id not found',
            ], 404);
        } else {

            return response()->json([
                'status' => 'success',
                'message' => 'newbornBath id retrieved successfully',
                'data' => $newbornBath,
            ]);
        }
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
        // Retrieve the newbornBath record by ID
        $newbornBath = newborn_bath::find($id);

        // Check if the record exists
        if (!$newbornBath) {
            // If the newbornBath record doesn't exist, return an error message
            return response()->json([
                'status' => 'error',
                'message' => 'newbornBath id record not found',
            ], 404);
        }

        // If the record exists, return the record data in JSON format with a success message
        return response()->json([
            'status' => 'success',
            'message' => 'newbornBath id record found',
            'data' => $newbornBath,
        ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        // Retrieve the NewbornBath record by ID
        $newbornBath = Newborn_bath::find($id);

        // Check if the record exists
        if (!$newbornBath) {
            return response()->json([
                'status' => 'error',
                'message' => 'NewbornBath record not found',
            ], 404);
        }

        // Validate the request data
        $validator = Validator::make($request->all(), [
            'newborn_id' => 'nullable|integer|exists:newborns,id',
            'midwife_id' => 'nullable|integer|exists:midwives,id',
            'nurse_id' => 'nullable|integer|exists:nurses,id',
            'bath_date' => 'nullable|date',
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

        // Update the NewbornBath record with the new data
        $newbornBath->update($data);

        return response()->json([
            'status' => 'success',
            'message' => 'NewbornBath record updated successfully',
            'data' => $newbornBath,
        ]);
    }


    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        // Retrieve the newborn Bath table record with the given ID
        $newbornBath = Newborn_bath::find($id);

        // Check if the newborn Bath table record exists
        if (!$newbornBath) {
            return response()->json([
                'status' => 'error',
                'message' => 'newborn Bath record record not found',
            ], 404);
        }

        // Delete the newborn Bath record record
        $newbornBath->delete();

        // Return a success message
        return response()->json([
            'status' => 'success',
            'message' => 'newborn Bath record record deleted successfully',
        ]);
    }
}

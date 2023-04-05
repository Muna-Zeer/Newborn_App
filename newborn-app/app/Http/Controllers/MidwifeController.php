<?php

namespace App\Http\Controllers;

use App\Models\Midwife;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class MidwifeController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        //
        $midwife = Midwife::all();

        return response()->json([
            'status' => 'success',
            'message' => 'all midwives record  retrieved successfully',
            'data' => $midwife,
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
            'name' => 'required|string',
            'hours' => 'required|integer',
            'salary' => 'required|integer',
            'communication_skills' => 'nullable|string',
            'period' => 'required|in:night,morning',
            'mother_name' => 'nullable|string',
            'newborn_bracelet_hand' => 'nullable|string',
            'newborn_bracelet_leg' => 'nullable|string',
            'report' => 'nullable|string',
            'doctor_id' => 'nullable|exists:doctors,id',
            'newborn_id' => 'nullable|exists:newborns,id',
            'mother_id' => 'nullable|exists:mothers,id',
            'hospital_center_id' => 'nullable|exists:hospital_centers,id',
        ]);
    
        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => $validator->errors()
            ], 422);
        }
    
        // create a new midwife instance
        $midwife = new Midwife;
        $midwife->name = $request->input('name');
        $midwife->hours = $request->input('hours');
        $midwife->salary = $request->input('salary');
        $midwife->communication_skills = $request->input('communication_skills');
        $midwife->period = $request->input('period');
        $midwife->mother_name = $request->input('mother_name');
        $midwife->newborn_bracelet_hand = $request->input('newborn_bracelet_hand');
        $midwife->newborn_bracelet_leg = $request->input('newborn_bracelet_leg');
        $midwife->report = $request->input('report');
        $midwife->doctor_id = $request->input('doctor_id');
        $midwife->newborn_id = $request->input('newborn_id');
        $midwife->mother_id = $request->input('mother_id');
        $midwife->hospital_center_id = $request->input('hospital_center_id');
    
        // save the midwife instance to the database
        $midwife->save();
    
        return response()->json([
            'success' => true,
            'message' => 'Midwife created successfully',
            'data' => $midwife
        ], 200);
    }
    

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $midwife = midwife::find($id);

        if (!$midwife) {
            return response()->json([
                'status' => 'error',
                'message' => 'midwife id not found',
            ], 404);
        } else {

            return response()->json([
                'status' => 'success',
                'message' => 'midwife id retrieved successfully',
                'data' => $midwife,
            ]);
        }
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
            // Retrieve the midwife record by ID
            $midwife = midwife::find($id);

            // Check if the record exists
            if (!$midwife) {
                // If the midwife record doesn't exist, return an error message
                return response()->json([
                    'status' => 'error',
                    'message' => 'midwife id record not found',
                ], 404);
            }
    
            // If the record exists, return the record data in JSON format with a success message
            return response()->json([
                'status' => 'success',
                'message' => 'midwife id record found',
                'data' => $midwife,
            ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string',
            'hours' => 'required|integer|min:1',
            'salary' => 'required|integer|min:1',
            'communication_skills' => 'required|string',
            'period' => 'required|in:night,morning',
            'mother_name' => 'required|string',
            'newborn_bracelet_hand' => 'required|string',
            'newborn_bracelet_leg' => 'required|string',
            'report' => 'nullable|string',
            'doctor_id' => 'nullable|exists:doctors,id',
            'newborn_id' => 'nullable|exists:newborns,id',
            'mother_id' => 'nullable|exists:mothers,id',
            'hospital_center_id' => 'nullable|exists:hospital_centers,id',
        ]);
    
        if ($validator->fails()) {
            return response()->json(['error' => $validator->errors()], 400);
        }
    
        $midwife = Midwife::find($id);
        if (!$midwife) {
            return response()->json(['error' => 'Midwife not found.'], 404);
        }
    
        $midwife->name = $request->input('name');
        $midwife->hours = $request->input('hours');
        $midwife->salary = $request->input('salary');
        $midwife->communication_skills = $request->input('communication_skills');
        $midwife->period = $request->input('period');
        $midwife->mother_name = $request->input('mother_name');
        $midwife->newborn_bracelet_hand = $request->input('newborn_bracelet_hand');
        $midwife->newborn_bracelet_leg = $request->input('newborn_bracelet_leg');
        $midwife->report = $request->input('report');
        $midwife->doctor_id = $request->input('doctor_id');
        $midwife->newborn_id = $request->input('newborn_id');
        $midwife->mother_id = $request->input('mother_id');
        $midwife->hospital_center_id = $request->input('hospital_center_id');
    
        $midwife->save();
    
        return response()->json(['message' => 'Midwife updated successfully.'], 200);
    }
    

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
         // Retrieve the midwife table record with the given ID
         $midwife = midwife::find($id);

         // Check if the midwife table record exists
         if (!$midwife) {
             return response()->json([
                 'status' => 'error',
                 'message' => 'midwife record record not found',
             ], 404);
         }
 
         // Delete the midwife  record record
         $midwife->delete();
 
         // Return a success message
         return response()->json([
             'status' => 'success',
             'message' => 'midwife  record record deleted successfully',
         ]);
    }
}

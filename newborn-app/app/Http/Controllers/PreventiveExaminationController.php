<?php

namespace App\Http\Controllers;

use App\Models\Newborn;
use App\Models\PreventiveExamination;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class PreventiveExaminationController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        //
        $preventiveExaminations = PreventiveExamination::all();

        return response()->json([
            'status' => 'success',
            'message' => 'Preventive examinations retrieved successfully',
            'data' => $preventiveExaminations,
        ]);
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
    }



    public function storePreventiveExamination(Request $request)
    {
        //validate the request data
        $validator = Validator::make($request->all(), [
            'exam_type' => 'nullable|string',
            'date' => 'nullable|date',
          'time' => 'nullable|string',
            'ministry_id' => 'nullable|integer|exists:ministryofhealths,id',

        ]);
        //check if the validations fail
        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => $validator->errors(),
                'data' => [],
            ], 400);
        }

        //create the preventive examination record
        $preventiveExamination = new PreventiveExamination();
        $preventiveExamination->exam_type = $request->input('exam_type');
        $preventiveExamination->date = $request->input('date');
        $preventiveExamination->time = date('H:i:s', strtotime($request->input('time'))); // Convert time string to valid format

        $preventiveExamination->result = $request->input('result');
        $preventiveExamination->ministry_id = $request->input('ministry_id');
        //save the preventive examination record
        $preventiveExamination->save();
        // Retrieve the newly created preventive examination record with its associated models
        $preventiveExamination = PreventiveExamination::with(['ministry', 'nurse'])->findOrFail($preventiveExamination->id);
        return response()->json([
            'status' => 'success',
            'message' => 'preventive examination record created successfully',
            'data' => $preventiveExamination,
        ], 201);
    }



    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        // Validate the request data
        $validator = Validator::make($request->all(), [
            'exam_type' => 'nullable|string',
            'date' => 'nullable|date',
            'time' => 'nullable|date_format:HH:mm:ss',
            'result' => 'nullable|string',
            'newborn_id' => 'required|integer|exists:newborns,id',
            'health_center_id' => 'nullable|integer|exists:HealthCenters,id',
            'ministry_id' => 'nullable|integer|exists:ministryofhealths,id',
            'nurse_id' => 'nullable|integer|exists:nurses,id',
        ]);

        // Check if the validations fail
        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => $validator->errors(),
                'data' => [],
            ], 400);
        }

        // Create the preventive examination record
        $preventiveExamination = new PreventiveExamination();
        $preventiveExamination->exam_type = $request->input('exam_type');
        $preventiveExamination->date = $request->input('date');
        $preventiveExamination->time = $request->input('time');
        $preventiveExamination->result = $request->input('result');
        $preventiveExamination->health_center_id = $request->input('health_center_id');
        $preventiveExamination->ministry_id = $request->input('ministry_id');
        $preventiveExamination->nurse_id = $request->input('nurse_id');

        // Assign the newborn_id by setting the foreign key directly
        $preventiveExamination->newborn_id = $request->input('newborn_id');

        // Save the preventive examination record
        $preventiveExamination->save();

        // Retrieve the newly created preventive examination record with its associated models
        $preventiveExamination = PreventiveExamination::with(['newborn', 'hospital', 'healthCenter', 'ministry', 'nurse'])
            ->findOrFail($preventiveExamination->id);

        return response()->json([
            'status' => 'success',
            'message' => 'preventive examination record created successfully',
            'data' => $preventiveExamination,
        ], 201);
    }


    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        //
        $preventiveExamination = PreventiveExamination::find($id);

        if (!$preventiveExamination) {
            return response()->json([
                'status' => 'error',
                'message' => 'Preventive examination not found',
            ], 404);
        } else {

            return response()->json([
                'status' => 'success',
                'message' => 'Preventive examination retrieved successfully',
                'data' => $preventiveExamination,
            ]);
        }
    }








    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
        //
        // Retrieve the PreventiveExamination record by ID
        $preventiveExamination = PreventiveExamination::find($id);
        if (!$preventiveExamination) {
            return response()->json(

                [
                    'status' => 'error',
                    'message' => 'preventive examination records not found',
                ],
                404
            );
        }
        return response()->json([
            'status' => 'success',
            'message' => 'preventive examination record found',
            'data' => $preventiveExamination,

        ], 200);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        //
        // Retrieve the PreventiveExamination record by ID
        $preventiveExamination = PreventiveExamination::find($id);

        // Check if the record exists
        if (!$preventiveExamination) {
            return response()->json([
                'status' => 'error',
                'message' => 'Preventive Examination record not found',
            ], 404);
        }

        // Validate the request data
        $validator = Validator::make($request->all(), [
            'exam_type' => 'nullable|string',
            'date' => 'nullable|date',
          'time' => 'nullable|string',

            'result' => 'nullable|string',
            'newborn_id' => 'nullable|integer|exists:newborns,id',
            'hospital_id' => 'nullable|integer|exists:hospitals,id',
            'health_center_id' => 'nullable|integer|exists:health_centers,id',
            'ministry_id' => 'nullable|integer|exists:ministryofhealths,id',
            'nurse_id' => 'nullable|integer|exists:nurses,id',
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

        // Update the PreventiveExamination record with the validated data
        if ($preventiveExamination->update($request->all())) {
            return response()->json([
                'status' => 'success',
                'message' => 'Preventive Examination record updated successfully',
                'data' => $preventiveExamination,
            ]);
        } else {
            return response()->json([
                'status' => 'error',
                'message' => 'Failed to update Preventive Examination record',
            ], 500); // Internal Server Error
        }

    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {

        // Retrieve the PreventiveExamination record by ID
        $preventiveExamination = PreventiveExamination::find($id);

        // Check if the record exists
        if (!$preventiveExamination) {
            return response()->json([
                'status' => 'error',
                'message' => 'Preventive Examination record not found',
            ], 404);
        }

        // Delete the record
        $preventiveExamination->delete();

        // Return a success message
        return response()->json([
            'status' => 'success',
            'message' => 'Preventive Examination record deleted successfully',
        ]);
    }
}

<?php

namespace App\Http\Controllers;

use App\Models\newborn_examination;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class NewbornExaminationController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        //
        $newbornExamination = newborn_examination::all();

        return response()->json([
            'status' => 'success',
            'message' => 'all newborn  examination record  retrieved successfully',
            'data' => $newbornExamination,
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
            'Sex' => 'nullable|in:Female,Male',
            'Birth_outcome' => 'nullable|in:Alive,Abortion,Stillbirth,Late_Neonatal,Early_Neonatal',
            'H_C' => 'nullable|string',
            'Length' => 'nullable|string',
            'Weight_gr' => 'nullable|string',
            'Pulse' => 'nullable|string',
            'Temp' => 'nullable|string',
            'Respiratory_Rate' => 'nullable|string',
            'Apgar_score' => 'nullable|numeric|min:0|max:10',
            'breastfeeding_ft' => 'nullable|string',
            'Congenital_Malformation' => 'nullable|string',
            'Medication' => 'nullable|string',
            'vaccine_id' => 'nullable|integer|exists:vaccination_tabels,id',
            'Complication_after_birth' => 'nullable|string',
            'Diagnosis' => 'nullable|string',
            'Referred' => 'nullable|string',
            'doctor_id' => 'nullable|integer|exists:doctors,id',
            'midwife_id' => 'nullable|integer|exists:midwives,id',
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
    
        // Create the NewbornExamination record with the request data
        $newbornExamination = newborn_examination::create($request->all());
    
        // Associate related models if provided
        if ($request->has('vaccine_id')) {
            $newbornExamination->vaccine()->associate($request->input('vaccine_id'));
        }
    
        if ($request->has('doctor_id')) {
            $newbornExamination->doctor()->associate($request->input('doctor_id'));
        }
    
        if ($request->has('midwife_id')) {
            $newbornExamination->midwife()->associate($request->input('midwife_id'));
        }
    
        if ($request->has('nurse_id')) {
            $newbornExamination->nurse()->associate($request->input('nurse_id'));
        }
    
        // Save the changes
        $newbornExamination->save();
    
        return response()->json([
            'status' => 'success',
            'message' => 'Newborn Examination record created successfully',
            'data' => $newbornExamination,
        ]);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $newbornExamination = newborn_examination::find($id);

        if (!$newbornExamination) {
            return response()->json([
                'status' => 'error',
                'message' => 'newbornExamination id not found',
            ], 404);
        } else {

            return response()->json([
                'status' => 'success',
                'message' => 'newbornExamination id retrieved successfully',
                'data' => $newbornExamination,
            ]);
        }
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
        // Retrieve the newbornExamination record by ID
        $newbornExamination = newborn_examination::find($id);

        // Check if the record exists
        if (!$newbornExamination) {
            // If the newbornExamination record doesn't exist, return an error message
            return response()->json([
                'status' => 'error',
                'message' => 'newbornExamination id record not found',
            ], 404);
        }

        // If the record exists, return the record data in JSON format with a success message
        return response()->json([
            'status' => 'success',
            'message' => 'newbornExamination id record found',
            'data' => $newbornExamination,
        ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        // Retrieve the NewbornExamination record by ID
        $newbornExamination = newborn_examination::find($id);
    
        // Check if the record exists
        if (!$newbornExamination) {
            return response()->json([
                'status' => 'error',
                'message' => 'Newborn Examination record not found',
            ], 404);
        }
    
        // Define the validation rules for the request data
        $rules = [
            'Sex' => 'nullable|in:Female,Male',
            'Birth_outcome' => 'nullable|in:Alive,Abortion,Stillbirth,Late_Neonatal,Early_Neonatal',
            'H_C' => 'nullable|string',
            'Length' => 'nullable|string',
            'Weight_gr' => 'nullable|string',
            'Pulse' => 'nullable|string',
            'Temp' => 'nullable|string',
            'Respiratory_Rate' => 'nullable|string',
            'Apgar_score' => 'nullable|numeric|between:0,10',
            'breastfeeding_ft' => 'nullable|string',
            'Congenital_Malformation' => 'nullable|string',
            'Medication' => 'nullable|string',
            'vaccine_id' => 'nullable|integer|exists:vaccination_tabels,id',
            'Complication_after_birth' => 'nullable|string',
            'Diagnosis' => 'nullable|string',
            'Referred' => 'nullable|string',
            'doctor_id' => 'nullable|integer|exists:doctors,id',
            'midwife_id' => 'nullable|integer|exists:midwives,id',
            'nurse_id' => 'nullable|integer|exists:nurses,id',
        ];
    
        // Create a validator instance with the request data and validation rules
        $validator = Validator::make($request->all(), $rules);
    
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
    
        // Update the NewbornExamination record with the new data
        $newbornExamination->update($data);
    
        return response()->json([
            'status' => 'success',
            'message' => 'Newborn Examination record updated successfully',
            'data' => $newbornExamination,
        ]);
    }
    

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        // Retrieve the newborn examination table record with the given ID
        $newborn = newborn_examination::find($id);

        // Check if the newborn examination table record exists
        if (!$newborn) {
            return response()->json([
                'status' => 'error',
                'message' => 'newborn examination record record not found',
            ], 404);
        }

        // Delete the newborn examination record record
        $newborn->delete();

        // Return a success message
        return response()->json([
            'status' => 'success',
            'message' => 'newborn examination record record deleted successfully',
        ]);
    }
}

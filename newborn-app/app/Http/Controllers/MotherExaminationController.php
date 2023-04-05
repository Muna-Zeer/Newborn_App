<?php

namespace App\Http\Controllers;

use App\Models\Doctor;
use App\Models\Midwife;
use App\Models\mother_examination;
use App\Models\Nurse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class MotherExaminationController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        //
        $motherExamination = mother_examination::all();

        return response()->json([
            'status' => 'success',
            'message' => 'all mother examination record  retrieved successfully',
            'data' => $motherExamination,
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
            'name_of_mother' => 'required|string',
            'age' => 'nullable|integer|min:1|max:120',
            'place_of_birth' => 'nullable|string',
            'time_of_delivery' => 'nullable|date_format:H:i',
            'date_of_delivery' => 'nullable|date',
            'weeks_of_pregnancy' => 'nullable|integer|min:1|max:50',
            'method_of_delivery' => 'required|string',
            'Episiotomy' => 'nullable|boolean',
            'Perineal_Tear' => 'nullable|string',
            'Bleeding_after_delivery' => 'nullable|boolean',
            'Blood_transfusion' => 'nullable|boolean',
            'Temp' => 'nullable|string',
            'B_P' => 'nullable|string',
            'Complication_after_delivery' => 'nullable|string',
            'Diagnosis' => 'nullable|string',
            'Referred' => 'nullable|string',
            'doctor_id' => 'nullable|exists:doctors,id',
            'midwife_id' => 'nullable|exists:midwives,id',
            'nurse_id' => 'nullable|exists:nurses,id',
        ]);
    
        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 400);
        }
    
        $motherExamination = new mother_examination();
        $motherExamination->name_of_mother = $request->input('name_of_mother');
        $motherExamination->age = $request->input('age');
        $motherExamination->place_of_birth = $request->input('place_of_birth');
        $motherExamination->time_of_delivery = $request->input('time_of_delivery');
        $motherExamination->date_of_delivery = $request->input('date_of_delivery');
        $motherExamination->weeks_of_pregnancy = $request->input('weeks_of_pregnancy');
        $motherExamination->method_of_delivery = $request->input('method_of_delivery');
        $motherExamination->Episiotomy = $request->input('Episiotomy');
        $motherExamination->Perineal_Tear = $request->input('Perineal_Tear');
        $motherExamination->Bleeding_after_delivery = $request->input('Bleeding_after_delivery');
        $motherExamination->Blood_transfusion = $request->input('Blood_transfusion');
        $motherExamination->Temp = $request->input('Temp');
        $motherExamination->B_P = $request->input('B_P');
        $motherExamination->Complication_after_delivery = $request->input('Complication_after_delivery');
        $motherExamination->Diagnosis = $request->input('Diagnosis');
        $motherExamination->Referred = $request->input('Referred');
        $motherExamination->doctor_id = $request->input('doctor_id');
        $motherExamination->midwife_id = $request->input('midwife_id');
        $motherExamination->nurse_id = $request->input('nurse_id');
    
          // Connect the associations
    if ($request->filled('doctor_id')) {
        $doctor = Doctor::find($request->doctor_id);
        if ($doctor) {
            $motherExamination->doctor()->associate($doctor);
        }
    }

    if ($request->filled('midwife_id')) {
        $midwife = Midwife::find($request->midwife_id);
        if ($midwife) {
            $motherExamination->midwife()->associate($midwife);
        }
    }

    if ($request->filled('nurse_id')) {
        $nurse = Nurse::find($request->nurse_id);
        if ($nurse) {
            $motherExamination->nurse()->associate($nurse);
        }
    }

        $motherExamination->save();
    
        return response()->json(['data' => $motherExamination], 201);
    }
    

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $motherExamination = mother_examination::find($id);

        if (!$motherExamination) {
            return response()->json([
                'status' => 'error',
                'message' => 'motherExamination id not found',
            ], 404);
        } else {

            return response()->json([
                'status' => 'success',
                'message' => 'motherExamination id retrieved successfully',
                'data' => $motherExamination,
            ]);
        }
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
     // Retrieve the motherExamination record by ID
     $motherExamination = mother_examination::find($id);

     // Check if the record exists
     if (!$motherExamination) {
         // If the motherExamination record doesn't exist, return an error message
         return response()->json([
             'status' => 'error',
             'message' => 'motherExamination id record not found',
         ], 404);
     }

     // If the record exists, return the record data in JSON format with a success message
     return response()->json([
         'status' => 'success',
         'message' => 'motherExamination id record found',
         'data' => $motherExamination,
     ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
{
    // Retrieve the MotherExamination record by ID
    $motherExamination = mother_examination::find($id);

    // Check if the record exists
    if (!$motherExamination) {
        return response()->json([
            'status' => 'error',
            'message' => 'Mother Examination record not found',
        ], 404);
    }

    // Validate the request data
    $validator = Validator::make($request->all(), [
        'name_of_mother' => 'nullable|string',
        'age' => 'nullable|integer',
        'place_of_birth' => 'nullable|in:Home,Clinic,Hospital,Other',
        'time_of_delivery' => 'nullable|date_format:H:i:s',
        'date_of_delivery' => 'nullable|date',
        'weeks_of_pregnancy' => 'nullable|integer',
        'method_of_delivery' => 'nullable|in:Normal,Vaccum,Forceps,C.S',
        'Episiotomy' => 'nullable|boolean',
        'Perineal_Tear' => 'nullable|in:grade1,grade2,grade3,grade4',
        'Bleeding_after_delivery' => 'nullable|boolean',
        'Blood_transfusion' => 'nullable|boolean',
        'Temp' => 'nullable|string',
        'B_P' => 'nullable|string',
        'Complication_after_delivery' => 'nullable|string',
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

    // Update the MotherExamination record with the new data
    $motherExamination->update($request->all());

    return response()->json([
        'status' => 'success',
        'message' => 'Mother Examination record updated successfully',
        'data' => $motherExamination,
    ]);
}

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
                     // Retrieve the mother_examination table record with the given ID
                     $motherExamination = mother_examination::find($id);

                     // Check if the mother_examination table record exists
                     if (!$motherExamination) {
                         return response()->json([
                             'status' => 'error',
                             'message' => 'mother examination record record not found',
                         ], 404);
                     }
             
                     // Delete the mother_examination record record
                     $motherExamination->delete();
             
                     // Return a success message
                     return response()->json([
                         'status' => 'success',
                         'message' => 'mother examination record record deleted successfully',
                     ]);
                 
    }
}

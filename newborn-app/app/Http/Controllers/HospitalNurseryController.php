<?php

namespace App\Http\Controllers;

use App\Models\Doctor;
use App\Models\Hospital;
use App\Models\Midwife;
use App\Models\Newborn;
use App\Models\Newborn_bath;
use App\Models\newborn_hospital_nursery;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class HospitalNurseryController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        //
        $nursery =newborn_hospital_nursery::all();

        return response()->json([
            'status' => 'success',
            'message' => 'all nurseries record  retrieved successfully',
            'data' => $nursery,
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
            'hospital_center_id' => 'nullable|exists:hospitals,id',
            'admission_date' => 'nullable|date',
            'discharge_date' => 'nullable|date|after:admission_date',
            'doctor_id' => 'nullable|exists:doctors,id',
            'midwife_id' => 'nullable|exists:midwives,id',
            'newborn_bath_id' => 'nullable|exists:newborn_baths,id',
        ]);
    
        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => 'Validation error',
                'errors' => $validator->errors(),
            ], 400);
        }
    
        $newbornHospitalNursery = newborn_hospital_nursery::create($request->all());
    
        if ($request->has('newborn_id')) {
            $newbornHospitalNursery->newborn()->associate(Newborn::find($request->input('newborn_id')));
        }
    
        if ($request->has('hospital_center_id')) {
            $newbornHospitalNursery->hospitalCenter()->associate(Hospital::find($request->input('hospital_center_id')));
        }
    
        if ($request->has('doctor_id')) {
            $newbornHospitalNursery->doctor()->associate(Doctor::find($request->input('doctor_id')));
        }
    
        if ($request->has('midwife_id')) {
            $newbornHospitalNursery->midwife()->associate(Midwife::find($request->input('midwife_id')));
        }
    
        if ($request->has('newborn_bath_id')) {
            $newbornHospitalNursery->newbornBath()->associate(Newborn_bath::find($request->input('newborn_bath_id')));
        }
    
        $newbornHospitalNursery->save();
    
        return response()->json([
            'status' => 'success',
            'message' => 'Newborn hospital nursery record created successfully',
            'data' => $newbornHospitalNursery,
        ], 201);
    }
    
    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $hospitalNursery = newborn_hospital_nursery::find($id);

        if (!$hospitalNursery) {
            return response()->json([
                'status' => 'error',
                'message' => 'hospitalNursery id not found',
            ], 404);
        } else {

            return response()->json([
                'status' => 'success',
                'message' => 'hospitalNursery id retrieved successfully',
                'data' => $hospitalNursery,
            ]);
        }
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
            // Retrieve the hospitalNursery record by ID
            $hospitalNursery = newborn_hospital_nursery::find($id);

            // Check if the record exists
            if (!$hospitalNursery) {
                // If the hospitalNursery record doesn't exist, return an error message
                return response()->json([
                    'status' => 'error',
                    'message' => 'hospitalNursery id record not found',
                ], 404);
            }
    
            // If the record exists, return the record data in JSON format with a success message
            return response()->json([
                'status' => 'success',
                'message' => 'hospitalNursery id record found',
                'data' => $hospitalNursery,
            ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        // Retrieve the NewbornHospitalNurseries record by ID
        $nursery = newborn_hospital_nursery::find($id);
    
        // Check if the record exists
        if (!$nursery) {
            return response()->json([
                'status' => 'error',
                'message' => 'Newborn Hospital Nursery record not found',
            ], 404);
        }
    
        // Validate the request data
        $validator = Validator::make($request->all(), [
            'newborn_id' => 'nullable|integer|exists:newborns,id',
            'hospital_center_id' => 'nullable|integer|exists:hospitals,id',
            'admission_date' => 'nullable|date',
            'discharge_date' => 'nullable|date|after:admission_date',
            'midwife_id' => 'nullable|integer|exists:midwives,id',
            'doctor_id' => 'nullable|integer|exists:doctors,id',
            'newborn_bath_id' => 'nullable|integer|exists:newborn_baths,id',
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
    
        // Update the NewbornHospitalNurseries record with the new data
        $nursery->update($data);
    
        return response()->json([
            'status' => 'success',
            'message' => 'Newborn Hospital Nursery record updated successfully',
            'data' => $nursery,
        ]);
    }
    

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
         // Retrieve the hospitalNursery table record with the given ID
         $hospitalNursery = newborn_hospital_nursery::find($id);

         // Check if the hospitalNursery table record exists
         if (!$hospitalNursery) {
             return response()->json([
                 'status' => 'error',
                 'message' => 'hospitalNursery record record not found',
             ], 404);
         }
 
         // Delete the hospitalNursery  record record
         $hospitalNursery->delete();
 
         // Return a success message
         return response()->json([
             'status' => 'success',
             'message' => 'hospitalNursery  record record deleted successfully',
         ]);
    }
}

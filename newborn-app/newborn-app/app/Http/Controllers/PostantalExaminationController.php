<?php

namespace App\Http\Controllers;

use App\Models\Doctor;
use App\Models\Hospital;
use App\Models\Midwife;
use App\Models\MinistryOfHealth;
use App\Models\Nurse;
use App\Models\PostnatalExaminations;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Response;
use Illuminate\Support\Facades\Validator;

class PostantalExaminationController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        //
        $postnatalExamination = PostnatalExaminations::all();
        return response()->json([
            'status' => 'success',
            'message' => 'Postnatal examinations retrieved successfully',
            'data' => $postnatalExamination,
        ], 200);
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create(Request $request)
    {
        //
        //Retrieve input data from the request object
        $data = $request->all();
        // Create a postnatal examination  record in the database using the input data
        $postnatalExamination = PostnatalExaminations::create($data);
        // Return the newly created record in JSON format with a success message
        return response()->json([
            'status' => 'success',
            'message' => 'postnatal examination created successfully ',
            'data' => $data,
        ]);
    }

    /**
     * Store a newly created resource in storage.
     */
    //     public function store(Request $request)
    //     {
    //         //validate the request data
    //         $validator = Validator::make($request->all(), [
    //             'day_after_delivery' => 'required|integer',
    //             'date_of_visit' => 'required|date',
    //             'Temp' => 'required|string',
    //             'Pulse' => 'required|string',
    //             'B_P' => 'required|string',
    //             'bleeding_after_delivery' => 'nullable|boolean',
    //             'Hb' => 'required|string',
    //             'DVT' => 'nullable|boolean',
    //             'Rupture_Uterus' => 'nullable|boolean',
    //             'if_yes' => 'nullable|in:Repaired,Hysterectomy_Done',
    //             'Lochia_color' => 'nullable|in:White,Yellow,Red',
    //             'Incision' => 'nullable|in:Clean,Infected',
    //             'Seizures' => 'nullable|boolean',
    //             'Blood_Transfusion' => 'nullable|boolean',
    //             'Breasts' => 'nullable|in:pain,redness,Hot,Abnormal_Secretions',
    //             'Fundal_Height' => 'nullable|integer',
    //             'Family_Planing_Counseling' => 'nullable|string',
    //             'FP_Appointment' => 'nullable|date',
    //             'Recommendations' => 'nullable|string',
    //             'Remarks' => 'nullable|string',

    //         ]);
    //         if ($validator->fails()) {
    //             return response()->json([
    //                 'status' => 'error',
    //                 'errors' => $validator->errors(),
    //                 'message' => 'validation error',
    //             ], 422);
    //         }
    //         $data = $request->all();
    //   return response()->json([
    //             'status' => 'success',
    //             'message' => 'successfully created new postnatal examination',
    //             'data' => $data,
    //         ], 201);
    //     }


    public function store(Request $request)
    {
        // Validate the request data
        $validator = Validator::make($request->all(), [
            'day_after_delivery' => 'required|integer',
            'date_of_visit' => 'required|date',
            'Temp' => 'required|string',
            'Pulse' => 'required|string',
            'B_P' => 'required|string',
            'mother_name' => 'nullable|string',
            'bleeding_after_delivery' => 'nullable|boolean',
            'Hb' => 'required|string',
            'DVT' => 'nullable|boolean',
            'Rupture_Uterus' => 'nullable|boolean',
            'if_yes' => 'nullable|in:Repaired,Hysterectomy_Done',
            'Lochia_color' => 'nullable|in:White,Yellow,Red',
            'Incision' => 'nullable|in:Clean,Infected',
            'Seizures' => 'nullable|boolean',
            'Blood_Transfusion' => 'nullable|boolean',
            'Breasts' => 'nullable|in:pain,redness,Hot,Abnormal_Secretions',
            'Fundal_Height' => 'nullable|integer',
            'Family_Planing_Counseling' => 'nullable|string',
            'FP_Appointment' => 'nullable|date',
            'Recommendations' => 'nullable|string',
            'Remarks' => 'nullable|string',
            'doctor_id' => 'nullable|integer', // Update the validation rule to integer
            'midwife_id' => 'nullable|integer', // Update the validation rule to integer
            'nurse_id' => 'nullable|integer', // Update the validation rule to integer
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'errors' => $validator->errors(),
                'message' => 'Validation error',
            ], 422);
        }

        $data = $request->all();



        $postnatalExamination = PostnatalExaminations::create($data);
        $ministryName = $request->input('ministry_name');
        if ($ministryName) {
            $ministry = MinistryOfHealth::where('name', $ministryName)->first();
            if (!$ministry) {
                // return response()->json(['errors' => 'Invalid ministry Name'], 422);
                $ministry = new MinistryOfHealth();
                $ministry->name = $ministryName;
                $ministry->save();
            }
            $postnatalExamination->ministry_center_id = $ministry->id;
        }
        //get hospital Name
        $hospitalName = $request->input('nurse_name');
        if ($hospitalName) {
            $hospital = Nurse::where('name', $hospitalName)->first();
            if (!$hospital) {
                // return response()->json(['errors' => 'Invalid hospital Name'], 422);
                $hospital = new Nurse();
                $hospital->name = $hospitalName;
                $hospital->save();
            }
            $postnatalExamination->nurse_id = $hospital->id;
        }
        //get nurse Name
        $nurseName = $request->input('midwife_name');
        if ($nurseName) {
            $nurse = Midwife::where('name', $nurseName)->first();
            if (!$nurse) {
                $nurse = new Nurse();
                $nurse->name = $nurseName;
                $nurse->save();
                // return response()->json(['errors' => 'Invalid nurse Name'], 422);
            }
            $postnatalExamination->midwife_id = $nurse->id;
        }
        //get doctor Name
        $doctorName = $request->input('doctor_name');
        if ($doctorName) {
            $doctor = Doctor::where('name', $doctorName)->first();
            if (!$doctor) {
                // Doctor doesn't exist, so create a new record
                $doctor = new Doctor();
                $doctor->name = $doctorName;
                $doctor->save();
            }
            $postnatalExamination->doctor_id = $doctor->id;
        }
        return response()->json([
            'status' => 'success',
            'message' => 'Successfully created a new postnatal examination',
            'data' => $postnatalExamination,
        ], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        //
        $postnatalExamination = PostnatalExaminations::find($id);
        if (!$postnatalExamination) {
            return response()->json([
                'status' => 'error',
                'message' => 'Postnatal examination not found',
            ], 404);
        } else {
            return response()->json([
                'status' => 'success',
                'data' => $postnatalExamination,
            ], 200);
        }
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
        // Retrieve the PostnatalExamination record by ID
        $postnatalExamination = PostnatalExaminations::find($id);

        // Check if the record exists
        if (!$postnatalExamination) {
            // If the record doesn't exist, return an error message
            return response()->json([
                'status' => 'error',
                'message' => 'Postnatal Examination record not found',
            ], 404);
        }

        // If the record exists, return the record data in JSON format with a success message
        return response()->json([
            'status' => 'success',
            'message' => 'Postnatal Examination record found',
            'data' => $postnatalExamination,
        ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        // Retrieve the PostnatalExamination record by ID
        $postnatalExamination = PostnatalExaminations::find($id);

        // Check if the record exists
        if (!$postnatalExamination) {
            return response()->json([
                'status' => 'error',
                'message' => 'Postnatal Examination record not found',
            ], 404);
        }

        // Validate the request data
        $validator = Validator::make($request->all(), [
            'day_after_delivery' => 'nullable|integer',
            'date_of_visit' => 'nullable|date',
            'Temp' => 'nullable|string',
            'Pulse' => 'nullable|string',
            'B_P' => 'nullable|string',
            'bleeding_after_delivery' => 'nullable|string',
            'Hb' => 'nullable|string',
            'DVT' => 'nullable|boolean',
            'Rupture_Uterus' => 'nullable|boolean',
            'if_yes' => 'nullable|in:Repaired,Hysterectomy_Done',
            'Lochia_color' => 'nullable|in:White,Yellow,Red',
            'Incision' => 'nullable|in:Clean,Infected',
            'Seizures' => 'nullable|boolean',
            'Blood_Transfusion' => 'nullable|boolean',
            'Breasts' => 'nullable|in:pain,redness,Hot,Abnormal_Secretions',
            'Fundal_Height' => 'nullable|integer',
            'Family_Planing_Counseling' => 'nullable|string',
            'FP_Appointment' => 'nullable|date',
            'Recommendations' => 'nullable|string',
            'Remarks' => 'nullable|string',
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

        $data = $request->all();

        // Update the PostnatalExamination record with the new data
        $postnatalExamination->update($data);

        return response()->json([
            'status' => 'success',
            'message' => 'Postnatal Examination record updated successfully',
            'data' => $postnatalExamination,
        ]);
    }


    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id)
    {
        // Retrieve the postnatal examination record with the given ID
        $postnatalExamination = PostnatalExaminations::find($id);

        // Check if the postnatal examination record exists
        if (!$postnatalExamination) {
            return response()->json([
                'status' => 'error',
                'message' => 'Postnatal examination record not found',
            ], 404);
        }

        // Delete the postnatal examination record
        $postnatalExamination->delete();

        // Return a success message
        return response()->json([
            'status' => 'success',
            'message' => 'Postnatal examination record deleted successfully',
        ]);
    }
}

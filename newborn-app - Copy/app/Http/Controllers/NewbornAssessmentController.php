<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
// Include the necessary models
use App\Models\Doctor;
use App\Models\Midwife;
use App\Models\MinistryOfHealth;
use App\Models\Nurse;
use App\Models\Newborn_Assessment;
use Illuminate\Support\Facades\Validator;

class NewbornAssessmentController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        //retrieve all record from database
        $newbornAssessments = Newborn_Assessment::all();
        return response()->json([
            'status' => 'success',
            'message' => 'Newborn assessment retrieved successfully',
            'data' => $newbornAssessments,
        ]);
    }

    public function store(Request $request)
    {
        $validatedData = $request->validate([
            'Birth_Weight' => 'nullable|string',
            'date_of_delivery' => 'nullable|date',
            'mode_of_delivery' => 'nullable|in:C_S,V_D',
            'Gestational_age_at_delivery' => 'nullable|string',
            'Temp' => 'nullable|string',
            'Pulse' => 'nullable|string',
            'Resp_rate' => 'nullable|string',
            'Weight' => 'nullable|integer',
            'height' => 'nullable|integer',
            'HC' => 'nullable|integer',
            'Sex' => 'nullable|in:Male,Female',
            'Congenital_Malformation' => 'nullable|in:Yes,No,Referred',
            'Jaundice' => 'nullable|in:Yes,No,Referred',
            'Cyanosis' => 'nullable|in:Yes,No,Referred',
            'Umbilical_stump' => 'nullable|in:Clean,Infected,Referred',
            'Feeding' => 'nullable|in:Mixed,Artificial,Exclusive',
            'Remarks' => 'nullable|string',
            'doctor_id' => 'nullable|integer',
            'midwife_id' => 'nullable|integer',
            'nurse_id' => 'nullable|integer',
        ]);

        $data = $request->all();



        $postnatalExamination =new Newborn_Assessment();

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
     * Show the form for creating a new resource.
     */
    public function create(Request $request)
    {
        //Retrieve input data from the request object
        $data = $request->all();
        // Create a new newborn assessment record in the database using the input data
        $newbornAssessments = Newborn_Assessment::create($data);
        // Return the newly created record in JSON format with a success message
        return response()->json([
            'status' => 'success',
            'message' => 'newborn assessment created successfully ',
            'data' => $data,
        ]);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function storeold(Request $request)
    {
        $validatedData = $request->validate([
            'Birth_Weight' => 'nullable|string',
            'date_of_delivery' => 'nullable|date',
            'mode_of_delivery' => 'nullable|in:C_S,V_D',
            'Gestational_age_at_delivery' => 'nullable|string',
            'Temp' => 'nullable|string',
            'Pulse' => 'nullable|string',
            'Resp_rate' => 'nullable|string',
            'Weight' => 'nullable|integer',
            'height' => 'nullable|integer',
            'HC' => 'nullable|integer',
            'Sex' => 'nullable|in:Male,Female',
            'Congenital_Malformation' => 'nullable|in:Yes,No,Referred',
            'Jaundice' => 'nullable|in:Yes,No,Referred',
            'Cyanosis' => 'nullable|in:Yes,No,Referred',
            'Umbilical_stump' => 'nullable|in:Clean,Infected,Referred',
            'Feeding' => 'nullable|in:Mixed,Artificial,Exclusive',
            'Remarks' => 'nullable|string',
            'doctor_id' => 'nullable|integer',
            'midwife_id' => 'nullable|integer',
            'nurse_id' => 'nullable|integer',
        ]);

        $newbornAssessment = Newborn_Assessment::create($validatedData);
        $doctorName = $request->input('doctor_name');
        if ($doctorName) {
            $doctor = Doctor::where('name', $doctorName)->first();
            if (!$doctor) {
                $doctor = new Doctor();
                $doctor->name = $doctorName;
                $doctor->save();
            }
            $newbornAssessment->doctor_id = $doctor->id; // Assign the foreign key
        }

        $midwifeName = $request->input('midwife_name');
        if ($midwifeName) {
            $midwife = Midwife::where('name', $midwifeName)->first();
            if (!$midwife) {
                $midwife = new Midwife();
                $midwife->name = $midwifeName;
                $midwife->save();
            }
            $newbornAssessment->midwife_id = $midwife->id; // Assign the foreign key
        }

        $nurseName = $request->input('nurse_name');
        if ($nurseName) {
            $nurse = Nurse::where('name', $nurseName)->first();
            if (!$nurse) {
                $nurse = new Nurse();
                $nurse->name = $nurseName;
                $nurse->save();
            }
            $newbornAssessment->nurse_id = $nurse->id; // Assign the foreign key
        }


        return response()->json(['data' => $newbornAssessment], 201);
    }


    /**
     * Display the specified resource.
     */
    public function show($id)
    {
        $newbornAssessment = Newborn_Assessment::find($id);

        if (!$newbornAssessment) {
            return response()->json(['message' => 'Newborn assessment not found'], 404);
        }

        return response()->json(['newbornAssessment' => $newbornAssessment]);
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit($id)
    {
        //
        $newbornAssessments = Newborn_Assessment::findOrFail($id);
        if ($newbornAssessments) {

            return response()->json([
                'status' => 'success',
                'message' => 'success get the newbornAssessment id',
                'newbornAssessments' => $newbornAssessments,
            ]);
        } else {
            return response()->json([
                'status' => 404,
                'message' => 'there is no category with id' . $id,
            ]);
        }
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        //
        $validatedData = Validator::make($request->all(), [
            'Birth_Weight' => 'nullable|numeric',
            'date_of_delivery' => 'nullable|date',
            'mode_of_delivery' => 'nullable|in:C.S,V.D',
            'Gestational_age_at_delivery' => 'nullable|string',
            'Temp' => 'nullable|string',
            'Pulse' => 'nullable|string',
            'Resp_rate' => 'nullable|string',
            'Weight' => 'nullable|numeric',
            'height' => 'nullable|numeric',
            'HC' => 'nullable|numeric',
            'Sex' => 'nullable|in:Male,Female',
            'Congenital_Malformation' => 'nullable|in:Yes,No,Referred',
            'Jaundice' => 'nullable|in:Yes,No,Referred',
            'Cyanosis' => 'nullable|in:Yes,No,Referred',
            'Umbilical_stump' => 'nullable|in:Clean,Infected,Referred',
            'Feeding' => 'nullable|in:Mixed,Artificial,Exclusive',
            'Remarks' => 'nullable|string',
            'doctor_id' => 'nullable|exists:doctors,id',
            'midwife_id' => 'nullable|exists:midwives,id',
            'nurse_id' => 'nullable|exists:nurses,id',
        ]);
        if ($validatedData->fails()) {
            return response()->json([
                'status' => 422,
                'message' => $validatedData
                    ->message(),
            ]);
        } else {
            $newborn = Newborn_Assessment::find($id);
            if ($newborn) {
                $newborn->Birth_Weight = $request->input('Birth_Weight');
                $newborn->date_of_delivery = $request->input('date_of_delivery');
                $newborn->mode_of_delivery = $request->input('mode_of_delivery');
                $newborn->Gestational_age_at_delivery = $request->input('Gestational_age_at_delivery');
                $newborn->Temp = $request->input('Temp');
                $newborn->Pulse = $request->input('Pulse');
                $newborn->Resp_rate = $request->input('Resp_rate');
                $newborn->Weight = $request->input('Weight');
                $newborn->height = $request->input('height');
                $newborn->HC = $request->input('HC');
                $newborn->Sex = $request->input('Sex');
                $newborn->Congenital_Malformation = $request->input('Congenital_Malformation');
                $newborn->Jaundice = $request->input('Jaundice');
                $newborn->Cyanosis = $request->input('Cyanosis');
                $newborn->Umbilical_stump = $request->input('Umbilical_stump');
                $newborn->Feeding = $request->input('Feeding');
                $newborn->Remarks = $request->input('Remarks');
                // $newborn->doctor_id = $request->input('doctor_id');
                // $newborn->midwife_id = $request->input('midwife_id');
                // $newborn->nurse_id = $request->input('nurse_id');
                if ($request->has('doctor_id') && $request->input('doctor_id')) {
                    $doctor = Doctor::find($request->input('doctor_id'));
                    if ($doctor) {
                        $newborn->doctor_id = $request->input('doctor_id');
                    } else {
                        return response()->json([
                            'status' => '404',
                            'message' => 'doctor not found or invalid ,try again'
                        ]);
                    }
                }

                //nurse id
                if ($request->has('nurse_id') && $request->input('nurse_id')) {
                    $nurse = Nurse::find($request->input('nurse_id'));
                    if ($nurse) {
                        $newborn->nurse_id = $request->input('nurse_id');
                    } else {
                        return response()->json([
                            'status' => '404',
                            'message' => 'nurse not found or invalid ,try again'
                        ]);
                    }
                }

                //midwife
                if ($request->has('midwife_id') && $request->input('midwife_id')) {
                    $midwife = Midwife::find($request->input('midwife_id'));
                    if ($midwife) {
                        $newborn->midwife_id = $request->input('midwife_id');
                    } else {
                        return response()->json([
                            'status' => '404',
                            'message' => 'midwife not found or invalid ,try again'
                        ]);
                    }
                }


                $newborn->save();

                return response()->json([
                    'status' => 200,
                    'message' => 'successfully updated newbornAssessment Record ',
                ]);
            } else {
                return response()->json([
                    'status' => 404,
                    'message' => 'newbornAssessment  not found or invalid ,try again',
                ]);
            }
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        //
        $newbornAssessment = Newborn_Assessment::findOrFail($id);
        if ($newbornAssessment) {
            $newbornAssessment->delete();
            return response()->json([
                'status' => 200,
                'message' => 'Successfully deleted the specified record newbornAssessment' . $newbornAssessment,
            ]);
        } else {
            return response()->json([
                'status' => 404,
                'message' => 'No newbornAssessment specified found for the $newbornAssessment' . $id
            ]);
        }
    }
}

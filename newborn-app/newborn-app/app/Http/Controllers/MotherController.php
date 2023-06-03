<?php

namespace App\Http\Controllers;

use App\Models\Doctor;
use App\Models\Hospital;
use App\Models\Midwife;
use App\Models\MinistryOfHealth;
use App\Models\Mother;
use App\Models\Newborn;
use App\Models\Nurse;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\DB;

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

    public function fetchMidwives()
    {
        $doctor = Midwife::all(['id', 'name'])->toArray();
        return response()->json($doctor);
    }

    //get info of newborns by mother_id in the mother
    public function getNewbornsWithMothers()
    {
        $mother = DB::table('mothers')
            ->join('newborns', 'mothers.id', 'newborns.mother_id')
            ->select(
                'mothers.first_name as mother_name',
                'newborns.firstName as newborn_name',
                'newborns.gender',
                'newborns.date_of_birth',
                'newborns.time_of_birth',
                'newborns.weight',
                'newborns.status',
                'newborns.identity_number'
            )
            ->paginate(2);
        return response()->json([
            'status' => 'success',
            'data' => $mother,
        ]);
    }


    public function getNewbornsByMotherIdentityNumber($motherIdentityNumber)
    {
        $newborns = DB::table('newborns')
            ->join('mothers', 'newborns.mother_id', '=', 'mothers.identity_number')
            ->select('newborns.*', 'newborns.identity_number')
            ->where('mothers.identity_number', $motherIdentityNumber)
            ->get();

        // Debugging statements
        // dd($newborns); // Dump and die - displays the value and stops the execution

        return response()->json([
            'status' => 'success',
            'data' => $newborns,
        ]);
    }

    public function checkIdentityNumber($enteredIdentityNumber)
    {
        $mother = Mother::where('identity_number', $enteredIdentityNumber)->first();

        return response()->json(['exists' => true]);
    }


    public function getMother($id)
{
    $mother = Mother::find($id);

    return response()->json([
        'success' => true,
        'data' => $mother,
    ]);
}
public function getAutoProfileMother($identityNumber)
{
    $mother = Mother::where('identity_number', $identityNumber)->first();

    if ($mother) {
        // Retrieve the auto profile data for the mother
        $autoProfile = $mother->autoProfile;

        return response()->json(['mother' => $mother, 'autoProfile' => $autoProfile], 200);
    }

    return response()->json(['message' => 'Mother not found.'], 404);
}


    //search about mother by these filter name or their newborns
    public function searchMother(Request $request)
    {
        $query = Mother::query();
        $query->join('newborns', 'newborns.mother_id', '=', 'mothers.id');
        //filter by mother name if provided in query params
        if ($request->has('name')) {
            $query->where(function ($query) use ($request) {
                $query->where('mothers.first_name', 'like', '%' . $request->input('name') . '%')
                    ->orWhere('mothers.last_name', 'like', '%' . $request->input('name') . '%')
                    ->orWhere('newborns.first_name', 'like', '%' . $request->input('name') . '%')
                    ->orWhere('newborns.last_name', 'like', '%' . $request->input('name') . '%');
            });
        }
        $mother = $query->get();
        return response()->json(['mothers' => $mother]);
    }
    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
    }



    public function createInfoOfMother(Request $request)
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
            'blood_type' => 'nullable|in:A,B,AB,O',
            'rhesusFactor' => 'nullable|in:Positive,Negative',
            'ministry_id' => 'nullable|exists:ministryofhealths,id',
            'hospital_id' => 'nullable|exists:hospitals,id',
            'doctor_id' => 'nullable|exists:doctors,id',
            'midwife_id' => 'nullable|exists:midwives,id',
            'newborn_id' => 'nullable|string|max:255',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }
        $newborn = Newborn::where('identity_number', $request->input('newborn_id'))->first();

        if ($newborn) {
            $newborn->identity_number = $request->input('newborn_id');
            $newborn->save();
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
        $mother->age = $request->input('age');
        $mother->newborn_id = $newborn->identity_number;

        // 'newborn_id' => $newborn ? $newborn->identity_number : null,
        $mother->country = $request->input('country');
        $mother->blood_type = $request->input('blood_type');
        $mother->rhesusFactor = $request->input('rhesusFactor');
        //lockup for the attribute from another tables
        $ministryName = $request->input('ministry_name');
        if ($ministryName) {
            $ministry = MinistryOfHealth::where('name', $ministryName)->first();
            if (!$ministry) {
                // return response()->json(['errors' => 'Invalid ministry Name'], 422);
                $ministry = new MinistryOfHealth();
                $ministry->name = $ministryName;
                $ministry->save();
            }
            $mother->ministry_id = $ministry->id;
        }
        //get hospital Name
        $hospitalName = $request->input('hospital_name');
        if ($hospitalName) {
            $hospital = Hospital::where('name', $hospitalName)->first();
            if (!$hospital) {
                // return response()->json(['errors' => 'Invalid hospital Name'], 422);
                $hospital = new Hospital();
                $hospital->name = $hospitalName;
                $hospital->save();
            }
            $mother->hospital_id = $hospital->id;
        }
        //get nurse Name
        $nurseName = $request->input('nurse_name');
        if ($nurseName) {
            $nurse = Nurse::where('name', $nurseName)->first();
            if (!$nurse) {
                $nurse = new Nurse();
                $nurse->name = $nurseName;
                $nurse->save();
                // return response()->json(['errors' => 'Invalid nurse Name'], 422);
            }
            $mother->nurse_id = $nurse->id;
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
            $mother->doctor_id = $doctor->id;
        }




        $mother->save();

        return response()->json(['mother' => $mother], 201);
    }
    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            // Validation rules for the mother data
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
            'rhesusFactor' => 'nullable|string|max:255',
            'location_id' => 'nullable|exists:locations,id',
            'newborn_id' => 'nullable|string',
            'health_center_id' => 'nullable|exists:health_centers,id',
            'hospital_center_id' => 'nullable|exists:hospitals,id',
            'guideline_id' => 'nullable|exists:guidelines,id',
            'doctor_id' => 'nullable|exists:doctors,id',
            'nurse_id' => 'nullable|exists:nurses,id',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $newborn = Newborn::where('identity_number', $request->input('newborn_id'))->first();

        if ($newborn) {
            $newborn->identity_number = $request->input('newborn_id');
            $newborn->save();
        }

        $mother = new Mother();

        // Update the newborns relationship

            $mother = Mother::create([
                'first_name' => $request->input('first_name'),
                'last_name' => $request->input('last_name'),
                'address' => $request->input('address'),
                'phone_number' => $request->input('phone_number'),
                'identity_number' => $request->input('identity_number'),
                'email' => $request->input('email'),
                'date_of_birth' => $request->input('date_of_birth'),
                'husband_name' => $request->input('husband_name'),
                'husband_phone_number' => $request->input('husband_phone_number'),
                'number_of_newborns' => $request->input('number_of_newborns'),
                'city' => $request->input('city'),
                'country' => $request->input('country'),
                'blood_type' => $request->input('blood_type'),
                'rhesusFactor' => $request->input('rhesusFactor'),
                'newborn_id' => $newborn ? $newborn->identity_number : null,
                'location_id' => $request->input('location_id'),
                'health_center_id' => $request->input('health_center_id'),
                'hospital_center_id' => $request->input('hospital_center_id'),
                'guideline_id' => $request->input('guideline_id'),
                'doctor_id' => $request->input('doctor_id'),
                'nurse_id' => $request->input('nurse_id'),
                'midwife_id' => $request->input('midwife_id'),
            ]);

        // Update the doctor relationship
        if ($request->has('doctor_id')) {
            $doctor = Doctor::find($request->input('doctor_id'));
            if ($doctor) {
                $mother->doctor()->associate($doctor);
                $mother->save();
            }
        }

        // Update the nurse relationship
        if ($request->has('nurse_id')) {
            $nurse = Nurse::find($request->input('nurse_id'));
            if ($nurse) {
                $mother->nurse()->associate($nurse);
                $mother->save();
            }
        }

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
            'dateOfBirth' => 'nullable|date',
            'husband_name' => 'nullable|string|max:255',
            'identity_number' => 'nullable|string|max:255',
            'husband_phone_number' => 'nullable|string|max:255',
            'number_of_newborns' => 'nullable|integer|min:0',
            'city' => 'nullable|string|max:255',
            'country' => 'nullable|string|max:255',
            'blood_type' => 'nullable|string|max:255',
            'rhesusFactor' => 'nullable|string|max:255',
            'location_id' => 'nullable|exists:locations,id',
            'newborn_id' => 'nullable|exists:newborns,id',
            'health_center_id' => 'nullable|exists:health_centers,id',
            'hospital_center_id' => 'nullable|exists:hospitals,id',
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
        $mother->rhesusFactor = $request->input('rhesusFactor', $mother->rhesusFactor);
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

<?php

namespace App\Http\Controllers;

use App\Models\MinistryOfHealth;
use App\Models\Newborn;
use App\Models\newborn_vaccine;
use App\Models\VaccinationTabel;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Validator;

class VaccinationTabelController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index($identityNumber)
    {
        $newborns = Newborn::where('identity_number', $identityNumber)->get();

        if ($newborns->isEmpty()) {
            return response()->json([
                'status' => 'error',
                'message' => 'No newborns found',
            ], 404);
        }

        $vaccines = [];

        foreach ($newborns as $newborn) {
            $newbornVaccines = VaccinationTabel::select('name', 'month_vaccinations')
                ->where('newborn_id', $newborn->vaccination_table_id)
                ->get();

            $vaccines[] = [
                'newborn_id' => $newborn->id,
                'vaccines' => $newbornVaccines,
            ];
        }

        return response()->json([
            'status' => 'success',
            'message' => 'Vaccines retrieved successfully',
            'data' => $vaccines,
        ]);
    }


    public function allVaccines(){
        $vaccine = VaccinationTabel::with('newborn.mother')->get();

        return response()->json([
            'status' => 'success',
            'message' => 'all vaccines record retrieved successfully',
            'data' => $vaccine,
        ]);
    }

    public function updateVaccine($id, Request $request)
    {
        $vaccine = VaccinationTabel::findOrFail($id);

        $request->validate([
            'name' => 'required',
            'month_vaccinations' => 'required',
        ]);

        $vaccine->name = $request->input('name');
        $vaccine->month_vaccinations = $request->input('month_vaccinations');

        $vaccine->save();

        return response()->json([
            'status' => 'success',
            'message' => 'Vaccine record updated successfully',
            'data' => $vaccine,
        ]);
    }




    //new function

    public function createNewborn(Request $request)
    {
        $newborn = Newborn::create($request->all());

        return response()->json(['message' => 'Newborn record created successfully'], 201);
    }



    public function getNewbornData()
    {
        $newborns = Newborn::select('firstName', 'identity_number', 'date_of_birth', 'vaccine_received')
            ->with(['vaccinationTable' => function ($query) {
                $query->select('name', 'month_vaccinations', 'doses', 'doctor_name', 'vaccination_date');
            }])
            ->get();

        return response()->json($newborns, 200);
    }

    public function getVaccine($identityNumber)
    {
        $vaccine = VaccinationTabel::where('identity_number', $identityNumber)->first();

        if (!$vaccine) {
            return response()->json(['message' => 'Vaccine not found'], 404);
        }

        return response()->json($vaccine, 200);
    }




    //



    /**
     * Show the form for creating a new resource.
     */
    public function create(Request $request)
    {
        // Retrieve the newborn by identity number
        $newborn = Newborn::where('identity_number', $request->identity_number)->firstOrFail();

        // Check if the newborn has received the vaccine
        $vaccineReceived = $newborn->vaccine_received;

        // Create a new vaccination table record
        $vaccine = new VaccinationTabel();
        $vaccine->name = $request->vaccine_name;
        $vaccine->doctor_name = $request->doctor_name;
        $vaccine->month_vaccinations = $request->vaccine_month;
        $vaccine->vaccination_date = $request->vaccine_date;
        $vaccine->newborn_id = $newborn->id; // Assign the newborn ID directly
        $vaccine->save();

        return response()->json([
            'newborn_id' => $newborn->id,
            'vaccine_received' => $vaccineReceived,
            'vaccine' => $vaccine,
        ]);
    }








    public function fetchVaccines($identityNumber)
    {
        $vaccines = VaccinationTabel::whereHas('newborn', function ($query) use ($identityNumber) {
            $query->where('identity_number', $identityNumber);
        })->get();

        return response()->json($vaccines);
    }

    public function storeVaccine(Request $request)
    {
        // Validate the request data
        $validatedData = $request->validate([
            'name' => 'nullable|string',
            'doses' => 'nullable|integer',
            'place' => 'nullable|string',
            'diseases' => 'nullable|string',
            'method' => 'nullable|in:Oral,Drops',
            'month_vaccinations' => 'nullable|string',
            'vaccination_date' => 'required|date',
            // 'newborn_id' => 'nullable|string|max:255',
            // 'ministry_id' => 'nullable|exists:ministryofhealths,id',
        ]);

        // Parse the vaccination_date field as a date
        $validatedData['vaccination_date'] = Carbon::parse($validatedData['vaccination_date']);

        // Create a new VaccinationTable record with the validated data
        $vaccinationTable = VaccinationTabel::create($validatedData);

        // Return the response with the created VaccinationTable record
        return response()->json([
            'status' => 'success',
            'message' => 'Successfully created new vaccination table with date',
            'data' => $vaccinationTable,
        ], 201);
    }
    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        // validate the request data
        $validatedData = $request->validate([
            'name' => 'nullable|string',
            'doses' => 'nullable|integer',
            'place' => 'nullable|string',
            'diseases' => 'nullable|string',
            'method' => 'nullable|in:Oral,Drops',
            'month_vaccinations' => 'nullable|string',
            'vaccination_date' => 'required|date',
            // 'newborn_id' => 'nullable|exists:newborns,id',
            // 'ministry_id' => 'nullable|exists:ministryofhealths,id',
        ]);

        $data = $request->all();


        // create a new vaccine record with associated fields
        $vaccine = VaccinationTabel::create([
            'name' => $validatedData['name'],
            'doses' => $validatedData['doses'],
            'place' => $validatedData['place'],
            'diseases' => $validatedData['diseases'],
            'method' => $validatedData['method'],
            'vaccination_date' => $validatedData['vaccination_date'],
            'month_vaccinations' => $validatedData['month_vaccinations'],

        ]);


        $vaccine->save();

        return response()->json([
            'status' => 'success',
            'message' => 'successfully created new vaccine',
            'data' => $vaccine,
        ], 201);
    }





    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
        // Retrieve the vaccine record by ID
        $vaccine = VaccinationTabel::find($id);

        // Check if the record exists
        if (!$vaccine) {
            // If the vaccine record doesn't exist, return an error message
            return response()->json([
                'status' => 'error',
                'message' => 'vaccine id record not found',
            ], 404);
        }

        // If the record exists, return the record data in JSON format with a success message
        return response()->json([
            'status' => 'success',
            'message' => 'vaccine id record found',
            'data' => $vaccine,
        ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        // Find the vaccine by ID
        $vaccine = VaccinationTabel::find($id);
        if (!$vaccine) {
            return response()->json([
                'status' => 'error',
                'message' => 'Vaccine not found',
            ], 404);
        }

        // Validate the request data
        $validator = Validator::make($request->all(), [
            'name' => 'nullable|string',
            'doses' => 'nullable|integer',
            'place' => 'nullable|string',
            'diseases' => 'nullable|string',
            'method' => 'nullable|in:Oral,Drops',
            // 'month' => 'nullable|string',
            'month_vaccinations' => 'nullable|string',
            // 'newborn_id' => 'nullable|exists:newborns,id',
            // 'ministry_id' => 'nullable|exists:ministries,id',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'errors' => $validator->errors(),
                'message' => 'Validation error',
            ], 422);
        }

        // Update the vaccine with the new data
        $vaccine->name = $request->input('name', $vaccine->name);
        $vaccine->doses = $request->input('doses', $vaccine->doses);
        $vaccine->place = $request->input('place', $vaccine->place);
        $vaccine->diseases = $request->input('diseases', $vaccine->diseases);
        $vaccine->method = $request->input('method', $vaccine->method);
        // $vaccine->month = $request->input('month', $vaccine->month);
        $vaccine->month_vaccinations = $request->input('month_vaccinations', $vaccine->month_vaccinations);
        $vaccine->save();

        return response()->json([
            'status' => 'success',
            'message' => 'Vaccine updated successfully',
            'data' => $vaccine,
        ]);
    }



    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {

        // Retrieve the vaccination table record with the given ID
        $vaccine = VaccinationTabel::find($id);

        // Check if the vaccination table record exists
        if (!$vaccine) {
            return response()->json([
                'status' => 'error',
                'message' => 'vaccination record record not found',
            ], 404);
        }

        // Delete the vaccination record record
        $vaccine->delete();

        // Return a success message
        return response()->json([
            'status' => 'success',
            'message' => 'vaccination record record deleted successfully',
        ]);
    }
}

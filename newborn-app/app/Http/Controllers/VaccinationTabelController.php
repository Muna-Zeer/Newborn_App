<?php

namespace App\Http\Controllers;

use App\Models\MinistryOfHealth;
use App\Models\Newborn;
use App\Models\VaccinationTabel;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class VaccinationTabelController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        //
        $vaccine = VaccinationTabel::all();

        return response()->json([
            'status' => 'success',
            'message' => 'all vaccinations record  retrieved successfully',
            'data' => $vaccine,
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
        $validatedData = $request->validate([
            'name' => 'nullable|string',
            'doses' => 'nullable|integer',
            'place' => 'nullable|string',
            'diseases' => 'nullable|string',
            'method' => 'nullable|string',
            'month' => 'nullable|string',
            'month_vaccinations' => 'nullable|string',
            'newborn_id' => 'nullable|exists:newborns,id',
            'ministry_id' => 'nullable|exists:ministries,id',
        ]);
    
        // check if the newborn_id exists in the input data
        if (isset($validatedData['newborn_id'])) {
            $newborn = Newborn::findOrFail($validatedData['newborn_id']);
        } else {
            $newborn = null;
        }
    
        // check if the ministry_id exists in the input data
        if (isset($validatedData['ministry_id'])) {
            $ministry = MinistryOfHealth::findOrFail($validatedData['ministry_id']);
        } else {
            $ministry = null;
        }
    
        // create a new vaccine record with associated fields
        $vaccine = VaccinationTabel::create([
            'name' => $validatedData['name'],
            'doses' => $validatedData['doses'],
            'place' => $validatedData['place'],
            'diseases' => $validatedData['diseases'],
            'method' => $validatedData['method'],
            'month' => $validatedData['month'],
            'month_vaccinations' => $validatedData['month_vaccinations'],
            'newborn_id' => $newborn ? $newborn->id : null,
            'ministry_id' => $ministry ? $ministry->id : null,
        ]);
    
        // save the vaccine object
        $vaccine->save();
    
        // reload the object with the associated fields
        $vaccine = $vaccine->load(['newborn', 'ministry']);
    
        // return the response with the created vaccine record
        return response()->json([
            'status' => 'success',
            'message' => 'successfully created new vaccine',
            'data' => $vaccine,
        ], 201);
    }
    


    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $vaccineTable = VaccinationTabel::find($id);

        if (!$vaccineTable) {
            return response()->json([
                'status' => 'error',
                'message' => 'vaccine id not found',
            ], 404);
        } else {

            return response()->json([
                'status' => 'success',
                'message' => 'vaccine id retrieved successfully',
                'data' => $vaccineTable,
            ]);
        }
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
            'method' => 'nullable|string',
            'month' => 'nullable|string',
            'month_vaccinations' => 'nullable|string',
            'newborn_id' => 'nullable|exists:newborns,id',
            'ministry_id' => 'nullable|exists:ministries,id',
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
        $vaccine->month = $request->input('month', $vaccine->month);
        $vaccine->month_vaccinations = $request->input('month_vaccinations', $vaccine->month_vaccinations);
        $vaccine->newborn_id = $request->input('newborn_id', $vaccine->newborn_id);
        $vaccine->ministry_id = $request->input('ministry_id', $vaccine->ministry_id);
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

<?php

namespace App\Http\Controllers;

use App\Models\Feeding;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rule;

class FeedingController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        //
        $feeding= Feeding::all();

        return response()->json([
            'status' => 'success',
            'message' => 'all feedings record  retrieved successfully',
            'data' => $feeding,
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
            'feeding_type' => 'nullable|string',
            'quantity' => 'nullable|numeric',
            'date' => 'nullable|date',
            'time' => 'nullable|date_format:H:i',
            'newborn_id' => [
                'nullable',
                Rule::exists('newborns', 'id')->where(function ($query) use ($request) {
                    $query->where('ministry_id', $request->input('ministry_id'));
                }),
            ],
            'month' => 'nullable|string',
            'instructions' => 'nullable|string',
            'ministry_id' => 'nullable|integer',
        ]);
    
        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => $validator->errors(),
            ], 400);
        }
    
        try {
            $feeding = new Feeding;
            $feeding->feeding_type = $request->input('feeding_type');
            $feeding->quantity = $request->input('quantity');
            $feeding->date = $request->input('date');
            $feeding->time = $request->input('time');
            $feeding->newborn_id = $request->input('newborn_id');
            $feeding->month = $request->input('month');
            $feeding->instructions = $request->input('instructions');
            $feeding->ministry_id = $request->input('ministry_id');
            $feeding->save();
    
            return response()->json([
                'status' => 'success',
                'message' => 'Feeding record created successfully',
                'data' => $feeding,
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Failed to create feeding record: ' . $e->getMessage(),
            ], 500);
        }
    }
    

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $Feeding = Feeding::find($id);

        if (!$Feeding) {
            return response()->json([
                'status' => 'error',
                'message' => 'Feeding id not found',
            ], 404);
        } else {

            return response()->json([
                'status' => 'success',
                'message' => 'Feeding id retrieved successfully',
                'data' => $Feeding,
            ]);
        }
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
            // Retrieve the Feeding record by ID
            $Feeding = Feeding::find($id);

            // Check if the record exists
            if (!$Feeding) {
                // If the Feeding record doesn't exist, return an error message
                return response()->json([
                    'status' => 'error',
                    'message' => 'Feeding id record not found',
                ], 404);
            }
    
            // If the record exists, return the record data in JSON format with a success message
            return response()->json([
                'status' => 'success',
                'message' => 'Feeding id record found',
                'data' => $Feeding,
            ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        // Validate the request data
        $validator = Validator::make($request->all(), [
            'feeding_type' => 'nullable|string|max:255',
            'quantity' => 'nullable|numeric',
            'date' => 'nullable|date',
            'time' => 'nullable|date_format:H:i:s',
            'newborn_id' => [
                'nullable',
                Rule::exists('newborns', 'id')->where(function ($query) use ($request) {
                    $query->where('ministry_id', $request->input('ministry_id'));
                }),
            ],
            'month' => 'nullable|string|max:255',
            'instructions' => 'nullable|string',
            'ministry_id' => [
                'nullable',
                Rule::exists('ministries_of_health', 'id'),
            ],
        ]);
    
        // If validation fails, return the errors
        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }
    
        // Find the feeding record by ID
        $feeding = Feeding::find($id);
    
        // If the feeding record doesn't exist, return an error
        if (!$feeding) {
            return response()->json(['error' => 'Feeding record not found.'], 404);
        }
    
        // Update the feeding record with the new data
        $feeding->update($request->all());
    
        // Return the updated feeding record
        return response()->json(['feeding' => $feeding]);
    }
    

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
         // Retrieve the Feeding table record with the given ID
         $Feeding = Feeding::find($id);

         // Check if the Feeding table record exists
         if (!$Feeding) {
             return response()->json([
                 'status' => 'error',
                 'message' => 'Feeding record record not found',
             ], 404);
         }
 
         // Delete the Feeding  record record
         $Feeding->delete();
 
         // Return a success message
         return response()->json([
             'status' => 'success',
             'message' => 'Feeding  record record deleted successfully',
         ]);
    }
}

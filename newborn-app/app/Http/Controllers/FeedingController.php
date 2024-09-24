<?php

namespace App\Http\Controllers;

use App\Models\Feeding;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
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

            'month' => 'nullable|string',
            'instructions' => 'nullable|string',
            'ministry_id' => 'nullable|integer|exists:ministryofhealths,id',

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
            $Feeding = Feeding::find($id);

            if (!$Feeding) {
                return response()->json([
                    'status' => 'error',
                    'message' => 'Feeding id record not found',
                ], 404);
            }

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
        $feeding = Feeding::find($id);

        if (!$feeding) {
            return response()->json(['error' => 'Feeding record not found.'], 404);
        }

        $validator = Validator::make($request->all(), [
            'feeding_type' => 'nullable|string|max:255',
            'quantity' => 'nullable|numeric',
            'date' => 'nullable|date',
            // 'newborn_id' => [
            //     'nullable',
            //     Rule::exists('newborns', 'id')->where(function ($query) use ($request) {
            //         $query->where('ministry_id', $request->input('ministry_id'));
            //     }),
            // ],
            'month' => 'nullable|string|max:255',
            'instructions' => 'nullable|string',
            'ministry_id' => [
                'nullable',
                Rule::exists('ministryofhealths', 'id'),
            ],
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $feeding->update([
            'feeding_type' => $request->input('feeding_type', $feeding->feeding_type),
            'quantity' => $request->input('quantity', $feeding->quantity),
            'date' => $request->input('date', $feeding->date),
            // 'newborn_id' => $request->input('newborn_id', $feeding->newborn_id),
            'month' => $request->input('month', $feeding->month),
            'instructions' => $request->input('instructions', $feeding->instructions),
            'ministry_id' => $request->input('ministry_id', $feeding->ministry_id),
        ]);

        return response()->json([
            'feeding successfully has been changed' => $feeding,
            'status' => 'success',
            'data' => $feeding,
        ]);
    }


    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
         $Feeding = Feeding::find($id);

         if (!$Feeding) {
             return response()->json([
                 'status' => 'error',
                 'message' => 'Feeding record record not found',
             ], 404);
         }

         $Feeding->delete();

         // Return a success message
         return response()->json([
             'status' => 'success',
             'message' => 'Feeding  record record deleted successfully',
         ]);
    }
}

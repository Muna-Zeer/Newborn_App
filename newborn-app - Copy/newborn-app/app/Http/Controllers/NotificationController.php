<?php

namespace App\Http\Controllers;

use App\Models\Notification;
use Illuminate\Database\QueryException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rule;

class NotificationController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        //
        $notification = Notification::all();

        return response()->json([
            'status' => 'success',
            'message' => 'all notifications record  retrieved successfully',
            'data' => $notification,
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
            'notification_type' => 'required|string',
            'message' => 'required|string',
            'recipient_id' => [
                'nullable',
                Rule::exists('users', 'id')->where(function ($query) use ($request) {
                    $query->where('role_id', 2)->where('ministry_id', $request->input('ministry_id'));
                }),
            ],
            'immunization_id' => [
                'nullable',
                Rule::exists('immunizations', 'id')->where(function ($query) use ($request) {
                    $query->where('ministry_id', $request->input('ministry_id'));
                }),
            ],
            'health_center_id' => [
                'nullable',
                Rule::exists('HealthCenters', 'id')->where(function ($query) use ($request) {
                    $query->where('ministry_id', $request->input('ministry_id'));
                }),
            ],
            'hospital_center_id' => [
                'nullable',
                Rule::exists('hospitals', 'id')->where(function ($query) use ($request) {
                    $query->where('ministry_id', $request->input('ministry_id'));
                }),
            ],
            'vaccine_id' => [
                'nullable',
                Rule::exists('vaccines', 'id')->where(function ($query) use ($request) {
                    $query->where('ministry_id', $request->input('ministry_id'));
                }),
            ],
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        try {
            $notification = Notification::create($request->all());
        } catch (QueryException $exception) {
            return response()->json(['errors' => ['database' => [$exception->getMessage()]]], 422);
        }

        return response()->json(['notification' => $notification], 201);
    }



    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $notification = notification::find($id);

        if (!$notification) {
            return response()->json([
                'status' => 'error',
                'message' => 'notification id not found',
            ], 404);
        } else {

            return response()->json([
                'status' => 'success',
                'message' => 'notification id retrieved successfully',
                'data' => $notification,
            ]);
        }
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
        // Retrieve the notification record by ID
        $notification = notification::find($id);

        // Check if the record exists
        if (!$notification) {
            // If the notification record doesn't exist, return an error message
            return response()->json([
                'status' => 'error',
                'message' => 'notification id record not found',
            ], 404);
        }

        // If the record exists, return the record data in JSON format with a success message
        return response()->json([
            'status' => 'success',
            'message' => 'notification id record found',
            'data' => $notification,
        ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        // Retrieve the Notification record by ID
        $notification = Notification::find($id);

        // Check if the record exists
        if (!$notification) {
            return response()->json([
                'status' => 'error',
                'message' => 'Notification record not found',
            ], 404);
        }

        // Validate the request data
        $validator = Validator::make($request->all(), [
            'notification_type' => 'nullable|string',
            'message' => 'nullable|string',
            'recipient_id' => 'nullable|integer|exists:users,id',
            'immunization_id' => 'nullable|integer|exists:date_of_immunizations,id',
            'health_center_id' => 'nullable|integer|exists:health_centers,id',
            'hospital_center_id' => 'nullable|integer|exists:hospitals,id',
            'vaccine_id' => 'nullable|integer|exists:vaccination_tables,id',
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

        // Update the Notification record with the new data
        $notification->update($data);

        return response()->json([
            'status' => 'success',
            'message' => 'Notification record updated successfully',
            'data' => $notification,
        ]);
    }


    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        //
        // Retrieve the notification record with the given ID
        $notification = Notification::find($id);

        // Check if the notification record exists
        if (!$notification) {
            return response()->json([
                'status' => 'error',
                'message' => 'notification record not found',
            ], 404);
        }

        // Delete the notification record
        $notification->delete();

        // Return a success message
        return response()->json([
            'status' => 'success',
            'message' => 'notification record deleted successfully',
        ]);
    }
}

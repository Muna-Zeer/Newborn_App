<?php

namespace App\Http\Controllers;

use App\Models\adminPrevExam;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rule;

class adminPrevExamination extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        //

        $adminExamType = adminPrevExam::all();
        return response()->json([
            'status' => 'success return all data',
            'data' => $adminExamType,

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
        //
        $validatedData = $request->validate([
            'exam_type' =>
            'required|string|unique:admin_prev_examination,exam_type',
            'description' => 'required|string',
        ]);
        $examType = adminPrevExam::create($validatedData);
        return response()->json([
            'status' => 'success',
            'data' => $examType,
            'message' => 'successfully created new record',
        ], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(adminPrevExam $adminPrevExam)
    {
        //
        return response()->json([
            'status' => 'success',
            'data' => $adminPrevExam
        ]);
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(adminPrevExam $adminPrevExam)
    {
        //

    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        //
        $prevExam = adminPrevExam::find($id);

        if (!$prevExam) {
            return response()->json(['error' => 'prevExam record not found.'], 404);
        }

        $validatedData = Validator::make($request->all(), [
            'exam_type' => [
                'required',
                'string'
            ],
            'description' => ['required' , 'string'],
        ]);
        if ($validatedData->fails()) {
            return response()->json(['errors' => $validatedData->errors()], 422);
        }
        $prevExam->update([
            'exam_type' => $request->input('exam_type', $prevExam->feeding_type),
            'description' => $request->input('description', $prevExam->description),

            ]
        );
        return response()->json([
            'status' => 'success',
            'data' => $prevExam,
            'message' => 'preventive Examination updated successfully',
        ]);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(adminPrevExam $adminPrevExam)
    {
        //
        $adminPrevExam->delete();
        return response()->json([
            'status' => 'successfully deleted ',
            'data' => $adminPrevExam,
        ]);
    }
}

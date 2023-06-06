<?php

namespace App\Http\Controllers;

use App\Models\Role;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class RoleController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        //
        $role = Role::all();

        return response()->json([
            'status' => 'success',
            'message' => 'all roles record  retrieved successfully',
            'data' => $role,
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
            'name' => 'required|string|unique:roles,name',
            'description' => 'nullable|string',
        ]);
    
        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => 'Validation error',
                'errors' => $validator->errors(),
            ], 422);
        }
    
        $roleData = $request->only(['name', 'description']);
        $role = Role::create($roleData);
    
        if ($request->has('users')) {
            $userIds = $request->input('user_id');
            $users = User::find($userIds);
            $role->users()->saveMany($users);
        }
    
        $role->load('users');
    
        return response()->json([
            'status' => 'success',
            'message' => 'Role created successfully',
            'data' => $role,
        ], 201);
    }
    

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $Role = Role::find($id);

        if (!$Role) {
            return response()->json([
                'status' => 'error',
                'message' => 'Role id not found',
            ], 404);
        } else {

            return response()->json([
                'status' => 'success',
                'message' => 'Role id retrieved successfully',
                'data' => $Role,
            ]);
        }
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
        // Retrieve the Role record by ID
        $Role = Role::find($id);

        // Check if the record exists
        if (!$Role) {
            // If the Role record doesn't exist, return an error message
            return response()->json([
                'status' => 'error',
                'message' => 'Role id record not found',
            ], 404);
        }

        // If the record exists, return the record data in JSON format with a success message
        return response()->json([
            'status' => 'success',
            'message' => 'Role id record found',
            'data' => $Role,
        ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        $role = Role::findOrFail($id);
    
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|unique:roles,name,' . $id,
            'description' => 'nullable|string',
        ]);
    
        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => 'Validation error',
                'errors' => $validator->errors(),
            ], 422);
        }
    
        $roleData = $request->only(['name', 'description']);
        $role->fill($roleData)->save();
    
        if ($request->has('users')) {
            $userIds = $request->input('users');
            $users = User::find($userIds);
            $role->users()->sync($users);
        }
    
        $role->load('users');
    
        return response()->json([
            'status' => 'success',
            'message' => 'Role updated successfully',
            'data' => $role,
        ]);
    }
    

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        //
        // Retrieve the role record with the given ID
        $role = Role::find($id);

        // Check if the role record exists
        if (!$role) {
            return response()->json([
                'status' => 'error',
                'message' => 'role record not found',
            ], 404);
        }

        // Delete the role record
        $role->delete();

        // Return a success message
        return response()->json([
            'status' => 'success',
            'message' => 'role record deleted successfully',
        ]);
    }
}

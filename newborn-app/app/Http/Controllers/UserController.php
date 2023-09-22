<?php

namespace App\Http\Controllers;

use App\Models\Role;
use App\Models\User;
use Illuminate\Http\Request;

class UserController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        //
        $user= User::all();

        return response()->json([
            'status' => 'success',
            'message' => 'all users record  retrieved successfully',
            'data' => $user,
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
        $validatedData = $request->validate([
            'name' => 'required|string',
            'email' => 'required|email|unique:users,email',
            'password' => 'required|string|min:8',
            'role_id' => 'required|exists:roles,id'
        ]);

        $user = User::create($validatedData);

        // Associate the user with the given role
        $user->role()->associate(Role::find($validatedData['role_id']));
        $user->save();

        return response()->json([
            'status' => 'success',
            'message' => 'User created successfully',
            'data' => $user
        ], 201);
    }


    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $user = user::find($id);

        if (!$user) {
            return response()->json([
                'status' => 'error',
                'message' => 'user id not found',
            ], 404);
        } else {

            return response()->json([
                'status' => 'success',
                'message' => 'user id retrieved successfully',
                'data' => $user,
            ]);
        }
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
                      // Retrieve the user record by ID
                      $user = user::find($id);

                      // Check if the record exists
                      if (!$user) {
                          // If the user record doesn't exist, return an error message
                          return response()->json([
                              'status' => 'error',
                              'message' => 'user id record not found',
                          ], 404);
                      }

                      // If the record exists, return the record data in JSON format with a success message
                      return response()->json([
                          'status' => 'success',
                          'message' => 'user id record found',
                          'data' => $user,
                      ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        $user = User::findOrFail($id);

        $validatedData = $request->validate([
            'name' => 'nullable|string',
            'email' => 'nullable|email|unique:users,email,'.$user->id,
            'password' => 'nullable|string|min:8',
            'role_id' => 'nullable|exists:roles,id'
        ]);

        $user->update($validatedData);

        // Associate the user with the given role, if provided
        if (isset($validatedData['role_id'])) {
            $user->role()->associate(Role::find($validatedData['role_id']));
            $user->save();
        }

        return response()->json([
            'status' => 'success',
            'message' => 'User updated successfully',
            'data' => $user
        ], 200);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        //
                // Retrieve the user record with the given ID
                $user = User::find($id);

                // Check if the user record exists
                if (!$user) {
                    return response()->json([
                        'status' => 'error',
                        'message' => 'user record not found',
                    ], 404);
                }

                // Delete the user record
                $user->delete();

                // Return a success message
                return response()->json([
                    'status' => 'success',
                    'message' => 'user record deleted successfully',
                ]);
            }
    }


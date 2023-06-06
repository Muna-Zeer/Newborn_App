<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class AuthController extends Controller
{
    //
    public function register(Request $req)
    {
        //validate
        $rules = [
            'name' => 'required|string',
            'email' => 'required|string|unique:users',
            'password' => 'required|string|min:6'
        ];
        $validator = Validator::make($req->all(), $rules);
        if ($validator->fails()) {
            return response()->json($validator->errors(), 400);
        }
        //create new user in users table
        $user = User::create([
            'name' => $req->name,
            'email' => $req->email,
            'password' => Hash::make($req->password),
            'role' => 'IsMedicalProfessional', // set the default role to patient
            'role_id' => 1, // set the default role_id value
        ]);

        $token = $user->createToken('Personal Access Token')->plainTextToken;
        $response = ['user' => $user, 'token' => $token];
        return response()->json($response, 200);
    }

    public function login(Request $req)
    {
        // validate inputs
        $rules = [
            'email' => 'required',
            'password' => 'required|string'
        ];
        $req->validate($rules);
        // find user email in users table
        $user = User::where('email', $req->email)->first();
        // if user email found and password is correct
        if ($user && Hash::check($req->password, $user->password)) {
            $token = $user->createToken('Personal Access Token')->plainTextToken;
            $response = ['user' => $user, 'token' => $token];
            return response()->json($response, 200);
        }
        $response = ['message' => 'Incorrect email or password'];
        return response()->json($response, 400);
    }

    public function logout(Request $request)
    {
        $request->user()->tokens()->delete();

        $response = ['message' => 'Logged out'];
        return response()->json($response, 200);
    }








    public function registerMother(Request $request)
    {
        // validate input fields
        $validator = Validator::make($request->all(), [
            'username' => 'required|string|max:255|unique:users',
            'email' => 'required|string|email|max:255|unique:users',
            'password' => 'required|string|min:8|confirmed',
        ]);

        // return error response if validation fails
        if ($validator->fails()) {
            return response()->json($validator->errors(), 422);
        }

        // create new user with default role ID of 1
        $user = User::create([
            'username' => $request->username,
            'email' => $request->email,
            'password' => Hash::make($request->password),
            'role_id' => 1,
        ]);

        // generate token for user
        $token = $user->createToken('authToken')->accessToken;

        // return success response with token and user data
        return response()->json([
            'token' => $token,
            'user' => $user
        ], 201);
    }
    public function loginMother(Request $request)
{
    // validate input fields
    $validator = Validator::make($request->all(), [
        'email' => 'required|string|email',
        'password' => 'required|string|min:8',
    ]);

    // return error response if validation fails
    if ($validator->fails()) {
        return response()->json($validator->errors(), 422);
    }

    // authenticate user based on email and password
    if (!Auth::attempt(['email' => $request->email, 'password' => $request->password])) {
        return response()->json(['message' => 'Invalid credentials'], 401);
    }

    // get authenticated user
    $user = Auth::user();

    // create token for user
    // $token = $user->createToken('authToken')->plainTextToken;

    // return success response with token and user data
    return response()->json([
        // 'token' => $token,
        'user' => $user
    ]);
}


}

<?php

namespace App\Http\Controllers;
use App\Models\Mother;
use App\Models\motherUser;
use Illuminate\Http\Request;

class motherUserController extends Controller
{

    //
    public function createMotherUser(Request $request)
    {
        $motherUser = new MotherUser();
        $motherUser->identity_number = $request->input('identity_number');
        $motherUser->phone = $request->input('phone');
        $motherUser->password = bcrypt($request->input('password'));
        $motherUser->username = $request->input('username');

        // Save the mother user
        $motherUser->save();

        // Generate a token
        $token = $motherUser->createToken('device_token')->plainTextToken;

        // Update the device token for the user
        $motherUser->device_token = $token;
        $motherUser->save();

        return response()->json(['message' => 'Mother user created successfully',
    'data'=>$motherUser], 201);
    }

    public function checkCreateMotherUser(Request $request)
{


        // Create the mother user
        $motherUser = new MotherUser();
        $motherUser->identity_number = $request->input('identity_number');
        $motherUser->phone = $request->input('phone');
        $motherUser->password = $request->input('password');
        $motherUser->username = $request->input('username');

        // Save the mother user
        $motherUser->save();

        return response()->json(['message' => 'Mother user created successfully'], 201);
    }


}

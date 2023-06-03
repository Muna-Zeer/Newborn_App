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
        $motherUser = new motherUser();
        $motherUser->identity_number = $request->input('identity_number');
        $motherUser->phone = $request->input('phone');
        $motherUser->password = $request->input('password');
        $motherUser->username = $request->input('username');

        // Save the mother user
        $motherUser->save();

        return response()->json(['message' => 'Mother user created successfully'], 201);
    }


    public function checkCreateMotherUser(Request $request)
{
    // $isIdentityNumberMatched = $this->checkIdentityNumber($request->input('identity_number'));

    // if ($isIdentityNumberMatched) {
        // Identity number exists in the Mother table

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

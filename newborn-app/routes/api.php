<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});
//Route of NewbornAssessment
Route::middleware('auth:api')->group(function () {
    // Get a list of all newborn assessments
    Route::get('/newborn-assessments', [NewbornAssessmentController::class, 'index']);

    // Get the details of a specific newborn assessment
    Route::get('/newborn-assessments/{id}', [NewbornAssessmentController::class, 'show']);

    // Create a new newborn assessment
    Route::post('/newborn-assessments', [NewbornAssessmentController::class, 'store']);

    // Update an existing newborn assessment
    Route::put('/newborn-assessments/{id}', [NewbornAssessmentController::class, 'update']);

    // Delete a newborn assessment
    Route::delete('/newborn-assessments/{id}', [NewbornAssessmentController::class, 'destroy']);
});

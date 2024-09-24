<?php

use App\Http\Controllers\adminPrevExamination;
use App\Http\Controllers\AppointmentController;
use App\Http\Controllers\DateOfImmunizationController;
use App\Http\Controllers\DoctorController;
use App\Http\Controllers\EmergencyController;
use App\Http\Controllers\FeedingController;
use App\Http\Controllers\GuildelineController;
use App\Http\Controllers\HealthCareController;
use App\Http\Controllers\HealthCenterController;
use App\Http\Controllers\HospitalController;
use App\Http\Controllers\HospitalNurseryController;
use App\Http\Controllers\LocationController;
use App\Http\Controllers\MeasurementController;
use App\Http\Controllers\MidwifeController;
use App\Http\Controllers\MinnistryOfHealthController;
use App\Http\Controllers\MotherController;
use App\Http\Controllers\MotherExaminationController;
use App\Http\Controllers\NewbornAssesmentController;
use App\Http\Controllers\NewbornAssessmentController;
use App\Http\Controllers\NewbornBathController;
use App\Http\Controllers\NewbornController;
use App\Http\Controllers\NewbornExaminationController;
use App\Http\Controllers\NotificationController;
use App\Http\Controllers\NurseController;
use App\Http\Controllers\PostantalExaminationController;
use App\Http\Controllers\PreventiveExaminationController;
use App\Http\Controllers\RoleController;
use App\Http\Controllers\SpecializationController;
use App\Http\Controllers\UserController;
use App\Http\Controllers\VaccinationTabelController;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\motherUserController;
use App\Http\Controllers\NewbornVaccineController;
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

Route::post('/logout', function (Request $request) {
    $request->user()->tokens()->delete();

    return [
        'message' => 'Logged out successfully'
    ];
})->middleware(['auth:sanctum']);

// Register Route
Route::post('/register', 'App\Http\Controllers\AuthController@register');

// Login Route
Route::post('/login', 'App\Http\Controllers\AuthController@login');

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});
//Route of AppointmentController
Route::middleware('auth:api')->group(function () {
    // Get a list of all appointments
    Route::get('/appointments', [AppointmentController::class, 'index']);

    // Get the details of a specific appointments
    Route::get('/appointments/{id}', [AppointmentController::class, 'show']);

    // Create a new appointments
    Route::post('/appointments', [AppointmentController::class, 'store']);

    // Update an existing appointments
    Route::put('/appointments/{id}', [AppointmentController::class, 'update']);

    // Delete a appointments
    Route::delete('/appointments/{id}', [AppointmentController::class, 'destroy']);
});
//Route of MotherExaminationController
// Route::middleware('auth:api')->group(function () {

Route::get('/motherExaminations', [MotherExaminationController::class, 'index']);

Route::get('/motherExaminations/{id}', [MotherExaminationController::class, 'show']);
Route::post('/motherExaminations', [MotherExaminationController::class, 'store']);
Route::put('/motherExaminations/{id}', [MotherExaminationController::class, 'update']);
Route::delete('/motherExaminations/{id}', [MotherExaminationController::class, 'destroy']);
// });
//Route of MotherController
// Route::middleware('auth:api')->group(function () {

Route::get('/mothers', [MotherController::class, 'index']);
Route::get('/getColumnMother', [MotherController::class, 'getColumnMother']);
Route::get('/midwivesForm', [MotherController::class, 'fetchMidwives']);
Route::get('/autoProfileMother/{identity_number}', [MotherController::class, 'getAutoProfileMother']);
Route::get('/searchOfMothers', [MotherController::class, 'searchMother']);
Route::get('/newbornWithMothers', [MotherController::class, 'getNewbornsWithMothers']);
Route::get('/mothers/{id}', [MotherController::class, 'show']);
Route::get('/newborns/{motherIdentityNumber}', [MotherController::class, 'getNewbornsByMotherIdentityNumber']);
Route::post('/createInfoMother', [MotherController::class, 'store']);
Route::post('/createInfoOfMother', [MotherController::class, 'createInfoOfMother']);
Route::put('/mothers/{id}', [MotherController::class, 'update']);
Route::delete('/mothers/{id}', [MotherController::class, 'destroy']);
Route::get('/check-identity-number/{enteredIdentityNumber}', [MotherController::class, 'checkIdentityNumber']);
// routes/api.php

//motherUser
Route::post('/createMotherUser', [motherUserController::class, 'createMotherUser']);
Route::post('/checkCreateMotherUser', [motherUserController::class, 'checkCreateMotherUser']);

// Route::get('/autoProfileMother/{identity_number}', 'MotherController@getAutoProfileMother');

// });
//Route of MinistryOfHealthController
// Route::middleware('auth:api')->group(function () {

Route::get('/ministry', [MinnistryOfHealthController::class, 'index']);
Route::get('/ministry/{id}', [MinnistryOfHealthController::class, 'show']);
Route::post('/ministry', [MinnistryOfHealthController::class, 'store']);
Route::put('/ministry/{id}', [MinnistryOfHealthController::class, 'update']);
Route::delete('/ministry/{id}', [MinnistryOfHealthController::class, 'destroy']);
// });
//Route of MidwifeController
// Route::middleware('auth:api')->group(function () {

    Route::get('/midwives', [MidwifeController::class, 'index']);
    Route::get('/allMidwives/{id}', [MidwifeController::class, 'allMidwives']);
    Route::get('/midwivesTable', [MidwifeController::class, 'midwifeTable']);
    Route::get('/fetchMidwives/{id}', [MidwifeController::class, 'show']);
    Route::post('/midwives', [MidwifeController::class, 'store']);
    Route::put('/midwives/{id}', [MidwifeController::class, 'update']);
    Route::delete('/midwives/{id}', [MidwifeController::class, 'destroy']);
// });
//Route of MeasurementController
// Route::middleware('auth:api')->group(function () {

    Route::get('/measurements', [MeasurementController::class, 'index']);
    Route::get('/measurements/{id}', [MeasurementController::class, 'show']);
    Route::post('/measurement', [MeasurementController::class, 'store']);
    Route::put('/measurements/{id}', [MeasurementController::class, 'update']);
    Route::delete('/measurements/{id}', [MeasurementController::class, 'destroy']);
// });
//Route of LocationController
Route::middleware('auth:api')->group(function () {

    Route::get('/locations', [LocationController::class, 'index']);
    Route::get('/locations/{id}', [LocationController::class, 'show']);
    Route::post('/locations', [LocationController::class, 'store']);
    Route::put('/locations/{id}', [LocationController::class, 'update']);
    Route::delete('/locations/{id}', [LocationController::class, 'destroy']);
});
//Route of HospitalNurseryController
// Route::middleware('auth:api')->group(function () {

    Route::get('/hospitalNurseries', [HospitalNurseryController::class, 'index']);
    Route::get('/hospitalNurseries/{id}', [HospitalNurseryController::class, 'show']);
    Route::post('/hospitalNurseries', [HospitalNurseryController::class, 'store']);
    Route::put('/hospitalNurseries/{id}', [HospitalNurseryController::class, 'update']);
    Route::delete('/hospitalNurseries/{id}', [HospitalNurseryController::class, 'destroy']);
// });
//Route of HospitalController
// Route::middleware('auth:api')->group(function () {

    Route::get('/hospitals', [HospitalController::class, 'index']);
    Route::get('/hospitals/{id}', [HospitalController::class, 'show']);
    Route::post('/hospitals', [HospitalController::class, 'store']);
    Route::put('/hospitals/{id}', [HospitalController::class, 'update']);
    Route::delete('/hospitals/{id}', [HospitalController::class, 'destroy']);
// });
//Route of HealthCenterController
Route::middleware('auth:api')->group(function () {

    Route::get('/healthCenters', [HealthCenterController::class, 'index']);
    Route::get('/healthCenters/{id}', [HealthCenterController::class, 'show']);
    Route::post('/healthCenters', [HealthCenterController::class, 'store']);
    Route::put('/healthCenters/{id}', [HealthCenterController::class, 'update']);
    Route::delete('/healthCenters/{id}', [HealthCenterController::class, 'destroy']);
});
//Route of HealthCareController
Route::middleware('auth:api')->group(function () {

    Route::get('/healthCares', [HealthCareController::class, 'index']);
    Route::get('/healthCares/{id}', [HealthCareController::class, 'show']);
    Route::post('/healthCares', [HealthCareController::class, 'store']);
    Route::put('/healthCares/{id}', [HealthCareController::class, 'update']);
    Route::delete('/healthCares/{id}', [HealthCareController::class, 'destroy']);
});
//Route of GuildelineController
// Route::middleware('auth:api')->group(function () {

Route::get('/guidelines', [GuildelineController::class, 'index']);
Route::get('/guidelines/{id}', [GuildelineController::class, 'show']);
Route::post('/guidelines', [GuildelineController::class, 'store']);
Route::put('/guidelines/{id}', [GuildelineController::class, 'update']);
Route::delete('/guidelines/{id}', [GuildelineController::class, 'destroy']);
// });
//Route of FeedingController
// Route::middleware('auth:api')->group(function () {

Route::get('/feedings', [FeedingController::class, 'index']);
Route::get('/feedings/{id}', [FeedingController::class, 'show']);
Route::post('/feedings', [FeedingController::class, 'store']);
Route::put('/feedings/{id}', [FeedingController::class, 'update']);
Route::delete('/feedings/{id}', [FeedingController::class, 'destroy']);
// });
//Route of EmergencyController
Route::middleware('auth:api')->group(function () {

    Route::get('/Emergencies', [EmergencyController::class, 'index']);
    Route::get('/Emergencies/{id}', [EmergencyController::class, 'show']);
    Route::post('/Emergencies', [EmergencyController::class, 'store']);
    Route::put('/Emergencies/{id}', [EmergencyController::class, 'update']);
    Route::delete('/Emergencies/{id}', [EmergencyController::class, 'destroy']);
});
//Route of DoctorController
// Route::middleware('auth:api')->group(function () {

Route::get('/doctorsTables', [DoctorController::class, 'index']);
Route::get('/fetchDoctors', [DoctorController::class, 'index']);
Route::get('/fetchDoctors/{id}', [DoctorController::class, 'show']);
Route::post('/doctors', [DoctorController::class, 'store']);
Route::post('/doctors', [DoctorController::class, 'createRecordOfDoctor']);
Route::post('/newDoctors', [DoctorController::class, 'createRecordOfDoctorNew']);
Route::put('/doctors/{id}', [DoctorController::class, 'update']);
Route::get('/allDoctors/{id}', [DoctorController::class, 'allDoctors']);
Route::delete('/doctors/{id}', [DoctorController::class, 'destroy']);
Route::get('/hospitals', [DoctorController::class, 'fetchHospitals']);
Route::get('/fetchNurse', [DoctorController::class, 'fetchNurse']);
Route::get('/fetchVaccines', [DoctorController::class, 'fetchVaccines']);
Route::get('/ministryofhealths', [DoctorController::class, 'fetchMinistriesOfHealth']);
// Route::get('/doctors/{id}', function ($id) {
//     $doctor = Doctor::find($id);
// });
//Route of DateOfImmunizationController
Route::middleware('auth:api')->group(function () {

    Route::get('/dateImmunizations', [DateOfImmunizationController::class, 'index']);
    Route::get('/dateImmunizations/{id}', [DateOfImmunizationController::class, 'show']);
    Route::post('/dateImmunizations', [DateOfImmunizationController::class, 'store']);
    Route::put('/dateImmunizations/{id}', [DateOfImmunizationController::class, 'update']);
    Route::delete('/dateImmunizations/{id}', [DateOfImmunizationController::class, 'destroy']);
});
//Route of NewbornAssessment

// Route::middleware('auth:api')->group(function () {

Route::get('/newborn-assessments', [NewbornAssessmentController::class, 'index']);
Route::get('/newborn-assessments/{id}', [NewbornAssessmentController::class, 'show']);
Route::post('/newbornAssessments', [NewbornAssessmentController::class, 'store']);
Route::put('/newborn-assessments/{id}', [NewbornAssessmentController::class, 'update']);
Route::delete('/newborn-assessments/{id}', [NewbornAssessmentController::class, 'destroy']);
// });
//Route of NewbornBath Controller
Route::middleware('auth:api')->group(function () {

    Route::get('/newborn-bath', [NewbornBathController::class, 'index']);
    Route::get('/newborn-baths/{id}', [NewbornBathController::class, 'show']);
    Route::post('/newborn-baths', [NewbornBathController::class, 'store']);
    Route::put('/newborn-baths/{id}', [NewbornBathController::class, 'update']);
    Route::delete('/newborn-baths/{id}', [NewbornBathController::class, 'destroy']);
});
//Route of Newborn Controller
// Route::middleware('auth:api')->group(function () {

Route::get('/newborn', [NewbornController::class, 'index']);
Route::get('/newborns/{id}', [NewbornController::class, 'show']);
Route::get('/fetchNewbornsWithDetails', [NewbornController::class, 'fetchNewbornsWithDetails']);
Route::post('/newborns', [NewbornController::class, 'store']);
Route::put('/newborns/{id}', [NewbornController::class, 'update']);
Route::delete('/newborns/{id}', [NewbornController::class, 'destroy']);
// });
//Route ofNewbornExaminationController
// Route::middleware('auth:api')->group(function () {

Route::get('/newbornExamination', [NewbornExaminationController::class, 'index']);
Route::get('/newbornExaminations/{id}', [NewbornExaminationController::class, 'show']);
Route::post('/newbornExaminations', [NewbornExaminationController::class, 'store']);
Route::put('/newbornExaminations/{id}', [NewbornExaminationController::class, 'update']);
Route::delete('/newbornExaminations/{id}', [NewbornExaminationController::class, 'destroy']);
// });
//Route of NotificationController
Route::middleware('auth:api')->group(function () {

    Route::get('/notifications', [NotificationController::class, 'index']);
    Route::get('/notifications/{id}', [NotificationController::class, 'show']);
    Route::post('/notifications', [NotificationController::class, 'store']);
    Route::put('/notifications/{id}', [NotificationController::class, 'update']);
    Route::delete('/notifications/{id}', [NotificationController::class, 'destroy']);
});
//Route of NurseController
// Route::middleware('auth:api')->group(function () {

    Route::get('/nurses', [NurseController::class, 'index']);
    Route::get('/nurseTable', [NurseController::class, 'nurseTable']);
    Route::get('/fetchNurses/{id}', [NurseController::class, 'show']);
    Route::post('/nurses', [NurseController::class, 'store']);
    Route::put('/nurses/{id}', [NurseController::class, 'update']);
    Route::delete('/nurses/{id}', [NurseController::class, 'destroy']);
    Route::get('/doctors', [NurseController::class, 'fetchDoctors']);
// });
//Route of PostantalExaminationController
// Route::middleware('auth:api')->group(function () {

Route::get('/postnatalExamination', [PostantalExaminationController::class, 'index']);
Route::get('/postnatalExaminations/{id}', [PostantalExaminationController::class, 'show']);
Route::post('/postnatalExaminations', [PostantalExaminationController::class, 'store']);
Route::put('/postnatalExamination/{id}', [PostantalExaminationController::class, 'update']);
Route::delete('/postnatalExamination/{id}', [PostantalExaminationController::class, 'destroy']);
// });
//Route of PreventiveExaminationController
// Route::middleware('auth:api')->group(function () {

Route::get('/preventiveExaminations', [PreventiveExaminationController::class, 'index']);
Route::get('/preventiveExaminations/{id}', [PreventiveExaminationController::class, 'show']);
Route::post('/preventiveExaminations', [PreventiveExaminationController::class, 'store']);
Route::post('/preventiveExaminationsMinistry', [PreventiveExaminationController::class, 'storePreventiveExamination']);
Route::put('/preventiveExamination/{id}', [PreventiveExaminationController::class, 'update']);
Route::delete('/preventiveExamination/{id}', [PreventiveExaminationController::class, 'destroy']);
// });
//make some routes for admin

Route::get('/admin_prevExaminations', [adminPrevExamination::class, 'index']);
Route::get('/admin_prevExamination/{id}', [adminPrevExamination::class, 'show']);
Route::post('/admin_prevExamination', [adminPrevExamination::class, 'store']);
Route::put('/admin_prevExamination/{id}', [adminPrevExamination::class, 'update']);
Route::delete('/admin_prevExamination/{id}', [adminPrevExamination::class, 'destroy']);

//Route of RoleController
Route::middleware('auth:api')->group(function () {

    Route::get('/roles', [RoleController::class, 'index']);
    Route::get('/roles/{id}', [RoleController::class, 'show']);
    Route::post('/roles', [RoleController::class, 'store']);
    Route::put('/roles/{id}', [RoleController::class, 'update']);
    Route::delete('/roles/{id}', [RoleController::class, 'destroy']);
});
//Route of SpecializationController
Route::middleware('auth:api')->group(function () {

    Route::get('/specialization', [SpecializationController::class, 'index']);
    Route::get('/specialization/{id}', [SpecializationController::class, 'show']);
    Route::post('/specialization', [SpecializationController::class, 'store']);
    Route::put('/specialization/{id}', [SpecializationController::class, 'update']);
    Route::delete('/specialization/{id}', [SpecializationController::class, 'destroy']);
});
//Route of UserController
Route::middleware('auth:api')->group(function () {

    Route::get('/users', [UserController::class, 'index']);
    Route::get('/users/{id}', [UserController::class, 'show']);
    Route::post('/user', [UserController::class, 'store']);
    Route::put('/user/{id}', [UserController::class, 'update']);
    Route::delete('/user/{id}', [UserController::class, 'destroy']);
});
//Route of VaccinationTabelController
// Route::middleware('auth:api')->group(function () {


// });

Route::get('/vaccines/{identityNumber}', [VaccinationTabelController::class, 'index']);
Route::get('/vaccines/{identity_number}', [VaccinationTabelController::class, 'show']);
Route::post('/vaccine', [VaccinationTabelController::class, 'store']);
// Route::post('/NewbornVaccine', [VaccinationTabelController::class, 'storeNewbornVaccine']);
// Route::post('/storeVaccine', [VaccinationTabelController::class, 'storeVaccine']);
Route::post('/storeVaccine', [VaccinationTabelController::class, 'store']);
Route::put('/vaccine/{id}', [VaccinationTabelController::class, 'update']);
Route::delete('/vaccines/{id}', [VaccinationTabelController::class, 'destroy']);
Route::post('/vaccines/create', [VaccinationTabelController::class, 'create']);

Route::post('/vaccines', [VaccinationTabelController::class, 'createVaccine']);
Route::put('/vaccines/{id}', [VaccinationTabelController::class, 'updateVaccine']);
Route::get('/vaccines/{identityNumber}', [VaccinationTabelController::class, 'getVaccine']);

Route::post('/newborns', [VaccinationTabelController::class, 'createNewborn']);
Route::put('/newborns/{id}/vaccine-status', [VaccinationTabelController::class, 'updateVaccineStatus']);

Route::get('/vaccines/{identityNumber}', [VaccinationTabelController::class, 'index']);


//
Route::post('/newborns', [VaccinationTabelController::class, 'createNewborn']);
// Route::post('/NewbornVaccine', [VaccinationTabelController::class, 'NewbornVaccine']);
Route::put('/vaccines/{id}', [VaccinationTabelController::class, 'updateVaccine']);
Route::get('/newborns', [VaccinationTabelController::class, 'getNewbornData']);
Route::get('/allVaccines', [VaccinationTabelController::class, 'allVaccines']);

Route::post('/newborn-vaccines', [NewbornVaccineController::class, 'NewbornVaccine']);
Route::get('/compare-newborn-age', [NewbornVaccineController::class, 'compareNewbornAgeWithVaccineMonth']);
Route::get('/newborns/age', [NewbornVaccineController::class, 'getNewbornsAge']);

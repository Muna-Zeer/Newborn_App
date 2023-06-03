import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newborn_app/constant/models/nurse.dart';

import 'package:newborn_app/nurse/nurseAlert.dart';

Future<Nurse> fetchNurse(int nurseId) async {
  final response =
      await http.get(Uri.parse('http://127.0.0.1:8000/api/nurses/$nurseId'));
  if (response.statusCode == 200) {
    return Nurse.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load nurse');
  }
}

Future<bool> createNurse(Nurse nurse, BuildContext context) async {
  var request = http.MultipartRequest(
    'POST',
    Uri.parse('http://127.0.0.1:8000/api/nurses'),
  );

  request.headers['Content-Type'] =
      'multipart/form-data'; // Set the content type header

  request.fields['name'] = nurse.name;
  request.fields['salary'] = nurse.salary.toString();

  request.fields['specialization'] = nurse.specialization;
  request.fields['ministry_of_health_id'] = nurse.ministryOfHealthId.toString();
  request.fields['hospital_id'] = nurse.hospitalId.toString();
  request.fields['doctor_id'] = nurse.doctorId.toString();

  print('Request: $request');
  print(request.fields);

  request.fields['schedule'] = json.encode(nurse.schedule);
  for (int i = 0; i < nurse.schedule.length; i++) {
    request.fields['schedule[$i][day]'] = nurse.schedule[i]['day']!;
    request.fields['schedule[$i][start]'] = nurse.schedule[i]['start']!;
    request.fields['schedule[$i][end]'] = nurse.schedule[i]['end']!;
  }

  request.fields['startTime'] = nurse.startTime;
  request.fields['endTime'] = nurse.endTime;

  // Add the image file to the request
  // var file = await http.MultipartFile.fromPath('image', nurse.image.path);
  // request.files.add(file);

  var response = await request.send();

  if (response.statusCode == 201) {
    print('value of response is $response');
    NurseAlert.showSuccessAlert(context, nurse);
    return true;
  } else {
    print('Request: $request');
    NurseAlert.showError(context);
    return false;
  }
}

Future<void> deleteNurse(int id, BuildContext context) async {
  final response =
      await http.delete(Uri.parse('http://127.0.0.1:8000/api/nurses/$id'));

  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Nurse deleted successfully.'),
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to delete nurse record.'),
      ),
    );
  }
}

Future<bool> editNurse(int id, BuildContext context) async {
  final response =
      await http.put(Uri.parse('http://127.0.0.1:8000/api/nurses/$id'));

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

Future<bool> updateNurse(int id, Nurse nurseData, BuildContext context) async {
  // Convert schedule list to string representation
  // final scheduleString = jsonEncode(nurseData.schedule);

  final response =
      await http.put(Uri.parse('http://127.0.0.1:8000/api/nurses/$id'), body: {
    'name': nurseData.name,
    'specialization_id': nurseData.specialization,
    'hospital_center_id': nurseData.hospitalId,
    'ministry_of_health_id': nurseData.ministryOfHealthId,
    'salary': nurseData.salary,
  });

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}


import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newborn_app/apiService.dart';
import 'package:newborn_app/constant/models/midwifem.dart';
import 'package:newborn_app/midwife/Midwife/midwifeAlert.dart';
final baseUrl = ApiService.getBaseUrl();

//get info of doctor by doctorId
Future<Midwife> fetchMidwife(int midwifeId) async {
  final response = await http
      .get(Uri.parse('$baseUrl/midwives/$midwifeId'));
  if (response.statusCode == 200) {
    return Midwife.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load midwife');
  }
}

Future<bool> createMidwife(Midwife midwife, BuildContext context) async {
  var request = http.MultipartRequest(
    'POST',
    Uri.parse('$baseUrl/midwives'),
  );
  request.fields['id'] = midwife.name;
  request.fields['name'] = midwife.name;
  request.fields['salary'] = midwife.salary.toString();
  request.fields['report'] = midwife.report;
  request.fields['newborn_bracelet_leg'] = midwife.newbornBraceletLeg;
  request.fields['newborn_bracelet_hand'] = midwife.newbornBraceletHand;
  request.fields['communication_skills'] = midwife.communication;
  request.fields['mother_name'] = midwife.motherName;
  // request.fields['period'] = midwife.period.toString();
  request.fields['hours'] = midwife.hours.toString();

  request.fields['hospital_id'] = midwife.hospitalId.toString();
  request.fields['doctor_id'] = midwife.doctorId.toString();
  request.fields['schedule'] = json.encode(midwife.schedule);
  for (int i = 0; i < midwife.schedule.length; i++) {
    request.fields['schedule[$i][day]'] = midwife.schedule[i]['day']!;
    request.fields['schedule[$i][start]'] = midwife.schedule[i]['start']!;
    request.fields['schedule[$i][end]'] = midwife.schedule[i]['end']!;
  }

  request.fields['startTime'] = midwife.startTime;
  request.fields['endTime'] = midwife.endTime;

  print('Request: $request');
  print(request.fields);

  // if (doctor.image != null) {
  //   // Add the file to the request
  //   var file = await http.MultipartFile.fromPath('image', doctor.image!.path);
  //   request.files.add(file);
  // }

  var response = await request.send();

  if (response.statusCode == 201) {
    print('value of response is $response');
    MidwifeAlert.showSuccessAlert(context, midwife);
    return true;
  } else {
    print('Request: $request');
    MidwifeAlert.showError(context);
    return false;
  }
}

Future<void> deleteMidwifeAlert(int id, BuildContext context) async {
  final response =
      await http.delete(Uri.parse('$baseUrl/midwives/$id'));

  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Midwife deleted successfully.'),
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to delete Midwife record.'),
      ),
    );
  }
}

Future<bool> editMidwife(int id, BuildContext context) async {
  final response =
      await http.put(Uri.parse('$baseUrl/doctors/$id'));

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

Future<bool> updateMidwife(
    int id, Midwife MidwifeData, BuildContext context) async {
  // Convert schedule list to string representation
  final scheduleString = jsonEncode(MidwifeData.schedule);

  final response =
      await http.put(Uri.parse('$baseUrl/doctors/$id'), body: {
    'name': MidwifeData.name,
    'salary': MidwifeData.salary.toString(),
    'schedule': scheduleString,
    'startTime': MidwifeData.startTime,
    'endTime': MidwifeData.endTime,
    'report': MidwifeData.report,
    'newborn_bracelet_leg': MidwifeData.newbornBraceletLeg,
    'newborn_bracelet_hand': MidwifeData.newbornBraceletHand,
    'communication_skills': MidwifeData.communication,
    'mother_name': MidwifeData.motherName,
  });

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:my_vaccine_app/screens/mother/motherClass.dart';
import 'package:my_vaccine_app/screens/mother/motherUser.dart';

//create the info of mother in the hospital
Future<bool> createMother(Mother mother) async {
  final response = await http.post(
    Uri.parse('http://127.0.0.1:8000/api/createInfoOfMother'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(mother.toJson()),
  );
  if (response.statusCode == 201) {
    print('The mother was successfully created');
    return true;
  } else {
    print('Error creating mother: ${response.statusCode}');
    return false;
  }
}

Future<void> createMotherUser(MotherUser motherUser) async {
  final response = await http.post(
    Uri.parse('http://127.0.0.1:8000/api/createMotherUser'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(motherUser.toJson()),
  );
  if (response.statusCode == 201) {
    print('The mother user was successfully created');
  } else {
    print('Error creating mother user: ${response.statusCode}');
  }
}

Future<bool> checkIdentityNumber(String identityNumber) async {
  final response = await http.get(
    Uri.parse(
        'http://127.0.0.1:8000/api/check-identity-number/$identityNumber'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    final responseBody = jsonDecode(response.body);
    return responseBody['exists'] ?? false;
  } else {
    throw Exception('Failed to check identity number');
  }
}

Future<List<Map<String, dynamic>>> fetchNewborns(
    String motherIdentityNumber) async {
  final response = await http.get(
    Uri.parse('http://127.0.0.1:8000/api/newborns/$motherIdentityNumber'),
  );

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    List<Map<String, dynamic>> newbornsData = [];

    for (var data in jsonData['data']) {
      Map<String, dynamic> newbornData = {
        'identity_number': data['identity_number'] ?? '',
        'id': data['id'] ?? '',
        'firstName': data['firstName'] ?? '',
        'lastName': data['lastName'] ?? '',
        'date_of_birth': data['date_of_birth'] ?? '',
        'time_of_birth': data['time_of_birth'] ?? '',
        'gender': data['gender'] ?? '',
        'weight': data['weight'] ?? '',
        'length': data['length'] ?? '',
        'status': data['status'] ?? '',
        'delivery_method': data['delivery_method'] ?? '',
        'mother_id': data['mother_id'] ?? '',
        // 'first_name':
        //     data['mother']['first_name'] ?? '', // Include mother's first name
        'location_id': data['location_id'] ?? '',
        'health_center_id': data['health_center_id'] ?? '',
        'hospital_center_id': data['hospital_center_id'] ?? '',
        'measurement_id': data['measurement_id'] ?? '',
        'ministry_center_id': data['ministry_center_id'] ?? '',
        'doctor_id': data['doctor_id'] ?? '',
        'nurse_id': data['nurse_id'] ?? '',
        'midwife_id': data['midwife_id'] ?? '',
        'newborn_hospital_nursery_id':
            data['newborn_hospital_nursery_id'] ?? '',
      };
      newbornsData.add(newbornData);
    }

    return newbornsData;
  } else {
    throw Exception('Failed to fetch newborns');
  }
}

// Future<Map<String, dynamic>> getMotherData(int id) async {
//   final url = Uri.parse('http://127.0.0.1:8000/api/mothers/$id');
//   final response = await http.get(url);

//   if (response.statusCode == 200) {
//     final responseData = jsonDecode(response.body);
//     final success = responseData['success'];
//     final data = responseData['data'];
//     final motherId = data['id'];
//     return {'success': success, 'data': data, 'id': motherId};
//   } else {
//     throw Exception('Failed to load mother data.');
//   }
// }

Future<Mother> fetchMother(int motherId) async {
  final response =
      await http.get(Uri.parse('http://127.0.0.1:8000/api/mothers/$motherId'));
  if (response.statusCode == 200) {
    return Mother.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load mother');
  }
}

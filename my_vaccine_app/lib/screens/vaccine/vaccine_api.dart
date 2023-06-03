import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_vaccine_app/screens/vaccine/vaccine.dart';

Future<void> storeVaccine(Vaccine vaccine) async {
  final url = Uri.parse('http://127.0.0.1:8000/api/storeVaccine');
  final headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  };
  final body = jsonEncode(vaccine.toJson());

  try {
    final response = await http.post(url, headers: headers, body: body);
    print('Response: ${response.statusCode} - ${response.body}');
    if (response.statusCode == 201) {
      // Vaccine stored successfully
      print('Vaccine created successfully.');
    } else {
      // Error occurred while storing vaccine
      print('Failed to create vaccine.');
    }
  } catch (error) {
    // Error occurred during the API request
    print('Error: $error');
  }
}

Future<void> deleteVaccine(int id, BuildContext context) async {
  final response =
      await http.delete(Uri.parse('http://127.0.0.1:8000/api/vaccines/$id'));

  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Vaccine deleted successfully.'),
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to delete vaccine record.'),
      ),
    );
  }
}

Future<bool> editVaccine(int id, BuildContext context) async {
  final response =
      await http.put(Uri.parse('http://127.0.0.1:8000/api/vaccine/$id'));

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

Future<Vaccine> fetchVaccine(int VaccineId) async {
  final response = await http
      .get(Uri.parse('http://127.0.0.1:8000/api/vaccines/$VaccineId'));
  if (response.statusCode == 200) {
    return Vaccine.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load Vaccine');
  }
}

// Future<List<Map<String, dynamic>>> fetchVaccines() async {
//   final url = Uri.parse('http://127.0.0.1:8000/api/vaccines/create');

//   try {
//     final response = await http.post(
//       url,
//       body: {
//         'identity_number': 'YOUR_IDENTITY_NUMBER',
//         'vaccine_name': 'Vaccine Name',
//         'doctor_name': 'Doctor Name',
//         'vaccine_month': 'Vaccine Month',
//         'vaccine_date': 'Vaccine Date',
//       },
//     );

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       return List<Map<String, dynamic>>.from(data);
//     } else {
//       throw Exception('Request failed with status: ${response.statusCode}');
//     }
//   } catch (error) {
//     throw Exception('Request failed with error: $error');
//   }
// }

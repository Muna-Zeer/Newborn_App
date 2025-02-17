import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_vaccine_app/apiServer.dart';
import 'package:my_vaccine_app/screens/vaccine/vaccine.dart';
import 'package:my_vaccine_app/screens/vaccine/vaccineModel.dart';

Future<void> storeVaccine(Vaccine vaccine) async {
  final baseUrl = ApiService.getBaseUrl();

  final url = Uri.parse('$baseUrl/storeVaccine');
  final headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  };
  final body = jsonEncode(vaccine.toJson());

  try {
    final response = await http.post(url, headers: headers, body: body);
    throw Exception('Response: ${response.statusCode} - ${response.body}');
  } catch (error) {
    // Error occurred during the API request
    throw Exception('Error: $error');
  }
}

Future<void> deleteVaccine(int id, BuildContext context) async {
  final baseUrl = ApiService.getBaseUrl();

  final response = await http.delete(Uri.parse('$baseUrl/vaccines/$id'));

  if (response.statusCode == 200) {
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Vaccine deleted successfully.'),
      ),
    );
  } else {
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Failed to delete vaccine record.'),
      ),
    );
  }
}

Future<bool> editVaccine(int id, BuildContext context) async {
  final baseUrl = ApiService.getBaseUrl();

  final response = await http.put(Uri.parse('$baseUrl/vaccine/$id'));

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

Future<Vaccine> fetchVaccine(int vaccineId) async {
  final baseUrl = ApiService.getBaseUrl();

  final response = await http.get(Uri.parse('$baseUrl/vaccines/$vaccineId'));
  if (response.statusCode == 200) {
    return Vaccine.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load Vaccine');
  }
}

Future<void> updateVaccine(
    String id, Map<String, dynamic> updatedVaccine) async {
  final baseUrl = ApiService.getBaseUrl();
  final response = await http.put(
    Uri.parse('$baseUrl/vaccines/$id'),
    body: json.encode(updatedVaccine),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    throw Exception('Vaccine record updated successfully');
  } else {
    throw Exception('Failed to update vaccine record: ${response.statusCode}');
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

Future<List<VaccineData>> fetchNewbornVaccine(String identityNumber) async {
  final baseUrl = ApiService.getBaseUrl();
  final url = '$baseUrl/newborn/$identityNumber/vaccines';
  print("Fetching from: $url"); // Debugging

  final response = await http.get(Uri.parse(url));
  print("Response Code: ${response.statusCode}");
  print("Response Body: ${response.body}");

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = json.decode(response.body);
    if (responseData['status'] == 'success' && responseData.containsKey('vaccines')) {
      final List<dynamic> vaccineList = responseData['vaccines'];
      return vaccineList.map((json) => VaccineData.fromJson(json)).toList();
    } else {
      throw Exception('Invalid API response structure');
    }
  } else {
    throw Exception('Request failed with status: ${response.statusCode}');
  }
}

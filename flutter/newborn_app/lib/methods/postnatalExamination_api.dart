import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:newborn_app/constant/models/postnatalExaminations.dart';

Future<bool> createPostnatalExamination(
    PostnatalExaminations examination) async {
  final response = await http.post(
    Uri.parse('http://127.0.0.1:8000/api/postnatalExaminations'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(examination.toJson()),
  );
  if (response.statusCode == 201) {
    print('The postnatal examination was successfully created');
    return true;
  } else {
    print('Error creating postnatal examination: ${response.statusCode}');
    return false;
  }
}

Future<void> deletePostnatalExamination(int id, BuildContext context) async {
  final response = await http
      .delete(Uri.parse('http://127.0.0.1:8000/api/postnatalExamination/$id'));

  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Doctor deleted successfully.'),
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to delete examination record.'),
      ),
    );
  }
}

Future<PostnatalExaminations> fetchPostnatalEdit(int postnatalId) async {
  final response = await http.get(Uri.parse(
      'http://127.0.0.1:8000/api/postnatalExaminations/$postnatalId'));
  if (response.statusCode == 200) {
    return PostnatalExaminations.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load doctor');
  }
}

Future<bool> editPostnatal(int id, BuildContext context) async {
  final response = await http
      .put(Uri.parse('http://127.0.0.1:8000/api/postnatalExamination/$id'));
  print('ide: $id');

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

Future<void> updatePostnatalExamination(
    PostnatalExaminations postnatalExamination) async {
  final url =
      'http://127.0.0.1:8000/api/postnatalExamination/${postnatalExamination.id}';
  final headers = {'Content-Type': 'application/json'};

  // Specify the columns to update in the JSON body
  final body = jsonEncode({
    'Temp': postnatalExamination.temp,
    'Pulse': postnatalExamination.pulse,
    'B_P': postnatalExamination.bp,
    'Hb': postnatalExamination.hb,
    'Seizures': postnatalExamination.seizures,
    'Remarks': postnatalExamination.remarks,
  });

  final response = await http.put(Uri.parse(url), headers: headers, body: body);

  if (response.statusCode == 200) {
    print('Postnatal Examination record updated successfully');
  } else {
    throw Exception('Failed to update Postnatal Examination record');
  }
}

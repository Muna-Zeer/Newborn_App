import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:newborn_app/constant/models/newbornAssessments.dart';

Future<bool> createNewbornAssessment(NewbornAssessments assessment) async {
  final response = await http.post(
    Uri.parse('http://127.0.0.1:8000/api/newbornAssessments'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(assessment.toJson()),
  );
  if (response.statusCode == 201) {
    print('The postnatal examination was successfully created');
    return true;
  } else if (response.statusCode == 204) {
    print('The request was successfully processed but no content was returned');
    return true;
  } else {
    print('Error creating postnatal examination: ${response.statusCode}');
    return false;
  }
}

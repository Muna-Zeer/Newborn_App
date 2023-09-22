import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newborn_app/apiService.dart';
import 'dart:convert';
import 'package:newborn_app/constant/models/mother.dart';
import 'package:newborn_app/constant/models/motherExamination.dart';
import 'package:newborn_app/constant/models/newbornAssessments.dart';
final baseUrl = ApiService.getBaseUrl();
//create new record
Future<bool> createMotherExamination(MotherExaminations examination) async {
  final response = await http.post(
    Uri.parse('$baseUrl/motherExaminations'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(examination.toJson()),
  );
  print('value of response is $response');
  if (response.statusCode == 201) {
    print('The mother examination was successfully created');
    print('value of response is $response');
    return true;
  } else {
    print('Error creating mother examination: ${response.statusCode}');
    print('wrong of response is $response');
    return false;
  }
}

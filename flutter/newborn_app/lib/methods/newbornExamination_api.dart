import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newborn_app/apiService.dart';
import 'dart:convert';
import 'package:newborn_app/constant/models/mother.dart';
import 'package:newborn_app/constant/models/newbornExamination.dart';
final baseUrl = ApiService.getBaseUrl();
Future<bool> createNewbornExamination(NewbornExamination examination) async {
  final response = await http.post(
    Uri.parse('$baseUrl/newbornExaminations'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(examination.toJson()),
  );
  if (response.statusCode == 201) {
    print('The newborn examination was successfully created');
    return true;
  } else {
    print('Error creating newborn examination: ${response.statusCode}');
    return false;
  }
}

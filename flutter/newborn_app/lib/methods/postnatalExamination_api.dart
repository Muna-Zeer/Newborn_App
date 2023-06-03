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

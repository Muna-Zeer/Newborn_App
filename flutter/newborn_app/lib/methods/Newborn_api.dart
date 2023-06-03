import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newborn_app/constant/models/Newborn.dart';
import 'dart:convert';

//create new record
Future<bool> createNewborn(Newborn newborn) async {
  final response = await http.post(
    Uri.parse('http://127.0.0.1:8000/api/newborns'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(newborn.toJson()),
  );
  print('value of response is $response');
  if (response.statusCode == 201) {
    print('The newborn was successfully created');
    print('value of response is $response');
    return true;
  } else {
    print('Error creating newborn: ${response.statusCode}');
    print('wrong of response is $response');
    return false;
  }
}

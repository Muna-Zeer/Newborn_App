import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newborn_app/apiService.dart';
import 'dart:convert';

import 'package:newborn_app/constant/models/mother.dart';
final baseUrl = ApiService.getBaseUrl();
//get info of mother by motherId
Future<Mother> fetchMother(int motherId) async {
  final response =
      await http.get(Uri.parse('$baseUrl/mothers/$motherId'));
  if (response.statusCode == 200) {
    return Mother.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load mother');
  }
}

//create the info of mother in the hospital
Future<bool> createMother(Mother mother) async {
  final response = await http.post(
    Uri.parse('$baseUrl/createInfoOfMother'),
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

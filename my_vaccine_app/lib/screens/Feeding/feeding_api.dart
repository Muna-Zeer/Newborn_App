import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_vaccine_app/apiServer.dart';

Future<void> deletefeeding(int id, BuildContext context) async {
  final baseUrl = ApiService.getBaseUrl();
  final response =
      await http.delete(Uri.parse('$baseUrl/feedings/$id'));

  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('feeding deleted successfully.'),
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to delete feeding record.'),
      ),
    );
  }
}

Future<bool> editFeeding(int id, BuildContext context) async {
   final baseUrl = ApiService.getBaseUrl();
  final response =
      await http.put(Uri.parse('$baseUrl/feedings/$id'));

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

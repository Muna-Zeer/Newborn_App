import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_vaccine_app/apiServer.dart';

Future<void> deleteGuideline(int id, BuildContext context) async {
        final baseUrl = ApiService.getBaseUrl();

  final response =
      await http.delete(Uri.parse('$baseUrl/guidelines/$id'));

  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('guildline deleted successfully.'),
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to delete guildline record.'),
      ),
    );
  }
}

Future<bool> editguildline(int id, BuildContext context) async {
        final baseUrl = ApiService.getBaseUrl();

  final response =
      await http.put(Uri.parse('$baseUrl/guidelines/$id'));

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

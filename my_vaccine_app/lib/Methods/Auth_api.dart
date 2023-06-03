import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const API_URL = 'http://127.0.0.1:8000/api';

  Future<http.Response> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$API_URL/login'),
      body: {
        'email': email,
        'password': password,
      },
    );

    return response;
  }

  Future<void> logout() async {
    // Clear the access token from shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');

    // Retrieve the access token from shared preferences
    String? accessToken = prefs.getString('access_token');

    final response = await http.post(
      Uri.parse('$API_URL/logout'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    if (response.statusCode == 200) {
      // handle successful logout
    } else {
      // handle logout failure
    }
  }
}

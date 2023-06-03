// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class Auth {
//   static const API_URL = 'http://127.0.0.1:8000/api';

//   // Register a new user
//   static Future<Map<String, dynamic>> register({
//     required String name,
//     required String email,
//     required String password,
//     required String role,
//   }) async {
//     final response = await http.post(Uri.parse('$API_URL/register'), body: {
//       'name': name,
//       'email': email,
//       'password': password,
//       'role': role,
//     });
//     final responseData = json.decode(response.body);
//     if (response.statusCode == 200) {
//       final userData = responseData['user'];
//       final token = responseData['token'];
//       final prefs = await SharedPreferences.getInstance();
//       prefs.setString('token', token);
//       prefs.setString('userData', json.encode(userData));
//       return {'success': true, 'message': 'Registration successful'};
//     } else {
//       return {'success': false, 'message': responseData['message']};
//     }
//   }

//   // Login user
//   static Future<Map<String, dynamic>> login({
//     required String email,
//     required String password,
//   }) async {
//     final response = await http.post(Uri.parse('$API_URL/login'), body: {
//       'email': email,
//       'password': password,
//     });
//     final responseData = json.decode(response.body);
//     if (response.statusCode == 200) {
//       final userData = responseData['user'];
//       final token = responseData['token'];
//       final prefs = await SharedPreferences.getInstance();
//       prefs.setString('token', token);
//       prefs.setString('userData', json.encode(userData));
//       return {'success': true, 'message': 'Login successful'};
//     } else {
//       return {'success': false, 'message': responseData['message']};
//     }
//   }

//   // Logout user
//   static Future<void> logout() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token');
//     await http.post(
//       Uri.parse('$API_URL/logout'),
//       headers: {'Authorization': 'Bearer $token'},
//     );
//     prefs.remove('token');
//     prefs.remove('userData');
//   }

//   // Get the current user
//   static Future<Map<String, dynamic>> getUserData() async {
//     final prefs = await SharedPreferences.getInstance();
//     final userDataString = prefs.getString('userData');
//     if (userDataString != null) {
//       final userData = json.decode(userDataString);
//       return {'success': true, 'user': userData};
//     } else {
//       return {'success': false, 'message': 'User data not found'};
//     }
//   }

//   // Check if the user is authenticated
//   static Future<bool> isAuthenticated() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token');
//     return token != null;
//   }
// }

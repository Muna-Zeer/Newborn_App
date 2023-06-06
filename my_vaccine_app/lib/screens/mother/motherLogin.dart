import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_vaccine_app/apiServer.dart';
import 'dart:convert';

import 'package:my_vaccine_app/screens/mother/MotherAutoProfile.dart';
import 'package:my_vaccine_app/screens/mother/mother_api.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

class MotherLoginPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _identityNumberController = TextEditingController();
  final _phoneController = TextEditingController();

  //retrive token
  // Future<String> getDeviceToken() async {
  //   FirebaseMessaging messaging = FirebaseMessaging.instance;
  //   await messaging.requestPermission();
  //   String? token = await messaging.getToken();
  //   return token ?? '';
  // }

  Future<void> createMotherUser(Map<String, dynamic> motherUser) async {
    final baseUrl = ApiService.getBaseUrl();

    final response = await http.post(
      Uri.parse('$baseUrl/createMotherUser'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(motherUser),
    );
    if (response.statusCode == 201) {
      print('The mother user was successfully created');
    } else {
      print('Error creating mother user: ${response.statusCode}');
    }
  }

  void _login(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      bool isIdentityNumberMatched =
          await checkIdentityNumber(_identityNumberController.text);

      if (isIdentityNumberMatched) {
        print('Match: Identity number');

        // Create the motherUser map with user's input values
        Map<String, dynamic> motherUser = {
          'identity_number': _identityNumberController.text,
          'phone': _phoneController.text,
          'password': _passwordController.text,
          'username': _firstNameController.text,
        };

        // Send the request to create the mother user
        await createMotherUser(motherUser);

        var motherAutoProfile = MotherAutoProfile(
          motherData: {
            'identity_number': _identityNumberController.text,
          },
        );

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => motherAutoProfile),
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Invalid Identity Number'),
              content: Text('The entered identity number already exists.'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mother Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _identityNumberController,
                  decoration: InputDecoration(
                    labelText: 'Identity Number',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your identity number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone of Mother',
                    hintText: '(000) 000-0000',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a phone number';
                    }
                    final phoneRegExp = RegExp(r'^\d{10}$');
                    if (!phoneRegExp.hasMatch(value)) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _login(context),
                  child: Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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
          backgroundColor: Colors.lightBlue,
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                ' تسجيل دخول الام',
              ),
            ],
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.all(48.0),
            child: SingleChildScrollView(
              child: Center(
                child: Container(
                  width: 500,
                  margin: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 30.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 7, 26, 48)
                              .withOpacity(0.5),
                          spreadRadius: 8,
                          blurRadius: 15,
                          offset: const Offset(0, 2),
                        )
                      ]),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: TextFormField(
                            controller: _firstNameController,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0),
                            decoration: const InputDecoration(
                              labelText: 'الاسم الاول',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your first name';
                              }
                              return null;
                            },
                          ),
                        ),
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: TextFormField(
                            controller: _passwordController,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0),
                            decoration: const InputDecoration(
                              labelText: 'الرقم السري',
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                        ),
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: TextFormField(
                            controller: _identityNumberController,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0),
                            decoration: const InputDecoration(
                              labelText: 'رقم الهوية',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your identity number';
                              }
                              return null;
                            },
                          ),
                        ),
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: TextFormField(
                            controller: _phoneController,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0),
                            decoration: const InputDecoration(
                              labelText: 'رقم الهاتف',
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
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => _login(context),
                          child: Text('تسجيل الدخول',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0)),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.lightBlue),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )));
  }
}

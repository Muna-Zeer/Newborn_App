import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_vaccine_app/apiServer.dart';
import 'package:my_vaccine_app/screens/Newborns/newborn.dart';
import 'dart:convert';

import 'package:my_vaccine_app/screens/mother/mother_api.dart';

class MotherAutoProfile extends StatefulWidget {
  final Map<String, dynamic> motherData;

  MotherAutoProfile({required this.motherData});

  @override
  _MotherAutoProfileState createState() => _MotherAutoProfileState();
}

class _MotherAutoProfileState extends State<MotherAutoProfile> {
  Map<String, dynamic>? autoProfile;

  @override
  void initState() {
    super.initState();
    createAutoProfile();
  }

  void createAutoProfile() async {
    final identityNumber = widget.motherData['identity_number'];
          final baseUrl = ApiService.getBaseUrl();

    final url = Uri.parse(
        '$baseUrl/autoProfileMother/$identityNumber');
    final response = await http.get(url);
    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      setState(() {
        final responseData = jsonDecode(response.body);
        autoProfile = responseData['mother'];
      });
    } else {
      throw Exception('Failed to retrieve auto profile.');
    }
  }

  void navigateToNewbornPage(String identityNumber) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => NewbornPage(identityNumber: identityNumber)),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mother Auto Profile'),
      ),
      body: autoProfile != null
          ? SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      // onTap: () {
                      //   NewbornDetailsPage(autoProfile!['newborn_id']);
                      // },
                      child: Text(
                        'Identity Number Newborn: ${autoProfile!['newborn_id']}',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text('Address: ${autoProfile!['address']}'),
                    Text('Phone Number: ${autoProfile!['phone_number']}'),
                    Text('Identity Number: ${autoProfile!['identity_number']}'),
                    Text('Email: ${autoProfile!['email']}'),
                    Text('Date of Birth: ${autoProfile!['date_of_birth']}'),
                    Text('Husband Name: ${autoProfile!['husband_name']}'),
                    Text(
                        'Number of Newborns: ${autoProfile!['number_of_newborns']}'),
                    Text('City: ${autoProfile!['city']}'),
                    Text('Country: ${autoProfile!['country']}'),
                    Text('Blood Type: ${autoProfile!['blood_type']}'),
                    Text('Age: ${autoProfile!['age']}'),
                    Text('Rhesus Factor: ${autoProfile!['rhesusFactor']}'),
                    SizedBox(height: 20),
                    Text(
                      'Newborns:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    NewbornsWidget(
                      motherIdentityNumber: autoProfile!['identity_number'],
                    ),
                  ],
                ),
              ),
            )
          : CircularProgressIndicator(),
    );
  }
}

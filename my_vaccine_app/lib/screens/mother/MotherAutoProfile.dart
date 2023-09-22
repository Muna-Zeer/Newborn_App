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

    final url = Uri.parse('$baseUrl/autoProfileMother/$identityNumber');
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
        title: Text('معلومات عن الأم'),
      ),
      body: autoProfile != null
          ? SingleChildScrollView(
              child: Center(
              child: Padding(
                padding: EdgeInsets.only(top: 60),
                child: Column(children: [
                  Text(
                    'معلومات عن الأم',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    color: Colors.blue[50],
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 30, right: 30, top: 30, bottom: 70),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8.0),
                          SizedBox(
                            width: 750,
                            height: 40.0,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                ' ${autoProfile!['first_name']} ${autoProfile!['last_name']} اسم الام: ',
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          SizedBox(
                            width: 750,
                            height: 40.0,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                'رقم الهوية: ${autoProfile!['identity_number']}',
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          SizedBox(
                            width: 750,
                            height: 40.0,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                'رقم الهاتف: ${autoProfile!['phone_number']}',
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 750.0,
                            height: 40.0,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                'عنوان: ${autoProfile!['address']}',
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          SizedBox(
                            width: 750,
                            height: 40.0,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                'ايميل: ${autoProfile!['email']}',
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          SizedBox(
                            width: 750,
                            height: 40.0,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                'تاريخ الميلاد: ${autoProfile!['date_of_birth']}',
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          SizedBox(
                            width: 750,
                            height: 40.0,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                'اسم الزوج: ${autoProfile!['husband_name']}',
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          SizedBox(
                            width: 750,
                            height: 40.0,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                'عدد الاطفال: ${autoProfile!['number_of_newborns']}',
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          SizedBox(
                            width: 750,
                            height: 40.0,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                'مدينة: ${autoProfile!['city']}',
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          SizedBox(
                            width: 750,
                            height: 40.0,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                'بلد: ${autoProfile!['country']}',
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          SizedBox(
                            width: 750,
                            height: 40.0,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                '  عمر: ${autoProfile!['age']}',
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          SizedBox(
                            width: 750,
                            height: 40.0,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                '  فصيلة دم: الأم ${autoProfile!['blood_type']}',
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          SizedBox(
                            width: 750,
                            height: 40.0,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                ' العامل:الريزبسي  ${autoProfile!['rhesusFactor']}',
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          SizedBox(height: 8.0),
                          NewbornsWidget(
                            motherIdentityNumber:
                                autoProfile!['identity_number'],
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
            ))
          : CircularProgressIndicator(),
    );
  }
}

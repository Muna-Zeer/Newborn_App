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
    try {
      final identityNumber = widget.motherData['identity_number'];
      print('Identity Number: $identityNumber');

      final baseUrl = ApiService.getBaseUrl();
      final url = Uri.parse('$baseUrl/autoProfileMother/$identityNumber');

      print('Requesting: $url');

      final response = await http.get(url);
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          autoProfile = responseData['mother'];
        });
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception('Error: ${errorData['message']}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to retrieve auto profile: $e')),
      );
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
        title: const Text('معلومات عن الأم'),
      ),
      body: autoProfile != null
          ? SingleChildScrollView(
              child: Center(
              child: Padding(
                padding: EdgeInsets.only(top: 60),
                child: Column(children: [
                  const Text(
                    'معلومات عن الأم',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                      width: 1000,
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        color: const Color.fromARGB(255, 0, 9, 15),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              const SizedBox(height: 8.0),
                              Container(
                                width: 900,
                                height: 80.0,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 238, 245, 252),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'اسم الام: ${autoProfile!['first_name']}   ${autoProfile!['last_name']}  ',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[800],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              SizedBox(
                                child: Container(
                                  width: 900,
                                  height: 80.0,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 238, 245, 252),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'رقم الهوية: ${autoProfile!['identity_number']}',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[800],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              SizedBox(
                                child: Container(
                                  width: 900,
                                  height: 80.0,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 238, 245, 252),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'رقم الهاتف: ${autoProfile!['phone_number']}',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[800],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              SizedBox(
                                child: Container(
                                  width: 900,
                                  height: 80.0,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 238, 245, 252),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'عنوان: ${autoProfile!['address']}',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[800],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              SizedBox(
                                child: Container(
                                  width: 900,
                                  height: 80.0,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 238, 245, 252),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          ' ${autoProfile!['email']} الايميل',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[800],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              SizedBox(
                                child: Container(
                                  width: 900,
                                  height: 80.0,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 238, 245, 252),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'تاريخ الميلاد: ${autoProfile!['date_of_birth']}',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[800],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              SizedBox(
                                child: Container(
                                  width: 900,
                                  height: 80.0,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 238, 245, 252),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'اسم الزوج: ${autoProfile!['husband_name']}',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[800],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 8.0),
                              SizedBox(
                                child: Container(
                                  width: 900,
                                  height: 80.0,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 238, 245, 252),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'عدد الاطفال: ${autoProfile!['number_of_newborns']}',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[800],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              SizedBox(
                                child: Container(
                                  width: 900,
                                  height: 80.0,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 238, 245, 252),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'مدينة: ${autoProfile!['city']}',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[800],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 8.0),
                              SizedBox(
                                child: Container(
                                  width: 900,
                                  height: 80.0,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 238, 245, 252),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        autoProfile!['date_of_birth'] != null
                                            ? FutureBuilder<int>(
                                                future: calculateAge(
                                                    DateTime.parse(autoProfile![
                                                        'date_of_birth'])),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return Text(
                                                      'جاري الحساب...',
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.grey[800],
                                                      ),
                                                    );
                                                  } else if (snapshot
                                                      .hasError) {
                                                    return Text(
                                                      'حدث خطأ في الحساب',
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.red,
                                                      ),
                                                    );
                                                  } else {
                                                    return Text(
                                                      'العمر: ${snapshot.data} سنة',
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.grey[800],
                                                      ),
                                                    );
                                                  }
                                                },
                                              )
                                            : Text(
                                                'تاريخ الميلاد غير متوفر',
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey[800],
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              SizedBox(
                                  child: Container(
                                width: 900,
                                height: 80.0,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 238, 245, 252),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        ' ${autoProfile!['blood_type']}  : فصيلة الدم   ',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[800],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                              const SizedBox(height: 16.0),
                              NewbornsWidget(
                                motherIdentityNumber:
                                    autoProfile!['identity_number'],
                                  motherName:autoProfile!['first_name'] +
                                      ' ' +
                                      autoProfile!['last_name'],
                              ),
                              const SizedBox(height: 32.0),
                            ],
                          ),
                        ),
                      )),
                ]),
              ),
            ))
          : const CircularProgressIndicator(),
    );
  }
}

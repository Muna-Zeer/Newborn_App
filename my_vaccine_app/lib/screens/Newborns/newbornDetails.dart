import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:my_vaccine_app/screens/vaccine/VaccineDetails.dart';

class NewbornDetailsPage extends StatefulWidget {
  final Map<String, dynamic> newbornData;

  NewbornDetailsPage({required this.newbornData});

  @override
  _NewbornDetailsPageState createState() => _NewbornDetailsPageState();
}

class _NewbornDetailsPageState extends State<NewbornDetailsPage> {
  // List<Map<String, dynamic>> vaccines = [];

  @override
  // void initState() {
  //   super.initState();
  //   fetchVaccines();
  // }

  // Future<void> fetchVaccines() async {
  //   final url = Uri.parse(
  //       'http://127.0.0.1:8000/api/vaccines/${widget.newbornData['id']}');

  //   try {
  //     final response = await http.get(url);

  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);

  //       // Check if the 'vaccines' field is null
  //       if (data['vaccines'] == null) {
  //         throw Exception("Received null value for 'vaccines'");
  //       }

  //       final vaccinesData = data['vaccines'];

  //       setState(() {
  //         // vaccines = List<Map<String, dynamic>>.from(vaccinesData);
  //       });
  //     } else {
  //       throw Exception('Request failed with status: ${response.statusCode}');
  //     }
  //   } catch (error) {
  //     throw Exception('Request failed with error: $error');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'معلومات عن الطفل ',
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(top: 60),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                color: Colors.blue[50],
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 100, right: 100, top: 30, bottom: 70),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 350.0,
                        height: 40.0,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                              'رقم هوية الطفل: ${widget.newbornData['identity_number']}',
                              textAlign: TextAlign.right),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      SizedBox(
                        width: 350,
                        height: 40.0,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text('الرقم: ${widget.newbornData['id']}',
                              textAlign: TextAlign.right),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      SizedBox(
                        width: 350,
                        height: 40.0,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                              'الاسم الاول: ${widget.newbornData['firstName']}',
                              textAlign: TextAlign.right),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      SizedBox(
                        width: 350,
                        height: 40.0,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                              'الاسم الاخير: ${widget.newbornData['lastName']}',
                              textAlign: TextAlign.right),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      SizedBox(
                        width: 350,
                        height: 40.0,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                              'تاريخ الميلاد: ${widget.newbornData['date_of_birth']}',
                              textAlign: TextAlign.right),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      SizedBox(
                        width: 350,
                        height: 40.0,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text('الجنس: ${widget.newbornData['gender']}',
                              textAlign: TextAlign.right),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      // SizedBox(
                      //   width: 350,
                      //   height: 40.0,
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //       border: Border.all(
                      //         color: Colors.grey,
                      //         width: 1.0,
                      //       ),
                      //       borderRadius: BorderRadius.circular(8.0),
                      //     ),
                      //     child: Text(
                      //         'اسم الام: ${widget.newbornData['motherName']}',
                      //         textAlign: TextAlign.right),
                      //   ),
                      // ),
                      // SizedBox(height: 8.0),
                      // SizedBox(
                      //   width: 350,
                      //   height: 40.0,
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //       border: Border.all(
                      //         color: Colors.grey,
                      //         width: 1.0,
                      //       ),
                      //       borderRadius: BorderRadius.circular(8.0),
                      //     ),
                      //     child: Text(
                      //       'معلومات عن التطعيم:',
                      //       style: TextStyle(
                      //           fontSize: 18, fontWeight: FontWeight.bold),
                      //     ),
                      //   ),
                      // ),
                      SizedBox(height: 8.0),
                      Container(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VaccineTable(
                                  identityNumber:
                                      widget.newbornData['identity_number'],
                                  newbornName: widget.newbornData['firstName'] +
                                      ' ' +
                                      widget.newbornData['lastName'],
                                ),
                              ),
                            );
                          },
                          child: Text('معلومات التطعيم',
                              textAlign:
                                  TextAlign.right), // Add a child widget here
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

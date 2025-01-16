import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:my_vaccine_app/apiServer.dart';
import 'package:my_vaccine_app/screens/vaccine/VaccineDetails.dart';

class NewbornDetailsPage2 extends StatefulWidget {
  final Map<String, dynamic> newbornData;

  NewbornDetailsPage2({required this.newbornData});

  @override
  _NewbornDetailsPageState createState() => _NewbornDetailsPageState();
}

class _NewbornDetailsPageState extends State<NewbornDetailsPage2> {
  List<Map<String, dynamic>> vaccines = [];

  @override
  void initState() {
    super.initState();
    fetchVaccines();
  }

  Future<void> fetchVaccines() async {
    final baseUrl = ApiService.getBaseUrl();
    final url = Uri.parse('$baseUrl/vaccines/${widget.newbornData['id']}');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Check if the 'vaccines' field is null
        if (data['vaccines'] == null) {
          throw Exception("Received null value for 'vaccines'");
        }

        final vaccinesData = data['vaccines'];

        setState(() {
          vaccines = List<Map<String, dynamic>>.from(vaccinesData);
        });
      } else {
        throw Exception('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Request failed with error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'معلومات عن الطفل ',
              ),
            ],
          ),
          backgroundColor: Colors.lightBlue,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                color: Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.only(
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
                          child: Text('الرقم: ${widget.newbornData['id']}',
                              textAlign: TextAlign.right),
                        ),
                      ),
                      const SizedBox(height: 8.0),
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
                              'رقم هوية الطفل: ${widget.newbornData['identity_number']}',
                              textAlign: TextAlign.right),
                        ),
                      ),
                      const SizedBox(height: 8.0),
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
                              'الاسم : ${widget.newbornData['firstName']}${widget.newbornData['lastName']}  }',
                              textAlign: TextAlign.right),
                        ),
                      ),
                      const SizedBox(height: 8.0),
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
                      const SizedBox(height: 8.0),
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
                          child: Text(' ${widget.newbornData['gender']}الجنس:',
                              textAlign: TextAlign.right),
                        ),
                      ),
                      const SizedBox(height: 8.0),
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
                          child: Text('اسم الام: ${widget.newbornData}',
                              textAlign: TextAlign.right),
                        ),
                      ),
                      const SizedBox(height: 8.0),
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
                          child: const Text(
                            'معلومات عن التطعيم:',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8.0),
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
                          child: const Text('معلومات التطعيم',
                              textAlign: TextAlign.right),
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

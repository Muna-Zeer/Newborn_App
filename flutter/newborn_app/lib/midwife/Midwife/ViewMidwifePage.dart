import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:newborn_app/constant/models/midwifem.dart';
import 'package:newborn_app/methods/doctor_api.dart';

class MidwifePage extends StatefulWidget {
  final Midwife midwife;
  MidwifePage({
    Key? key,
    required this.midwife,
  }) : super(key: key);

  @override
  _MidwifePageState createState() => _MidwifePageState();
}

class _MidwifePageState extends State<MidwifePage> {
  Map<String, dynamic> _schedule = {};

  Map<String, dynamic> _midwife = {};
  String? _hospitalName;
  String? _ministryOfHealthName;
  String? _doctorName;

  Future<void> fetchSchedule() async {
    final response = await http.get(Uri.parse(
        'http://127.0.0.1:8000/api/allMidwives/${widget.midwife.id}'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final scheduleData = jsonDecode(jsonData['data']['schedule']);

      if (scheduleData is Map<String, dynamic>) {
        setState(() {
          _schedule = scheduleData;
        });
      } else {
        throw Exception('Invalid schedule data');
      }
    } else {
      throw Exception('Failed to fetch schedule');
    }
  }

  Future<void> fetchMidwifeData() async {
    final response = await http.get(Uri.parse(
      'http://127.0.0.1:8000/api/allMidwives/${widget.midwife.id}',
    ));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final midwifeData = jsonData['data'];
      final hospitalId = midwifeData['hospital_id'];
      final doctorId = midwifeData['doctor_id'];

      print('Hospital ID: $hospitalId');
      print('doctor ID: $doctorId');

      final hospitalName = await fetchHospitalName(hospitalId);
      final doctorName = await fetchDoctorHospital(doctorId);

      print('Hospital Name: $hospitalName');
      print('doctor Name: $doctorName');

      setState(() {
        _midwife = midwifeData;
        _hospitalName = hospitalName;
        _doctorName = doctorName;
      });
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  Future<String> fetchMinistryName(int ministryId) async {
    final response = await http
        .get(Uri.parse('http://127.0.0.1:8000/api/ministry/$ministryId'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final ministryName = data['data']['name'];
      return ministryName;
    } else {
      throw Exception('Failed to fetch ministry data');
    }
  }

  Future<String> fetchHospitalName(int hospitalId) async {
    try {
      final response = await http
          .get(Uri.parse('http://127.0.0.1:8000/api/hospitals/$hospitalId'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final hospitalName = data['data']['name'];
        return hospitalName;
      } else {
        throw Exception('Failed to fetch hospital data');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to fetch hospital data');
    }
  }

  Future<String> fetchDoctorHospital(int doctorId) async {
    final response = await http
        .get(Uri.parse('http://127.0.0.1:8000/api/doctors/$doctorId'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final hospitalName = data['data']['name'];
      return hospitalName;
    } else {
      throw Exception('Failed to fetch hospital data');
    }
  }

  @override
  void initState() {
    fetchSchedule();
    fetchMidwifeData();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Midwife Details'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              margin: EdgeInsets.all(16.0),
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _midwife['name'] ?? '',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Icon(Icons.email, size: 20),
                      SizedBox(width: 8.0),
                      Text(_midwife['salary'] ?? ''),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Icon(Icons.location_city, size: 20),
                      SizedBox(width: 8.0),
                      Text(_midwife['hours'] ?? ''),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Icon(Icons.business_center, size: 20),
                      SizedBox(width: 8.0),
                      Text(_midwife['mother_name'] ?? ''),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Icon(Icons.attach_money, size: 20),
                      SizedBox(width: 8.0),
                      Text(_midwife['newborn_bracelet_hand'] ?? ''),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Icon(Icons.attach_money, size: 20),
                      SizedBox(width: 8.0),
                      Text(_midwife['newborn_bracelet_leg'] ?? ''),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      'Hospital: $_hospitalName',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      'Ministry of Health: $_ministryOfHealthName',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      'doctor: $_doctorName',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(16.0),
              child: Text(
                'Schedule',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      'List Details',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Name: ${_midwife['name']}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'newborn_bracelet_hand: ${_midwife['newborn_bracelet_hand']}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'newborn_bracelet_leg: ${_midwife['newborn_bracelet_leg']}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Hours: ${_midwife['hours']}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      'communication Skills: ${_midwife['communication_skills']}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      _midwife['name'] ?? '',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  // Container(
                  //   margin: EdgeInsets.only(bottom: 16.0),
                  //   child: Text(
                  //     'Hospital: ${_hospitalName.toString()}',
                  //     style: TextStyle(fontSize: 16),
                  //   ),
                  // ),
                  Container(
                    margin: EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      'Schedule',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SingleChildScrollView(
                    child: DataTable(
                      columns: const <DataColumn>[
                        DataColumn(
                          label: Text(
                            'Day',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.black),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Start Time',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.black),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'End Time',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.black),
                          ),
                        ),
                      ],
                      rows: List<DataRow>.generate(
                        _schedule.length,
                        (int index) => DataRow(
                          cells: <DataCell>[
                            DataCell(Text(_schedule.keys.toList()[index],
                                style: TextStyle(color: Colors.black))),
                            DataCell(Text(
                                _schedule.values.toList()[index]['startTime'] !=
                                        null
                                    ? _schedule.values.toList()[index]
                                        ['startTime']
                                    : 'don\'t work',
                                style: TextStyle(color: Colors.black))),
                            DataCell(Text(
                                _schedule.values.toList()[index]['endTime'] !=
                                        null
                                    ? _schedule.values.toList()[index]
                                        ['endTime']
                                    : 'don\'t work',
                                style: TextStyle(color: Colors.black))),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

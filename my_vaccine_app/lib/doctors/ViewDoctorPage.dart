import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_vaccine_app/apiServer.dart';
import 'package:my_vaccine_app/doctors/doctor.dart';

class ViewDoctorPage extends StatefulWidget {
  final Doctor doctor;

  const ViewDoctorPage({required this.doctor});

  @override
  _ViewDoctorPageState createState() => _ViewDoctorPageState();
}

class _ViewDoctorPageState extends State<ViewDoctorPage> {
  Map<String, dynamic> _schedule = {};
  Map<String, dynamic> _doctor = {};
  String? _hospitalName;
  String? _ministryOfHealthName;
  final baseUrl = ApiService.getBaseUrl();
  Future<void> fetchSchedule() async {
    final response =
        await http.get(Uri.parse('$baseUrl/allDoctors/${widget.doctor.id}'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final scheduleData = jsonData['data']['schedule'];
      setState(() {
        _schedule = scheduleData;
      });
    } else {
      throw Exception('Failed to fetch schedule');
    }
  }

  Future<void> fetchDoctorData() async {
    final response =
        await http.get(Uri.parse('$baseUrl/allDoctors/${widget.doctor.id}'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final doctorData = jsonData['data'];
      final hospitalId = doctorData['hospital_id'];
      final ministryId = doctorData['ministry_of_health_id'];

      final hospitalName = await fetchHospitalName(hospitalId);
      final ministryName = await fetchMinistryName(ministryId);

      setState(() {
        _doctor = doctorData;
        _hospitalName = hospitalName;
        _ministryOfHealthName = ministryName;
      });
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  Future<String> fetchMinistryName(int ministryId) async {
    final response = await http.get(Uri.parse('$baseUrl/ministry/$ministryId'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final ministryName = data['data']['name'];
      return ministryName;
    } else {
      throw Exception('Failed to fetch ministry data');
    }
  }

  Future<String> fetchHospitalName(int hospitalId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/hospitals/$hospitalId'));
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
    fetchDoctorData();
    super.initState();
  }

//   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Details'),
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
                    _doctor['name'] ?? '',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Icon(Icons.email, size: 20),
                      SizedBox(width: 8.0),
                      Text(_doctor['email'] ?? ''),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Icon(Icons.location_city, size: 20),
                      SizedBox(width: 8.0),
                      Text(_doctor['city'] ?? ''),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Icon(Icons.business_center, size: 20),
                      SizedBox(width: 8.0),
                      Text(_doctor['specialization'] ?? ''),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Icon(Icons.attach_money, size: 20),
                      SizedBox(width: 8.0),
                      Text(_doctor['salary'] ?? ''),
                    ],
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
                      'Doctor Details',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Name: ${_doctor['name']}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Specialization: ${_doctor['specialization']}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Country: ${_doctor['country']}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'City: ${_doctor['city']}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      'Email: ${_doctor['email']}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      _doctor['name'] ?? '',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      'Hospital: $_hospitalName',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      'Ministry of Health: $_ministryOfHealthName',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    child: const Text(
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

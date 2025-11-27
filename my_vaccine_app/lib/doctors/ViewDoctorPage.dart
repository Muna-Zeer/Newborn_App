import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_vaccine_app/apiServer.dart';
import 'package:my_vaccine_app/doctors/doctor.dart';
import 'package:my_vaccine_app/widget/BuildInfoRow.dart';

class ViewDoctorPage extends StatefulWidget {
  final Doctor doctor;

  const ViewDoctorPage({super.key, required this.doctor});

  @override
  _ViewDoctorPageState createState() => _ViewDoctorPageState();
}

class _ViewDoctorPageState extends State<ViewDoctorPage> {
  Map<String, dynamic> _schedule = {};
  Map<String, dynamic> _doctor = {};
  String? _hospitalName;
  String? _ministryOfHealthName;

  final baseUrl = ApiService.getBaseUrl();

  @override
  void initState() {
    super.initState();
    fetchDoctorData();
    fetchSchedule();
  }

  Future<void> fetchSchedule() async {
    final response =
        await http.get(Uri.parse('$baseUrl/allDoctors/${widget.doctor.id}'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      dynamic scheduleData = jsonData['data']['schedule'];

      // Handle null or empty string
      if (scheduleData == null || scheduleData == '' || scheduleData == '[]') {
        scheduleData = <String, dynamic>{};
      } else if (scheduleData is String) {
        try {
          final decoded = jsonDecode(scheduleData);
          if (decoded is Map) {
            scheduleData = Map<String, dynamic>.from(decoded);
          } else if (decoded is List) {
            // Convert list to a map by index or 'day' key
            final Map<String, dynamic> formatted = {};
            for (var item in decoded) {
              if (item is Map && item.containsKey('day')) {
                formatted[item['day']] = {
                  'startTime': item['start'] ?? '',
                  'endTime': item['end'] ?? '',
                };
              }
            }
            scheduleData = formatted;
          } else {
            scheduleData = <String, dynamic>{};
          }
        } catch (_) {
          scheduleData = <String, dynamic>{};
        }
      } else if (scheduleData is List) {
        final Map<String, dynamic> formatted = {};
        for (var item in scheduleData) {
          if (item is Map && item.containsKey('day')) {
            formatted[item['day']] = {
              'startTime': item['start'] ?? '',
              'endTime': item['end'] ?? '',
            };
          }
        }
        scheduleData = formatted;
      } else if (scheduleData is Map) {
        scheduleData = Map<String, dynamic>.from(scheduleData);
      }

      setState(() => _schedule = scheduleData as Map<String, dynamic>);
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
      final hospitalName = await fetchHospitalName(doctorData['hospital_id']);
      final ministryName =
          await fetchMinistryName(doctorData['ministry_of_health_id']);

      setState(() {
        _doctor = doctorData;
        _hospitalName = hospitalName;
        _ministryOfHealthName = ministryName;
      });
    } else {
      throw Exception('Failed to fetch doctor data');
    }
  }

  Future<String> fetchHospitalName(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/hospitals/$id'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data']['name'] ?? 'Unknown';
    }
    return 'Unknown';
  }

  Future<String> fetchMinistryName(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/ministry/$id'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data']['name'] ?? 'Unknown';
    }
    return 'Unknown';
  }


  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Doctor Profile'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 3,
      ),
      body: _doctor.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: Flex(
                    direction: isWide ? Axis.horizontal : Axis.vertical,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // LEFT PROFILE CARD
                      Expanded(
                        flex: isWide ? 2 : 0,
                        child: Card(
                          elevation: 6,
                          shadowColor: Colors.black26,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          margin: const EdgeInsets.all(12),
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 60,
                                  backgroundColor: Colors.blue.shade50,
                                  backgroundImage: (_doctor['image'] != null &&
                                          _doctor['image']
                                              .toString()
                                              .isNotEmpty)
                                      ? NetworkImage(
                                          '$baseUrl/doctor-image/${_doctor['image']}')
                                      : null,
                                  child: (_doctor['image'] == null ||
                                          _doctor['image'].toString().isEmpty)
                                      ? const Icon(Icons.person,
                                          size: 70, color: Colors.blueAccent)
                                      : null,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _doctor['name'] ?? 'Unknown Doctor',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _doctor['specialization'] ??
                                      'No specialization',
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.black54),
                                ),
                                const SizedBox(height: 20),
                                const Divider(height: 20, thickness: 1),
                                const SizedBox(height: 12),
                                buildInfoRow(
                                    Icons.email, _doctor['email'] ?? 'N/A'),
                                buildInfoRow(
                                    Icons.phone, _doctor['phone'] ?? 'N/A'),
                                buildInfoRow(Icons.location_city,
                                    _doctor['city'] ?? 'N/A'),
                                buildInfoRow(
                                    Icons.public, _doctor['country'] ?? 'N/A'),
                                buildInfoRow(Icons.local_hospital,
                                    'Hospital: ${_hospitalName ?? "Unknown"}'),
                                buildInfoRow(Icons.apartment,
                                    'Ministry: ${_ministryOfHealthName ?? "Unknown"}'),
                                buildInfoRow(Icons.attach_money,
                                    'Salary: ${_doctor['salary'] ?? 'N/A'}'),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // RIGHT WORK SCHEDULE CARD

                      Expanded(
                        flex: isWide ? 3 : 0,
                        child: Card(
                            elevation: 5,
                            margin: const EdgeInsets.all(12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Work Schedule',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    _schedule.isEmpty
                                        ? const Center(
                                            child: Padding(
                                              padding: EdgeInsets.all(20),
                                              child: Text(
                                                'No schedule available.',
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          )
                                        : SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: DataTable(
                                              columnSpacing: 24,
                                              headingRowColor:
                                                  WidgetStateProperty.all(
                                                      Colors.blue.shade50),
                                              border: TableBorder.all(
                                                  color: Colors.grey.shade300),
                                              columns: const [
                                                DataColumn(
                                                    label: Text('Day',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold))),
                                                DataColumn(
                                                    label: Text('Start Time',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold))),
                                                DataColumn(
                                                    label: Text('End Time',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold))),
                                              ],
                                              rows: _schedule.entries
                                                  .map((entry) {
                                                final day = entry.key;
                                                final schedule = entry.value;
                                                return DataRow(cells: [
                                                  DataCell(Text(day)),
                                                  DataCell(Text(
                                                      schedule['startTime'] ??
                                                          '—')),
                                                  DataCell(Text(
                                                      schedule['endTime'] ??
                                                          '—')),
                                                ]);
                                              }).toList(),
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

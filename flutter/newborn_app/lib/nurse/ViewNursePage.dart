import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:newborn_app/constant/models/nurse.dart';

class NursePage extends StatefulWidget {
  final int nurseId;

  NursePage({
    Key? key,
    required this.nurseId,
  }) : super(key: key);

  @override
  _NursePageState createState() => _NursePageState();
}

class _NursePageState extends State<NursePage> {
  Nurse nurse = Nurse(
    id: 0,
    name: '',
    schedule: [],
    startTime: '',
    endTime: '',
    image: null,
    salary: '',
    doctorId: 1,
    doctorName: '',
    hospitalId: 1,
    hospitalName: '',
    ministryOfHealthId: 1,
    ministryOfHealthName: '',
    specialization: '',
  );

  void fetchNurse() async {
    final response = await http
        .get(Uri.parse('http://localhost:8000/api/nurses/${widget.nurseId}'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json != null) {
        setState(() {
          nurse = Nurse.fromJson(json['data'][0]);
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchNurse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nurse Page'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Doctor Name: ${nurse.name}',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Text(
              'Specialization: ${nurse.specialization}',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'About: ${nurse.hospitalId}',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
            // NurseScheduleTable.generateScheduleTable(nurse.schedule),
          ],
        ),
      ),
    );
  }
}

class NurseScheduleTable {
  static Widget generateScheduleTable(List<Map<String, String>> schedule) {
    List<DataRow> rows = [];

    for (var i = 0; i < schedule.length; i++) {
      rows.add(DataRow(cells: [
        DataCell(Text(schedule[i]['day']!)),
        DataCell(Text(schedule[i]['startTime']!)),
        DataCell(Text(schedule[i]['endTime']!)),
      ]));
    }

    return DataTable(
      columns: [
        DataColumn(label: Text('Day')),
        DataColumn(label: Text('Start Time')),
        DataColumn(label: Text('End Time')),
      ],
      rows: rows,
    );
  }
}

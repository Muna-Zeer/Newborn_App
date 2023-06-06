import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:newborn_app/constant/models/postnatalExaminations.dart';

class PostnatalExaminationView extends StatefulWidget {
  // final int motherId;
  final PostnatalExaminations mother;

  PostnatalExaminationView({
    Key? key,
    required this.mother,
  }) : super(key: key);

  @override
  _PostnatalExaminationPageState createState() =>
      _PostnatalExaminationPageState();
}

class _PostnatalExaminationPageState extends State<PostnatalExaminationView> {
  Map<String, dynamic> _postnatal = {};
  String? _doctorName;
  String? _nurseName;
  String? _midwifeName;

  void fetchPostnatalExaminations() async {
    final response = await http.get(Uri.parse(
        'http://localhost:8000/api/postnatalExaminations/${widget.mother.id}'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final doctorData = jsonData['data'];
      final doctorId = doctorData['doctor_id'];
      final midwifeId = doctorData['midwife_id'];
      final nurseId = doctorData['nurse_id'];

      print('doctor ID: $doctorId');
      print('midwife ID: $midwifeId');
      print('nurse ID: $nurseId');

      final doctorName = await fetchDoctorName(doctorId);
      final midwifeName = await fetchMidwifeName(midwifeId);
      final nurseName = await fetchNurseName(nurseId);

      print('doctor Name: $doctorName');
      print('midwife Name: $midwifeName');
      print('nurse Name: $nurseName');

      setState(() {
        _postnatal = doctorData;
        _doctorName = doctorName;
        _midwifeName = midwifeName;
        _nurseName = nurseName;
      });
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  Future<String> fetchDoctorName(int doctorId) async {
    final response = await http
        .get(Uri.parse('http://127.0.0.1:8000/api/fetchDoctors/$doctorId'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final doctorName = data['data']['name'];
      return doctorName ?? ''; // Handle null value
    } else {
      throw Exception('Failed to fetch doctor data');
    }
  }

  Future<String> fetchNurseName(int nursesId) async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/fetchNurses/$nursesId'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final nursesName = data['data']['name'];
      return nursesName ?? ''; // Handle null value
    } else {
      throw Exception('Failed to fetch nurses data');
    }
  }

  Future<String> fetchMidwifeName(int midwifeId) async {
    final response = await http
        .get(Uri.parse('http://127.0.0.1:8000/api/fetchMidwives/$midwifeId'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final midwifeName = data['data']['name'];
      return midwifeName ?? ''; // Handle null value
    } else {
      throw Exception('Failed to fetch midwife data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPostnatalExaminations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Postnatal Examinations Page'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Text(
              'doctorName: $_doctorName',
              style: TextStyle(fontSize: 16),
            ),

            Text(
              'midwifeName: $_midwifeName',
              style: TextStyle(fontSize: 16),
            ),

            Text(
              'nurseName: $_nurseName',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16.0),
            Container(
              margin: EdgeInsets.only(bottom: 16.0),
              child: Text(
                'motherName: ${_postnatal['mother_name']}',
                style: TextStyle(fontSize: 16),
              ),
            ),

            Text(
              'Breasts: ${widget.mother.breasts}',
              style: TextStyle(fontSize: 16),
            ),

            Text(
              'Day After Delivery: ${widget.mother.dayAfterDelivery}',
              style: TextStyle(fontSize: 16),
            ),

            Text(
              'Date of Visit: ${widget.mother.dateOfVisit}',
              style: TextStyle(fontSize: 16),
            ),

            Text(
              'Temp: ${widget.mother.temp}',
              style: TextStyle(fontSize: 16),
            ),

            Text(
              'Pulse: ${widget.mother.pulse}',
              style: TextStyle(fontSize: 16),
            ),

            Text(
              'BP: ${widget.mother.bp}',
              style: TextStyle(fontSize: 16),
            ),

            Text(
              'Bleeding After Delivery: ${widget.mother.bleedingAfterDelivery}',
              style: TextStyle(fontSize: 16),
            ),

            Text(
              'Hb: ${widget.mother.hb}',
              style: TextStyle(fontSize: 16),
            ),

            Text(
              'DVT: ${widget.mother.dvt}',
              style: TextStyle(fontSize: 16),
            ),

            Text(
              'Rupture Uterus: ${widget.mother.ruptureUterus}',
              style: TextStyle(fontSize: 16),
            ),

            Text(
              'If Yes: ${widget.mother.ifYes}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Lochia Color: ${widget.mother.lochiaColor}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Incision: ${widget.mother.incision}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Seizures: ${widget.mother.seizures}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Blood Transfusion: ${widget.mother.bloodTransfusion}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Fundal Height: ${widget.mother.fundalHeight}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Family Planning Counseling: ${widget.mother.familyPlanningCounseling}',
              style: TextStyle(fontSize: 16),
            ),

            Text(
              'FP Appointment: ${widget.mother.fpAppointment}',
              style: TextStyle(fontSize: 16),
            ),

            Text(
              'Recommendations: ${widget.mother.recommendations}',
              style: TextStyle(fontSize: 16),
            ),

            Text(
              'Remarks: ${widget.mother.remarks}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

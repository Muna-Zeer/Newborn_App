import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'package:newborn_app/constant/models/nurse.dart';
import 'package:newborn_app/methods/doctor_api.dart';
import 'package:newborn_app/nurse/nurseAlert.dart';
import 'package:newborn_app/methods/nurse_api.dart';
import 'package:uuid/uuid.dart';

class NurseFormPage extends StatefulWidget {
  final int nurseId;
  const NurseFormPage({Key? key, required this.nurseId}) : super(key: key);
  @override
  _NurseProfilePageState createState() => _NurseProfilePageState();
}

class _NurseProfilePageState extends State<NurseFormPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final salaryController = TextEditingController();

  final hospitalCenterIdController = TextEditingController();
  final specializationIdController = TextEditingController();
  final ministryOfHealthIdController = TextEditingController();

  final _imageController = TextEditingController();

  List<Map<String, dynamic>> hospitals = [];
  List<Map<String, dynamic>> ministriesOfHealth = [];
  List<Map<String, dynamic>> Doctors = [];

  String? selectedHospital;
  String? selectedMinistry;
  String? selectedDoctor;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      List<Map<String, dynamic>> fetchedHospitals = await fetchHospitals();
      List<Map<String, dynamic>> fetchedDoctors = await fetchDoctorHospital();
      List<Map<String, dynamic>> fetchedMinistriesOfHealth =
          await fetchMinistriesOfHealth();

      setState(() {
        hospitals = fetchedHospitals;
        ministriesOfHealth = fetchedMinistriesOfHealth;
        Doctors = fetchedDoctors;

        selectedHospital = fetchedHospitals.isNotEmpty
            ? fetchedHospitals[0]['id'].toString()
            : null;
        selectedMinistry = fetchedMinistriesOfHealth.isNotEmpty
            ? fetchedMinistriesOfHealth[0]['id'].toString()
            : null;
        selectedDoctor = fetchedDoctors.isNotEmpty
            ? fetchedDoctors[0]['id'].toString()
            : null;
      });
    } catch (error) {
      print('Failed to fetch data: $error');
    }
  }

  File? _imageFile;
  final _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = File(pickedFile!.path);
      _imageController.text = pickedFile.path; // Set the text value
    });
  }

  List<Map<String, String>> schedule = [
    {'day': 'Monday', 'start': '', 'end': ''},
    {'day': 'Tuesday', 'start': '', 'end': ''},
    {'day': 'Wednesday', 'start': '', 'end': ''},
    {'day': 'Thursday', 'start': '', 'end': ''},
    {'day': 'Friday', 'start': '', 'end': ''},
    {'day': 'Saturday', 'start': '', 'end': ''},
    {'day': 'Sunday', 'start': '', 'end': ''},
  ];

  Future<void> _selectEndTime(BuildContext context, String day) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (selectedTime != null) {
      final time = selectedTime.format(context);
      setState(() {
        final dayIndex = schedule.indexWhere((item) => item['day'] == day);
        if (dayIndex != -1) {
          schedule[dayIndex]['end'] = time;
        }
      });
    }
  }

  Future<void> _selectStartTime(BuildContext context, String day) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (selectedTime != null) {
      final time = selectedTime.format(context);
      setState(() {
        final dayIndex = schedule.indexWhere((item) => item['day'] == day);
        if (dayIndex != -1) {
          schedule[dayIndex]['start'] = time;
        }
      });
    }
  }

  bool _isScheduleValid() {
    for (final daySchedule in schedule) {
      if (daySchedule['start'] == null || daySchedule['end'] == null) {
        return false;
      }
    }
    return true;
  }

  void _saveNurse() async {
    if (_formKey.currentState!.validate()) {
      if (!_isScheduleValid()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Please enter start and end times for all days in the schedule.'),
          ),
        );
        return;
      }

      var uuid = Uuid().v4();
      if (_imageFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select an image.'),
          ),
        );
        return;
      }
      final nurse = Nurse(
        id: 0,
        name: nameController.text ?? '',
        salary: salaryController.text ?? '',
        hospitalName: selectedHospital ?? '',
        ministryOfHealthName: selectedMinistry ?? '',
        hospitalId: int.parse(selectedHospital ?? '0'),
        doctorName: selectedDoctor ?? '',
        doctorId: int.parse(selectedDoctor ?? '0'),
        ministryOfHealthId: int.parse(selectedMinistry ?? '0'),
        specialization: specializationIdController.text ?? '',
        schedule: schedule.isNotEmpty
            ? schedule
            : [], // Ensure that schedule is an array
        startTime: '',
        endTime: '',

        image: _imageFile,
      );

      await createNurse(nurse, context);
      // Pass the doctor's JSON representation to createDoctor
      try {
        // clear the form fields
        nameController.clear();
        salaryController.clear();

        hospitalCenterIdController.clear();
        ministryOfHealthIdController.clear();
        specializationIdController.clear();
        schedule = []; // Clear the schedule field
        setState(() {
          _imageFile = null;
          _imageController.clear();
        });
      } catch (e) {
        print(e);
        NurseAlert.showError(context);
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nurse Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  'Enter information about nurse',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 32.0),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Nurse Name',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          errorStyle: TextStyle(color: Colors.red),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the nurse name';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 16.0),
                  ],
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: salaryController,
                        decoration: InputDecoration(
                          labelText: 'Salary',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          errorStyle: TextStyle(color: Colors.red),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the salary';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number for the salary';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 16.0),
                  ],
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    SizedBox(width: 16.0),
                    Expanded(
                      child: TextFormField(
                        controller: specializationIdController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        style: TextStyle(fontSize: 16, height: 1.5),
                        decoration: InputDecoration(
                          labelText: 'specialization Name',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          errorStyle: TextStyle(color: Colors.red),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter specializationId';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedHospital,
                        onChanged: (value) {
                          setState(() {
                            selectedHospital = value!;
                          });
                        },
                        items: hospitals.map((hospital) {
                          return DropdownMenuItem<String>(
                            value: hospital['id'].toString(),
                            child: Text(hospital['name']),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: 'Hospital',
                        ),
                      ),
                    ),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedMinistry,
                        onChanged: (value) {
                          setState(() {
                            selectedMinistry = value!;
                          });
                        },
                        items: ministriesOfHealth.map((ministry) {
                          return DropdownMenuItem<String>(
                            value: ministry['id'].toString(),
                            child: Text(ministry['name']),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: 'Ministry of Health',
                        ),
                      ),
                    ),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedDoctor,
                        onChanged: (value) {
                          setState(() {
                            selectedDoctor = value!;
                          });
                        },
                        items: Doctors.map((doctor) {
                          return DropdownMenuItem<String>(
                            value: doctor['id'].toString(),
                            child: Text(doctor['name']),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: 'Doctor name',
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: TextFormField(
                          controller: _imageController,
                          decoration: InputDecoration(
                            labelText: 'Image Path',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        onPressed: _pickImage,
                        child: Text('Pick Image'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Center(
                  child: Text(
                    'Schedule of Nurse',
                    style:
                        TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 16.0),
                Center(
                  child: SizedBox(
                    width: 1000.0,
                    child: Table(
                      columnWidths: {
                        0: FlexColumnWidth(1),
                        1: FlexColumnWidth(2),
                        2: FlexColumnWidth(2),
                        3: FlexColumnWidth(1),
                      },
                      border: TableBorder.all(color: Colors.blue),
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                          ),
                          children: [
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Day',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Start Time',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'End Time',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        _buildTableRow('Monday'),
                        _buildTableRow('Tuesday'),
                        _buildTableRow('Wednesday'),
                        _buildTableRow('Thursday'),
                        _buildTableRow('Friday'),
                        _buildTableRow('Saturday'),
                        _buildTableRow('Sunday'),
                        TableRow(
                          children: [
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                    child: Text('Save'), onPressed: _saveNurse),
                              ),
                            ),
                            TableCell(
                              child: SizedBox.shrink(),
                            ),
                            TableCell(
                              child: SizedBox.shrink(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TableRow _buildTableRow(String day) {
    final scheduleForDay = schedule.firstWhere((s) => s['day'] == day,
        orElse: () => {'start': 'Not set', 'end': 'Not set'});
    final startText = scheduleForDay['start'];
    final endText = scheduleForDay['end'];
    return TableRow(
      children: [
        TableCell(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              day,
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: InkWell(
              child: Text(
                startText!,
                style: TextStyle(fontSize: 16.0),
              ),
              onTap: () => _selectStartTime(context, day),
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: InkWell(
              child: Text(
                endText!,
                style: TextStyle(fontSize: 16.0),
              ),
              onTap: () => _selectEndTime(context, day),
            ),
          ),
        ),
      ],
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newborn_app/constant/models/midwifem.dart';

import 'package:newborn_app/methods/Midwife_api.dart';
import 'package:newborn_app/methods/doctor_api.dart';
import 'package:newborn_app/midwife/Midwife/midwifeAlert.dart';
import 'package:uuid/uuid.dart';

class MidwifeProfilePage extends StatefulWidget {
  final int midwifeId;
  const MidwifeProfilePage({Key? key, required this.midwifeId})
      : super(key: key);
  @override
  _MidwifeProfilePageState createState() => _MidwifeProfilePageState();
}

class _MidwifeProfilePageState extends State<MidwifeProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _salaryController = TextEditingController();
  final _hoursController = TextEditingController();
  final _communicationController = TextEditingController();

  final _motherNameController = TextEditingController();
  final _newbornBraceletHandController = TextEditingController();
  final _newbornBraceletLegController = TextEditingController();
  final _reportController = TextEditingController();
  final _doctorIdController = TextEditingController();
  final _newbornIdController = TextEditingController();
  final _motherIdController = TextEditingController();
  final _imageController = TextEditingController();

  final hospitalCenterIdController = TextEditingController();
  File? _imageFile;
  final _picker = ImagePicker();
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

  void _saveMidwife() async {
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
      final midwife = Midwife(
        // set to 0 if you want the server to generate the ID
        // id: Doctor.generateRandomId(),
        id: 0,
        name: _nameController.text ?? '',
        salary: int.parse(_salaryController.text) ?? 0,

        schedule: schedule.isNotEmpty
            ? schedule
            : [], // Ensure that schedule is an array
        startTime: '',
        endTime: '',
        image: _imageFile,
        communication: _communicationController.text ?? '',
        hours: 0,
        motherName: _motherNameController.text ?? '',
        newbornBraceletHand: _newbornBraceletHandController.text ?? '',
        newbornBraceletLeg: _newbornBraceletLegController.text ?? '',

        report: _reportController.text ?? '',
        hospitalName: selectedHospital ?? '',
        ministryOfHealthName: selectedMinistry ?? '',
        hospitalId: int.parse(selectedHospital ?? '1'),
        doctorName: selectedDoctor ?? '',
        doctorId: int.parse(selectedDoctor ?? '0'), ministryOfHealthId: 1,
      );

      await createMidwife(midwife, context);
      // Pass the doctor's JSON representation to createDoctor
      try {
        // clear the form fields
        _nameController.clear();
        _salaryController.clear();
        _communicationController.clear();
        _doctorIdController.clear();
        _hoursController.clear();
        _motherIdController.clear();
        _motherNameController.clear();
        _newbornBraceletHandController.clear();
        _newbornBraceletLegController.clear();
        _newbornIdController.clear();
        _salaryController.clear();
        _reportController.clear();
        schedule = []; // Clear the schedule field
        setState(() {
          _imageFile = null;
          _imageController.clear();
        });
      } catch (e) {
        print(e);
        MidwifeAlert.showError(context);
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Midwife Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  'Enter information about Midwife',
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
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Midwife Name',
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
                            return 'Please enter the Midwife name';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: TextFormField(
                        controller: _communicationController,
                        decoration: InputDecoration(
                          labelText: 'communcatin skills Midwife',
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
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some information about the Midwife';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _salaryController,
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
                    Expanded(
                      child: TextFormField(
                        controller: _motherNameController,
                        decoration: InputDecoration(
                          labelText: 'mother Name',
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
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _reportController,
                        decoration: InputDecoration(
                          labelText: 'report ',
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
                            return 'Please enter the report ';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: TextFormField(
                        controller: _newbornBraceletLegController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        style: TextStyle(fontSize: 16, height: 1.5),
                        decoration: InputDecoration(
                          labelText: 'newborn Bracelet Leg ',
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
                            return 'Please enter newborn Bracelet Leg';
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
                      child: Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: TextFormField(
                          controller: _newbornBraceletHandController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          style: TextStyle(fontSize: 16, height: 1.5),
                          decoration: InputDecoration(
                            labelText: 'newborn Bracelet hand',
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
                              return 'Please enter newborn Bracelet hand';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _hoursController,
                        decoration: InputDecoration(
                          labelText: 'hours',
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
                            return 'Please enter hours';
                          }
                          return null;
                        },
                      ),
                    ),
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
                SizedBox(height: 16.0),
                Center(
                  child: Text(
                    'Schedule of midwife',
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
                                    child: Text('Save'),
                                    onPressed: _saveMidwife),
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

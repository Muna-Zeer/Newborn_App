import 'package:flutter/material.dart';
import 'package:newborn_app/Nurse/NurseTable.dart';
import 'package:newborn_app/constant/models/nurse.dart';
import 'package:newborn_app/methods/nurse_api.dart';

import 'package:intl/intl.dart';

class EditNursePage extends StatefulWidget {
  final int nurseId;

  const EditNursePage({
    Key? key,
    required this.nurseId,
  }) : super(key: key);

  @override
  _EditNursePageState createState() => _EditNursePageState();
}

class _EditNursePageState extends State<EditNursePage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController salaryController = TextEditingController();
  TextEditingController healthCenterIdController = TextEditingController();
  TextEditingController hospitalCenterIdController = TextEditingController();
  TextEditingController specializationIdController = TextEditingController();
  TextEditingController ministryOfHealthIdController = TextEditingController();

  List<Map<String, String>> _schedule = [];

  Nurse? nurseData;

  @override
  void initState() {
    super.initState();
    // Fetch doctor data and populate the form
    _fetchNurseData();
  }

  void _fetchNurseData() async {
    // Fetch doctor data
    try {
      final nurse = await fetchNurse(widget.nurseId);
      setState(() {
        nurseData = nurse;
        nameController.text = nurse.name;
        specializationIdController.text = nurse.specialization;
        ministryOfHealthIdController.text = nurse.ministryOfHealthId.toString();
        hospitalCenterIdController.text = nurse.hospitalId.toString();

        salaryController.text = nurse.salary;

        // _schedule = nurse.schedule;
      });
    } catch (e) {
      print('Error fetching Nurse data: $e');
    }
  }

  void _addScheduleEntry() {
    setState(() {
      _schedule.add({
        'day': '',
        'start_time': '',
        'end_time': '',
      });
    });
  }

  void _saveNurseData() async {
    // Create a new Doctor object with updated values
    final updatedNurse = Nurse(
      id: widget.nurseId,
      name: nameController.text,
      specialization: specializationIdController.text,
      // ministryOfHealthId: ministryOfHealthIdController.toString(),

      salary: salaryController.text,

      schedule: _schedule,

      startTime: '',
      endTime: '', doctorId: 1, doctorName: '', hospitalId: 1, hospitalName: '',
      ministryOfHealthId: 1, ministryOfHealthName: 'e',
    );
    try {
      final success = await updateNurse(updatedNurse.id, updatedNurse, context);
      if (success) {
        setState(() {
          nurseData = updatedNurse;
        });
        // Show success message
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Nurse data saved.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => NursePage()),
                    );
                  },
                ),
              ],
            );
          },
        );
      } else {
        throw Error();
      }
    } catch (e) {
      print('success saving Nurse data: $e');
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('success saving Nurse data')),
      );
    }
  }

  void _removeScheduleEntry(int index) {
    setState(() {
      _schedule.removeAt(index);
    });
  }

  void _updateScheduleEntry(int index, String key, String value) {
    setState(() {
      _schedule[index][key] = value;
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
                  'Enter information about Nurse',
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
                          labelText: 'Doctor Name',
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
                            return 'Please enter the doctor name';
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
                SizedBox(height: 16.0),
                Center(
                  child: Text(
                    'Schedule of Doctor',
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
                                    onPressed: _saveNurseData),
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

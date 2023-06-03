import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newborn_app/alert/doctorAlert.dart';
import 'package:newborn_app/constant/models/Doctor.dart';
import 'package:newborn_app/methods/doctor_api.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;

// import 'package:permission_handler/permission_handler.dart';
class DoctorProfilePage extends StatefulWidget {
  final int doctorId;
  const DoctorProfilePage({Key? key, required this.doctorId}) : super(key: key);
  @override
  _DoctorProfilePageState createState() => _DoctorProfilePageState();
}

class _DoctorProfilePageState extends State<DoctorProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final salaryController = TextEditingController();
  final nurseNameController = TextEditingController();
  final midwifeNameController = TextEditingController();
  final specializationController = TextEditingController();
  final HospitalController = TextEditingController();
  final CountryController = TextEditingController();
  final CityController = TextEditingController();
  final EmailController = TextEditingController();
  final PhoneController = TextEditingController();
  final ministryOfHealthController = TextEditingController();
  final _imageController = TextEditingController();
  String imageString = '';
  final aboutController = TextEditingController();
  List<Map<String, dynamic>> hospitals = [];
  List<Map<String, dynamic>> ministriesOfHealth = [];

  String? selectedHospital;
  String? selectedMinistry;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      List<Map<String, dynamic>> fetchedHospitals = await fetchHospitals();
      List<Map<String, dynamic>> fetchedMinistriesOfHealth =
          await fetchMinistriesOfHealth();

      setState(() {
        hospitals = fetchedHospitals;
        ministriesOfHealth = fetchedMinistriesOfHealth;
        selectedHospital = fetchedHospitals.isNotEmpty
            ? fetchedHospitals[0]['id'].toString()
            : null;
        selectedMinistry = fetchedMinistriesOfHealth.isNotEmpty
            ? fetchedMinistriesOfHealth[0]['id'].toString()
            : null;
      });
    } catch (error) {
      print('Failed to fetch data: $error');
    }
  }

  File _imageFile = File('/path/to/image/file');
  final _picker = ImagePicker();
  bool _imageSelected = false;

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        final bytes = File(pickedFile!.path).readAsBytesSync();
        String base64Image = "data:image/png;base64," + base64Encode(bytes);
        // _imageFile = File(pickedFile.path);
        _imageSelected = true;
        _imageController.text = pickedFile.path;
        print(' image file $pickedFile');
        imageString = convertIntoBase64(_imageFile);
        if (kIsWeb) {
          _imageFile = Image.network(pickedFile.path) as File;
        } else {
          _imageFile = Image.file(File(pickedFile.path)) as File;
        }
      } else {
        _imageSelected = false;
      }
    });
  }

  String convertIntoBase64(File file) {
    List<int> imageBytes = file.readAsBytesSync();
    String base64File = base64Encode(imageBytes);
    return base64File;
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

  void _saveDoctor() async {
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
      final doctor = Doctor(
        id: 0,
        name: nameController.text ?? '',
        salary: salaryController.text ?? '',

        nurseName: nurseNameController.text ?? '',
        midwifeName: midwifeNameController.text ?? '',
        specialization: specializationController.text ?? '',
        hospitalName: selectedHospital ?? '',
        ministryOfHealthName: selectedMinistry ?? '',
        hospitalId: int.parse(selectedHospital ?? '0'),
        ministryOfHealthId: int.parse(selectedMinistry ?? '0'),
        schedule: schedule.isNotEmpty
            ? schedule
            : [], // Ensure that schedule is an array
        startTime: '',
        endTime: '',
        about: aboutController.text ?? '',
        country: CountryController.text ?? '',
        city: CityController.text ?? '',
        phone: PhoneController.text ?? '',
        email: EmailController.text ?? '',
        image: _imageFile,
      );

      await createDoctor(doctor, imageString, context);
      // Pass the doctor's JSON representation to createDoctor
      try {
        // clear the form fields
        nameController.clear();
        salaryController.clear();
        nurseNameController.clear();
        midwifeNameController.clear();
        specializationController.clear();
        HospitalController.clear();
        aboutController.clear();
        specializationController.clear();
        CountryController.clear();
        CityController.clear();
        EmailController.clear();
        PhoneController.clear();
        schedule = []; // Clear the schedule field
        setState(() {
          _imageController.clear();
        });
      } catch (e) {
        print(e);
        DoctorAlert.showError(context);
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  'Enter information about doctor',
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
                    SizedBox(width: 16.0),
                    Expanded(
                      child: TextFormField(
                        controller: aboutController,
                        decoration: InputDecoration(
                          labelText: 'About Doctor',
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
                            return 'Please enter some information about the doctor';
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
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: TextFormField(
                          controller: specializationController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          style: TextStyle(fontSize: 16, height: 1.5),
                          decoration: InputDecoration(
                            labelText: 'specialization',
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
                              return 'Please enter some information about the doctor';
                            }
                            return null;
                          },
                        ),
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
                        onPressed: _selectImage,
                        child: Text('Pick Image'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: CountryController,
                        decoration: InputDecoration(
                          labelText: 'Country',
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
                            return 'Please enter the country name';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: TextFormField(
                        controller: CityController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        style: TextStyle(fontSize: 16, height: 1.5),
                        decoration: InputDecoration(
                          labelText: 'City',
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
                            return 'Please enter name of the city';
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
                        controller: PhoneController,
                        decoration: InputDecoration(
                          labelText: 'Phone of doctor',
                          hintText: '(000) 000-0000',
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
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a phone number';
                          }
                          final phoneRegExp = RegExp(r'^\d{10}$');
                          if (!phoneRegExp.hasMatch(value)) {
                            return 'Please enter a valid phone number';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: TextFormField(
                        controller: EmailController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        style: TextStyle(fontSize: 16, height: 1.5),
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'doctor@doctor.com',
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
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter an email address';
                          }
                          if (!RegExp(r'^[\w\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value)) {
                            return 'please enter valid email address';
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
                  ],
                ),
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
                                    onPressed: _saveDoctor),
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

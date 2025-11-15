import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_vaccine_app/Alert_Dialog/doctorAlert.dart';
import 'package:my_vaccine_app/doctors/doctor.dart';
import 'package:my_vaccine_app/doctors/doctor_api.dart';
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
  final hospitalController = TextEditingController();
  final countryController = TextEditingController();
  final cityController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final ministryOfHealthController = TextEditingController();

  final aboutController = TextEditingController();
  List<Map<String, dynamic>> hospitals = [];
  List<Map<String, dynamic>> ministriesOfHealth = [];

  String? selectedHospital;
  String? selectedMinistry;

  //Images
  final _picker = ImagePicker();
  bool _imageSelected = false;
  TextEditingController _imageController = TextEditingController();
  String imageString = '';
  dynamic _selectedImage;

  File? _imageFile;

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

  Future<void> _selectImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      setState(() {
        _imageFile = null;
        _selectedImage = null;
        _imageController.text = '';
        _imageSelected = false;
      });
      return;
    }

    if (kIsWeb) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _selectedImage = bytes;
        _imageController.text = 'Selected: ${pickedFile.name}';
        _imageSelected = true;
      });
    } else {
      final file = File(pickedFile.path);
      setState(() {
        _imageFile = file;
        _selectedImage = file;
        _imageController.text = pickedFile.path.split('/').last;
        _imageSelected = true;
      });
    }
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
          const SnackBar(
            content: Text(
                'Please enter start and end times for all days in the schedule.'),
          ),
        );
        return;
      }

      if (_selectedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
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
        hospitalId: int.tryParse(selectedHospital ?? '0') ?? 0,
        ministryOfHealthId: int.tryParse(selectedMinistry ?? '0') ?? 0,
        schedule: schedule.isNotEmpty ? schedule : [],
        startTime: '',
        endTime: '',
        about: aboutController.text ?? '',
        country: countryController.text ?? '',
        city: cityController.text ?? '',
        phone: phoneController.text ?? '',
        email: emailController.text ?? '',
        image: kIsWeb ? null : (_selectedImage as File?),
      );

      await createDoctor(doctor, _selectedImage, context);

      try {
        _formKey.currentState!.reset();
        schedule = [];
        setState(() {
          _imageController.clear();
          _imageFile = null;
          _selectedImage = null;
          _imageSelected = false;
        });
      } catch (e) {
        DoctorAlert.showError(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [Text('Doctor Profile')],
        ),
        backgroundColor: Colors.lightBlue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  'Enter information about doctor',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32.0),
                Container(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Card(
                        color: Colors.lightBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        controller: nameController,
                                        decoration: const InputDecoration(
                                          labelText: 'Doctor Name',
                                          border: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.grey),
                                          ),
                                          fillColor: Colors.white,
                                          filled: true,
                                          focusedBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.blue),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.red),
                                          ),
                                          errorStyle:
                                              TextStyle(color: Colors.red),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter the doctor name';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16.0),
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        controller: aboutController,
                                        decoration: const InputDecoration(
                                          labelText: 'About Doctor',
                                          border: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.grey),
                                          ),
                                          fillColor: Colors.white,
                                          filled: true,
                                          focusedBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.blue),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.red),
                                          ),
                                          errorStyle:
                                              TextStyle(color: Colors.red),
                                        ),
                                        keyboardType: TextInputType.multiline,
                                        maxLines: null,
                                        style: const TextStyle(
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
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: TextFormField(
                                    controller: salaryController,
                                    decoration: const InputDecoration(
                                      labelText: 'Salary',
                                      border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      fillColor: Colors.white,
                                      filled: true,
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.blue),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red),
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
                                  )),
                                  const SizedBox(height: 16.0),
                                  Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          controller: specializationController,
                                          keyboardType: TextInputType.multiline,
                                          maxLines: null,
                                          style: const TextStyle(
                                              fontSize: 16, height: 1.5),
                                          decoration: const InputDecoration(
                                            labelText: 'specialization',
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.blue),
                                            ),
                                            fillColor: Colors.white,
                                            filled: true,
                                            errorBorder: OutlineInputBorder(
                                              borderSide:
                                                  BorderSide(color: Colors.red),
                                            ),
                                            errorStyle:
                                                TextStyle(color: Colors.red),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter some information about the doctor';
                                            }
                                            return null;
                                          },
                                        ),
                                      )),
                                ],
                              ),
                              const SizedBox(height: 16.0),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: countryController,
                                      decoration: const InputDecoration(
                                        labelText: 'Country',
                                        border: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.grey),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.blue),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.red),
                                        ),
                                        fillColor: Colors.white,
                                        filled: true,
                                        errorStyle:
                                            TextStyle(color: Colors.red),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter the country name';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 16.0),
                                  Expanded(
                                    child: TextFormField(
                                      controller: cityController,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      style: const TextStyle(
                                          fontSize: 16, height: 1.5),
                                      decoration: const InputDecoration(
                                        labelText: 'City',
                                        border: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.grey),
                                        ),
                                        fillColor: Colors.white,
                                        filled: true,
                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.blue),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.red),
                                        ),
                                        errorStyle:
                                            TextStyle(color: Colors.red),
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
                              const SizedBox(height: 16.0),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: phoneController,
                                      decoration: const InputDecoration(
                                        labelText: 'Phone of doctor',
                                        hintText: '(000) 000-0000',
                                        border: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.grey),
                                        ),
                                        fillColor: Colors.white,
                                        filled: true,
                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.blue),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.red),
                                        ),
                                        errorStyle:
                                            TextStyle(color: Colors.red),
                                      ),
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
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
                                  const SizedBox(width: 16.0),
                                  Expanded(
                                    child: TextFormField(
                                      controller: emailController,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      style: const TextStyle(
                                          fontSize: 16, height: 1.5),
                                      decoration: const InputDecoration(
                                        labelText: 'Email',
                                        hintText: 'doctor@doctor.com',
                                        border: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.grey),
                                        ),
                                        fillColor: Colors.white,
                                        filled: true,
                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.blue),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.red),
                                        ),
                                        errorStyle:
                                            TextStyle(color: Colors.red),
                                      ),
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return 'Please enter an email address';
                                        }
                                        if (!RegExp(
                                                r'^[\w\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                            .hasMatch(value)) {
                                          return 'please enter valid email address';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              )
                            ])))),
                SizedBox(
                  width: 800,
                  child: Card(
                    color: Colors.lightBlue,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.all(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: TextFormField(
                                controller: _imageController,
                                decoration: InputDecoration(
                                  labelText: 'Image Path',
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 150,
                            child: ElevatedButton.icon(
                              onPressed: _selectImage,
                              icon: const Icon(Icons.image, size: 20),
                              label: const Text('Pick Image'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.lightBlue,
                                foregroundColor: Colors.blueGrey[50],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Card(
                    color: Colors.lightBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
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
                                  decoration: const InputDecoration(
                                    labelText: 'Hospital',
                                    border: OutlineInputBorder(),
                                    fillColor: Colors.white,
                                    filled: true,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
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
                                  decoration: const InputDecoration(
                                    labelText: 'Ministry of Health',
                                    border: OutlineInputBorder(),
                                    fillColor: Colors.white,
                                    filled: true,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                const Center(
                  child: Text(
                    'Schedule of Doctor',
                    style:
                        TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16.0),
                Center(
                  child: SizedBox(
                    width: 800.0,
                    child: Table(
                      columnWidths: const {
                        0: FlexColumnWidth(1),
                        1: FlexColumnWidth(2),
                        2: FlexColumnWidth(2),
                        3: FlexColumnWidth(1),
                      },
                      border: TableBorder.all(color: Colors.blue),
                      children: [
                        const TableRow(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                          ),
                          children: [
                            TableCell(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
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
                                padding: EdgeInsets.all(8.0),
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
                                padding: EdgeInsets.all(8.0),
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
                            const TableCell(
                              child: SizedBox.shrink(),
                            ),
                            const TableCell(
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
            padding: const EdgeInsets.all(8.0),
            child: Text(
              day,
              style: const TextStyle(fontSize: 16.0),
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              child: Text(
                startText!,
                style: const TextStyle(fontSize: 16.0),
              ),
              onTap: () => _selectStartTime(context, day),
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              child: Text(
                endText!,
                style: const TextStyle(fontSize: 16.0),
              ),
              onTap: () => _selectEndTime(context, day),
            ),
          ),
        ),
      ],
    );
  }
}

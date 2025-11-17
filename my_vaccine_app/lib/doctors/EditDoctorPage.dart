import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:my_vaccine_app/doctors/DoctorTable.dart';
import 'package:my_vaccine_app/doctors/doctor.dart';
import 'package:my_vaccine_app/doctors/doctor_api.dart';

class EditDoctorPage extends StatefulWidget {
  final int doctorId;

  const EditDoctorPage({
    Key? key,
    required this.doctorId,
  }) : super(key: key);

  @override
  _EditDoctorPageState createState() => _EditDoctorPageState();
}

class _EditDoctorPageState extends State<EditDoctorPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _specializationController = TextEditingController();
  TextEditingController _countryController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _salaryController = TextEditingController();
  TextEditingController _aboutController = TextEditingController();
  TextEditingController _hospitalController = TextEditingController();
  List<Map<String, String>> _schedule = [];

  Doctor? doctorData;
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

  Future<void> _selectImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      setState(() {
        _selectedImage = null;
        _imageController.text = '';
      });
      return;
    }

    if (kIsWeb) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _selectedImage = bytes; // Uint8List
        _imageController.text = 'Selected: ${pickedFile.name}';
      });
    } else {
      final file = File(pickedFile.path);
      setState(() {
        _selectedImage = file; // File
        _imageController.text = pickedFile.name;
      });
    }
  }

  String convertIntoBase64(File file) {
    List<int> imageBytes = file.readAsBytesSync();
    String base64File = base64Encode(imageBytes);
    return base64File;
  }

  @override
  void initState() {
    super.initState();
    _loadData();
    _fetchDoctorData();
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
      throw Exception('Failed to fetch data: $error');
    }
  }

  void _fetchDoctorData() async {
    // Fetch doctor data
    try {
      final doctor = await fetchDoctor(widget.doctorId);
      setState(() {
        doctorData = doctor;
        _nameController.text = doctor.name;
        _specializationController.text = doctor.specialization;
        _countryController.text = doctor.country;
        _cityController.text = doctor.city;
        _emailController.text = doctor.email;
        _phoneController.text = doctor.phone;
        _salaryController.text = doctor.salary;
        _aboutController.text = doctor.about;
        // _hospitalController.text = doctor.HospitalName;
        _schedule = doctor.schedule;
      });
    } catch (e) {
      throw Exception('Error fetching doctor data: $e');
    }
  }

// Function to save doctor data from form
  void _saveDoctorData() async {
    final updatedDoctor = Doctor(
      id: widget.doctorId,
      name: _nameController.text.isNotEmpty
          ? _nameController.text
          : doctorData!.name,
      specialization: _specializationController.text.isNotEmpty
          ? _specializationController.text
          : doctorData!.specialization,
      country: _countryController.text.isNotEmpty
          ? _countryController.text
          : doctorData!.country,
      city: _cityController.text.isNotEmpty
          ? _cityController.text
          : doctorData!.city,
      email: _emailController.text.isNotEmpty
          ? _emailController.text
          : doctorData!.email,
      phone: _phoneController.text.isNotEmpty
          ? _phoneController.text
          : doctorData!.phone,
      salary: _salaryController.text.isNotEmpty
          ? _salaryController.text
          : doctorData!.salary,
      about: _aboutController.text.isNotEmpty
          ? _aboutController.text
          : doctorData!.about,
      schedule: _schedule.isNotEmpty ? _schedule : doctorData!.schedule,
      nurseName: doctorData!.nurseName,
      midwifeName: doctorData!.midwifeName,
      startTime: doctorData!.startTime,
      endTime: doctorData!.endTime,
      hospitalName: selectedHospital ?? doctorData!.hospitalName,
      ministryOfHealthName:
          selectedMinistry ?? doctorData!.ministryOfHealthName,
      hospitalId: selectedHospital != null && selectedHospital!.isNotEmpty
          ? int.parse(selectedHospital!)
          : doctorData!.hospitalId,
      ministryOfHealthId:
          selectedMinistry != null && selectedMinistry!.isNotEmpty
              ? int.parse(selectedMinistry!)
              : doctorData!.ministryOfHealthId,
    );

    try {
      final success = await updateDoctor(
        id: updatedDoctor.id,
        doctor: updatedDoctor,
        image: _selectedImage,
      );

      if (success) {
        setState(() {
          doctorData = updatedDoctor;
        });

        // Show success dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Success'),
              content: const Text('Doctor data saved.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => DoctorPage()),
                    );
                  },
                ),
              ],
            );
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update doctor data')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving doctor data: $e')),
      );
    }
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
                                        controller: _nameController,
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
                                        controller: _aboutController,
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
                                    controller: _salaryController,
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
                                          controller: _specializationController,
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
                                      controller: _countryController,
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
                                      controller: _cityController,
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
                                      controller: _phoneController,
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
                                      controller: _emailController,
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
                    width: 1000.0,
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
                                    onPressed: _saveDoctorData),
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

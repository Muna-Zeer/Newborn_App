import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:newborn_app/alert/NewbornAlert.dart';
import 'package:newborn_app/constant/models/Newborn.dart';
import 'package:newborn_app/methods/Newborn_api.dart';
import 'package:newborn_app/methods/doctor_api.dart';

import 'dart:convert';

import 'package:uuid/uuid.dart';

class NewbornForm extends StatefulWidget {
  final int newbornId;
  const NewbornForm({Key? key, required this.newbornId}) : super(key: key);
  _NewbornFormState createState() => _NewbornFormState();
}

class _NewbornFormState extends State<NewbornForm> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  Gender? _genderController;
  final _identityNumberController = TextEditingController();
  MethodOFDelivery? _deliveryMethodController;
  final _healthCenterNameController = TextEditingController();
  final _hospitalCenterNameController = TextEditingController();
  final _ministryCenterNameController = TextEditingController();
  final _motherNameController = TextEditingController();
  final _doctorNameController = TextEditingController();
  final _nurseNameController = TextEditingController();
  final _midwifeNameController = TextEditingController();
  final _weightController = TextEditingController();
  final _lengthController = TextEditingController();
  final _timeOfBirthController = TextEditingController(text: '12:00');
  final _dateOfBirthController = TextEditingController(text: 'yyyy,MM,dd');
  Status? _status;
  List<Map<String, dynamic>> hospitals = [];
  List<Map<String, dynamic>> ministriesOfHealth = [];

  String? selectedHospital;
  String? selectedMinistry;

  List<Map<String, dynamic>> doctors = [];
  List<Map<String, dynamic>> midwives = [];

  String? selectedDoctor;
  String? selectedMidwife;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      List<Map<String, dynamic>> fetchedHospitals = await fetchHospitals();
      List<Map<String, dynamic>> fetchedDoctors = await fetchDoctorHospital();
      List<Map<String, dynamic>> fetchedMidwives = await fetchMidwives();
      List<Map<String, dynamic>> fetchedMinistriesOfHealth =
          await fetchMinistriesOfHealth();

      setState(() {
        hospitals = fetchedHospitals;
        doctors = fetchedDoctors;
        midwives = fetchedMidwives;
        ministriesOfHealth = fetchedMinistriesOfHealth;

        selectedHospital = fetchedHospitals.isNotEmpty
            ? fetchedHospitals[0]['id'].toString()
            : null;

        selectedMidwife = fetchedMidwives.isNotEmpty
            ? fetchedMidwives[0]['id'].toString()
            : null;

        selectedDoctor = fetchedDoctors.isNotEmpty
            ? fetchedDoctors[0]['id'].toString()
            : null;

        selectedMinistry = fetchedMinistriesOfHealth.isNotEmpty
            ? fetchedMinistriesOfHealth[0]['id'].toString()
            : null;
      });
    } catch (error) {
      print('Failed to fetch data: $error');
    }
  }

  void _saveKey() async {
    if (_formKey.currentState!.validate()) {
      var uuid = Uuid().v4(); // generate a unique ID
      var newborn = Newborn(
        id: 0,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        dateOfBirth: DateTime.parse(_dateOfBirthController.text),
        timeOfBirth: TimeOfDay.fromDateTime(
            DateFormat('hh:mm a').parse(_timeOfBirthController.text)),
        gender: Gender.Female,
        identityNumber: _identityNumberController.text,
        weight: double.parse(_weightController.text),
        length: double.parse(_lengthController.text),
        status: Status.Abnormal,
        deliveryMethod: MethodOFDelivery.Vaccum,
        motherName: _motherNameController.text,
        hospitalCenterName: selectedHospital ?? '',
        ministryCenterName: selectedMinistry ?? '',
        hospitalCenterid: int.parse(selectedHospital ?? '0'),
        ministryCenterid: int.parse(selectedMinistry ?? '0'),
        doctorName: selectedDoctor ?? '',
        midwifeName: selectedMidwife ?? '',
        midwifeid: int.parse(selectedMidwife ?? '0'),
        doctorid: int.parse(selectedDoctor ?? '0'),
        motherid: 1,
      );
      // Call the createMother function to submit the data to the server
      try {
        await createNewborn(newborn);
        // Show success alert
        NewbornAlert.showSuccessAlert(context, newborn);
        // Clear form
        _formKey.currentState!.reset();
        _firstNameController.clear();
        _lastNameController.clear();
        _dateOfBirthController.clear();
        _identityNumberController.clear();
        _doctorNameController.clear();
        _nurseNameController.clear();
        _lengthController.clear();
        _weightController.clear();
        _ministryCenterNameController.clear();
        _hospitalCenterNameController.clear();
        _healthCenterNameController.clear();
        _identityNumberController.clear();
      } catch (e) {
        // Show error alert
        NewbornAlert.showError(context, e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Newborn Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  DropdownButtonFormField<Gender>(
                    decoration: InputDecoration(
                        labelText: 'gender of newborn',
                        hintText: 'select an option'),
                    value: _genderController,
                    onChanged: (newValue) {
                      setState(() {
                        _genderController = newValue;
                      });
                    },
                    items: Gender.values.map((value) {
                      return DropdownMenuItem<Gender>(
                        value: value,
                        child: Text(value.toString().split('.').last),
                      );
                    }).toList(),
                  ),
                  TextFormField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                        labelText: 'first Name',
                        hintText: 'Enter first Name',
                        border: OutlineInputBorder()),
                    maxLines: null,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please fill this field';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                        labelText: 'last Name',
                        hintText: 'Enter last Name',
                        border: OutlineInputBorder()),
                    maxLines: null,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please fill this field';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<MethodOFDelivery>(
                    decoration: InputDecoration(
                        labelText: 'method of delivery ',
                        hintText: 'select an option'),
                    value: _deliveryMethodController,
                    onChanged: (newValue) {
                      setState(() {
                        _deliveryMethodController = newValue;
                      });
                    },
                    items: MethodOFDelivery.values.map((value) {
                      return DropdownMenuItem<MethodOFDelivery>(
                        value: value,
                        child: Text(value.toString().split('.').last),
                      );
                    }).toList(),
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
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedDoctor,
                          onChanged: (value) {
                            setState(() {
                              selectedDoctor = value!;
                            });
                          },
                          items: doctors.map((doctor) {
                            return DropdownMenuItem<String>(
                              value: doctor['id'].toString(),
                              child: Text(doctor['name']),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            labelText: 'Doctor',
                          ),
                        ),
                      ),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedMidwife,
                          onChanged: (value) {
                            setState(() {
                              selectedMidwife = value!;
                            });
                          },
                          items: midwives.map((midwife) {
                            return DropdownMenuItem<String>(
                              value: midwife['id'].toString(),
                              child: Text(midwife['name']),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            labelText: 'Midwife',
                          ),
                        ),
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: _identityNumberController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                        labelText: '_identity Number',
                        border: OutlineInputBorder()),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please fill this field';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _motherNameController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                        labelText: 'Mother ID', border: OutlineInputBorder()),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please fill this field';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _weightController,
                    decoration: InputDecoration(
                        labelText: 'weight of newborn',
                        border: OutlineInputBorder()),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please fill this field';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _lengthController,
                    decoration: InputDecoration(
                        labelText: 'length of  Newborn',
                        border: OutlineInputBorder()),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please fill this field';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<Status>(
                    decoration: InputDecoration(
                        labelText: 'status of newborn',
                        hintText: 'select an option'),
                    value: _status,
                    onChanged: (newValue) {
                      setState(() {
                        _status = newValue;
                      });
                    },
                    items: Status.values.map((value) {
                      return DropdownMenuItem<Status>(
                        value: value,
                        child: Text(value.toString().split('.').last),
                      );
                    }).toList(),
                  ),
                  TextFormField(
                    controller: _dateOfBirthController,
                    decoration: InputDecoration(labelText: 'Date of Delivery'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a date of birth';
                      }
                      return null;
                    },
                    onTap: () async {
                      final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now());
                      if (pickedDate != null) {
                        final formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        setState(() {
                          _dateOfBirthController.text = formattedDate;
                        });
                      }
                    },
                  ),
                  TextFormField(
                    controller: _timeOfBirthController,
                    onTap: () async {
                      final initialTime = TimeOfDay.now();
                      final selectedTime = await showTimePicker(
                        context: context,
                        initialTime: initialTime,
                      );
                      if (selectedTime != null) {
                        _timeOfBirthController.text =
                            selectedTime.format(context);
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Time of delivery',
                      hintText: 'Enter time of delivery',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter time of delivery';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                    child: Text('Save'),
                    onPressed: _saveKey,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

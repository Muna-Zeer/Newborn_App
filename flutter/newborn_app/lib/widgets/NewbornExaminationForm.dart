import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:newborn_app/alert/NewbornExaminationAlert.dart';
import 'package:newborn_app/apiService.dart';
import 'package:newborn_app/constant/models/motherExamination.dart';
import 'package:newborn_app/constant/models/newbornExamination.dart';
import 'package:newborn_app/methods/doctor_api.dart';
import 'package:newborn_app/methods/motherExamination_api.dart';
import 'package:newborn_app/methods/newbornExamination_api.dart';
import 'dart:convert';

import 'package:uuid/uuid.dart';

class NewbornExaminationForm extends StatefulWidget {
  final int NewbornId;
  const NewbornExaminationForm({Key? key, required this.NewbornId})
      : super(key: key);
  _NewbornExaminationFormState createState() => _NewbornExaminationFormState();
}

class _NewbornExaminationFormState extends State<NewbornExaminationForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameOfNewbornController = TextEditingController();
  final _headCircumferenceController = TextEditingController();
  final _lengthController = TextEditingController();
  final _weightController = TextEditingController();
  final _pulseController = TextEditingController();
  final _temperatureController = TextEditingController();
  final _respiratoryRateController = TextEditingController();
  final _breastfeedingController = TextEditingController();
  final _congenitalMalformationController = TextEditingController();
  final _medicationController = TextEditingController();
  final _vaccineNameController = TextEditingController();
  final _complicationAfterBirthController = TextEditingController();
  final _diagnosisController = TextEditingController();
  final _referredController = TextEditingController();
  final _nurseNameController = TextEditingController();
  final _doctorNameController = TextEditingController();
  final _midwifeNameController = TextEditingController();
  final _apgarScoreController = TextEditingController();
  Sex? _sex;
  Birth_outcome? _birthOutcome;
  List<Map<String, dynamic>> nurses = [];

  List<Map<String, dynamic>> doctors = [];
  List<Map<String, dynamic>> midwives = [];
  List<Map<String, dynamic>> vaccines = [];

  String? selectedNurses;
  String? selectedDoctor;
  String? selectedMidwife;
  String? selectedVaccine;


  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      List<Map<String, dynamic>> fetchedNurses = await fetchNurses();
      List<Map<String, dynamic>> fetchedDoctors = await fetchDoctorHospital();
      List<Map<String, dynamic>> fetchedMidwives = await fetchMidwives();
      List<Map<String, dynamic>> fetchedVaccines = await fetchVaccines();

      setState(() {
        nurses = fetchedNurses;
        doctors = fetchedDoctors;
        midwives = fetchedMidwives;
        vaccines = fetchedVaccines;

        selectedNurses =
            fetchedNurses.isNotEmpty ? fetchedNurses[0]['id'].toString() : null;

        selectedMidwife = fetchedMidwives.isNotEmpty
            ? fetchedMidwives[0]['id'].toString()
            : null;

        selectedDoctor = fetchedDoctors.isNotEmpty
            ? fetchedDoctors[0]['id'].toString()
            : null;
        selectedVaccine = fetchedVaccines.isNotEmpty
            ? fetchedVaccines[0]['id'].toString()
            : null;
      });
    } catch (error) {
      print('Failed to fetch data: $error');
    }
  }

  //create function to save fields
  void _saveKey() async {
    if (_formKey.currentState!.validate()) {
      var uuid = Uuid().v4();
      var newborn = NewbornExamination(
        id: uuid,
        sex: Sex.Female,
        newbornName: _nameOfNewbornController.text,
        birthOutcome: Birth_outcome.Abortion,
        headCircumference: _headCircumferenceController.text,
        length: _lengthController.text,
        weight: _weightController.text,
        pulse: _pulseController.text,
        temperature: _temperatureController.text,
        respiratoryRate: _respiratoryRateController.text,
        apgarScore: double.parse(_apgarScoreController.text),
        breastfeeding: _breastfeedingController.text,
        congenitalMalformation: _congenitalMalformationController.text,
        medication: _medicationController.text,
        vaccineName: selectedVaccine ?? '',
        complicationAfterBirth: _complicationAfterBirthController.text,
        diagnosis: _diagnosisController.text,
        referred: _referredController.text,
        doctorName: selectedDoctor ?? '',
        midwifeName: selectedMidwife ?? '',
        nurseName: selectedNurses ?? '',
        midwifeid: int.parse(selectedMidwife ?? '0'),
        vaccineid: int.parse(selectedVaccine ?? '0'),
        doctorid: int.parse(selectedDoctor ?? '0'),
        nurseid: int.parse(selectedNurses ?? '0'),
      );

      try {
        // Call the createMother function to submit the data to the server
        await createNewbornExamination(newborn);
        //show success alert
        NewbornExaminationAlert.showSuccessAlert(context, newborn);
        //clear form
        _formKey.currentState!.reset();
        _nameOfNewbornController.clear();
        _headCircumferenceController.clear();
        _lengthController.clear();
        _weightController.clear();
        _pulseController.clear();
        _temperatureController.clear();
        _temperatureController.clear();
        _respiratoryRateController.clear();
        _breastfeedingController.clear();
        _congenitalMalformationController.clear();
        _diagnosisController.clear();
        _referredController.clear();
        _nurseNameController.clear();
        _doctorNameController.clear();
        _apgarScoreController.clear();
        _medicationController.clear();
      } catch (e) {
        NewbornExaminationAlert.showError(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mother Details'),
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
                  TextFormField(
                    controller: _nameOfNewbornController,
                    decoration: InputDecoration(
                      labelText: 'Name of Newborn',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please fill this field';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _headCircumferenceController,
                    decoration: InputDecoration(
                      labelText: 'head Circumference',
                    ),
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
                      labelText: 'length of Newborn',
                    ),
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
                      labelText: 'weight of Newborn',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please fill this field';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _pulseController,
                    decoration: InputDecoration(
                      labelText: 'pulse of Newborn',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please fill this field';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _temperatureController,
                    decoration: InputDecoration(
                      labelText: 'Temperature',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please fill this field';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _respiratoryRateController,
                    decoration: InputDecoration(
                      labelText: 'respiratory Rate',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please fill this field';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _breastfeedingController,
                    decoration: InputDecoration(
                      labelText: 'breastfeeding of Mother',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please fill this field';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _congenitalMalformationController,
                    decoration: InputDecoration(
                      labelText: 'congenital Malformation',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please fill this field';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _medicationController,
                    decoration: InputDecoration(
                      labelText: 'Medication',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please fill this field';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _complicationAfterBirthController,
                    decoration: InputDecoration(
                      labelText: 'complication After Birth',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please fill this field';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _apgarScoreController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'apgar Score',
                      hintText: 'enter number less 10',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please fill this field';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _diagnosisController,
                    decoration: InputDecoration(
                      labelText: 'Diagnosis',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please fill this field';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _referredController,
                    decoration: InputDecoration(
                      labelText: 'Referred',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please fill this field';
                      }
                      return null;
                    },
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
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedNurses,
                          onChanged: (value) {
                            setState(() {
                              selectedNurses = value!;
                            });
                          },
                          items: nurses.map((nurse) {
                            return DropdownMenuItem<String>(
                              value: nurse['id'].toString(),
                              child: Text(nurse['name']),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            labelText: 'Nurse',
                          ),
                        ),
                      ),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedVaccine,
                          onChanged: (value) {
                            setState(() {
                              selectedVaccine = value!;
                            });
                          },
                          items: vaccines.map((vaccine) {
                            return DropdownMenuItem<String>(
                              value: vaccine['id'].toString(),
                              child: Text(vaccine['name']),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            labelText: 'Vaccine',
                          ),
                        ),
                      ),
                    ],
                  ),
                  DropdownButtonFormField<Sex>(
                    decoration: InputDecoration(
                        labelText: 'Sex of newborn',
                        hintText: 'select an option'),
                    value: _sex,
                    onChanged: (newValue) {
                      setState(() {
                        _sex = newValue;
                      });
                    },
                    items: Sex.values.map((value) {
                      return DropdownMenuItem<Sex>(
                        value: value,
                        child: Text(value.toString().split('.').last),
                      );
                    }).toList(),
                  ),
                  DropdownButtonFormField<Birth_outcome>(
                    decoration: InputDecoration(
                        labelText: 'outcome of birth',
                        hintText: 'select an option'),
                    value: _birthOutcome,
                    onChanged: (newValue) {
                      setState(() {
                        _birthOutcome = newValue;
                      });
                    },
                    items: Birth_outcome.values.map((value) {
                      return DropdownMenuItem<Birth_outcome>(
                        value: value,
                        child: Text(value.toString().split('.').last),
                      );
                    }).toList(),
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

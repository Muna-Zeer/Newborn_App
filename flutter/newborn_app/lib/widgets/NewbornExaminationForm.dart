import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:newborn_app/alert/NewbornExaminationAlert.dart';
import 'package:newborn_app/constant/models/motherExamination.dart';
import 'package:newborn_app/constant/models/newbornExamination.dart';
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
          vaccineName: _vaccineNameController.text,
          complicationAfterBirth: _complicationAfterBirthController.text,
          diagnosis: _diagnosisController.text,
          referred: _referredController.text,
          doctorName: _doctorNameController.text,
          midwifeName: _midwifeNameController.text,
          nurseName: _nurseNameController.text);

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
                    controller: _vaccineNameController,
                    decoration: InputDecoration(
                      labelText: 'Name of vaccine',
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
                  TextFormField(
                    controller: _nurseNameController,
                    decoration: InputDecoration(
                      labelText: 'Name of Nurse',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please fill this field';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _midwifeNameController,
                    decoration: InputDecoration(
                      labelText: 'Name of Midwife',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please fill this field';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _doctorNameController,
                    decoration: InputDecoration(
                      labelText: 'Name of doctor',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please fill this field';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _midwifeNameController,
                    decoration: InputDecoration(
                      labelText: 'Name of Midwife',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please fill this field';
                      }
                      return null;
                    },
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

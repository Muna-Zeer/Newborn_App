import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:newborn_app/alert/motherExaminationAlert.dart';
import 'package:newborn_app/constant/models/motherExamination.dart';
import 'package:newborn_app/methods/doctor_api.dart';
import 'package:newborn_app/methods/motherExamination_api.dart';
import 'dart:convert';

import 'package:uuid/uuid.dart';

class MotherExaminationForm extends StatefulWidget {
  final int motherId;
  const MotherExaminationForm({Key? key, required this.motherId})
      : super(key: key);
  _MotherExaminationFormState createState() => _MotherExaminationFormState();
}

class _MotherExaminationFormState extends State<MotherExaminationForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameOfMotherController = TextEditingController();
  final _ageController = TextEditingController();
  final _motherWeight = TextEditingController();
  final _strengthOfBlood = TextEditingController();
  PlaceOfBirth? _placeOfBirth;
  final _timeOfDeliveryController = TextEditingController(text: '12:00');
  final _dateOfDeliveryController = TextEditingController(text: 'yyyy,MM,dd');
  final _weeksOfPregnancyController = TextEditingController();
  final _complicationAfterDelivery = TextEditingController();
  MethodOfDelivery? _methodOfDeliveryController;
  bool _episiotomy = false;
  bool _firstBorn = false;
  bool _BPStatus = false;

  PerinealTear? _perinealTear;
  bool _bleedingAfterDelivery = false;
  bool _bloodTransfusion = false;
  final _tempController = TextEditingController();
  final _BPController = TextEditingController();
  final _doctorName = TextEditingController();
  final _midwifeName = TextEditingController();
  final _nurseName = TextEditingController();

  final _diagnosisController = TextEditingController();
  String _bpClassification = '';
  //convert text input into timeofDay and datetime
  final _referredController = TextEditingController();
  int? _selectedDay;
  List<String> _days = [
    'Day 0',
    'Day 1',
    'Day 2',
    'Day 3',
    'Day 4',
    'Day 5',
    'Day 6'
  ];
  List<Map<String, dynamic>> nurses = [];

  List<Map<String, dynamic>> doctors = [];
  List<Map<String, dynamic>> midwives = [];

  String? selectedNurses;
  String? selectedDoctor;
  String? selectedMidwife;

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

      setState(() {
        nurses = fetchedNurses;
        doctors = fetchedDoctors;
        midwives = fetchedMidwives;

        selectedNurses =
            fetchedNurses.isNotEmpty ? fetchedNurses[0]['id'].toString() : null;

        selectedMidwife = fetchedMidwives.isNotEmpty
            ? fetchedMidwives[0]['id'].toString()
            : null;

        selectedDoctor = fetchedDoctors.isNotEmpty
            ? fetchedDoctors[0]['id'].toString()
            : null;
      });
    } catch (error) {
      print('Failed to fetch data: $error');
    }
  }

  @override
  void dispose() {
    _weeksOfPregnancyController.dispose();
    super.dispose();
  }

  String getWeekAndDay() {
    final weeks = _weeksOfPregnancyController.text;
    final day = _days[_selectedDay ?? 0].split(' ')[1];
    return '$weeks.$day';
  }

  //create function to save fields
  void _saveKey() async {
    if (_formKey.currentState!.validate()) {
      var uuid = Uuid().v4();
      var mother = MotherExaminations(
        id: uuid,
        nameOfMother: _nameOfMotherController.text,
        age: int.parse(_ageController.text),
        placeOfBirth: PlaceOfBirth.Clinic,
        timeOfDelivery: TimeOfDay.fromDateTime(
            DateFormat('hh:mm a').parse(_timeOfDeliveryController.text)),
        dateOfDelivery: DateTime.parse(_dateOfDeliveryController.text),
        weeksOfPregnancy: _weeksOfPregnancyController.text,
        methodOfDelivery: MethodOfDelivery.Normal,
        episiotomy: _episiotomy,
        perinealTear: PerinealTear.grade1,
        bleedingAfterDelivery: _bleedingAfterDelivery,
        bloodTransfusion: _bloodTransfusion,
        temp: _tempController.text,
        bp: _BPController.text,
        complicationAfterDelivery: _complicationAfterDelivery.text,
        diagnosis: _diagnosisController.text,
        referred: _referredController.text,
        doctorName: selectedDoctor ?? '',
        midwifeName: selectedMidwife ?? '',
        nurseName: selectedNurses ?? '',
        midwifeid: int.parse(selectedMidwife ?? '0'),
        doctorid: int.parse(selectedDoctor ?? '0'),
        nurseid: int.parse(selectedNurses ?? '0'),
        FirstBorn: _firstBorn,
        BP_Status: _BPStatus,
        StrengthOfBlood: int.parse(_strengthOfBlood.text),
        MotherWeight: int.parse(_motherWeight.text),
      );
      try {
        // Call the createMother function to submit the data to the server
        await createMotherExamination(mother);
        //show success alert
        MotherExaminationAlert.showSuccessAlert(context, mother);
        //clear form
        _formKey.currentState!.reset();
        _nameOfMotherController.clear();
        _ageController.clear();
        _timeOfDeliveryController.clear();
        _dateOfDeliveryController.clear();
        _weeksOfPregnancyController.clear();
        _complicationAfterDelivery.clear();
        _tempController.clear();
        _BPController.clear();
        _nurseName.clear();
        _midwifeName.clear();
        _doctorName.clear();
        _diagnosisController.clear();
      } catch (e) {
        MotherExaminationAlert.showError(context);
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
                    controller: _nameOfMotherController,
                    decoration: InputDecoration(
                      labelText: 'Name of Mother',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please fill this field';
                      }
                      return null;
                    },
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Episiotomy:'),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<bool>(
                              value: true,
                              title: Text('Yes'),
                              groupValue: _episiotomy,
                              onChanged: (bool? value) {
                                setState(() {
                                  _episiotomy = value!;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<bool>(
                              value: false,
                              title: Text('No'),
                              groupValue: _episiotomy,
                              onChanged: (bool? value) {
                                setState(() {
                                  _episiotomy = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Text('Bleeding After Delivery:'),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<bool>(
                              value: true,
                              title: Text('Yes'),
                              groupValue: _bleedingAfterDelivery,
                              onChanged: (bool? value) {
                                setState(() {
                                  _bleedingAfterDelivery = value!;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<bool>(
                              value: false,
                              title: Text('No'),
                              groupValue: _bleedingAfterDelivery,
                              onChanged: (bool? value) {
                                setState(() {
                                  _bleedingAfterDelivery = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Text('blood pressure status:'),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<bool>(
                              value: true,
                              title: Text('Normal'),
                              groupValue: _BPStatus,
                              onChanged: (bool? value) {
                                setState(() {
                                  _BPStatus = value!;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<bool>(
                              value: false,
                              title: Text('Abnormal'),
                              groupValue: _BPStatus,
                              onChanged: (bool? value) {
                                setState(() {
                                  _BPStatus = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Text('[First born]:'),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<bool>(
                              value: true,
                              title: Text('Yes'),
                              groupValue: _firstBorn,
                              onChanged: (bool? value) {
                                setState(() {
                                  _firstBorn = value!;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<bool>(
                              value: false,
                              title: Text('No'),
                              groupValue: _firstBorn,
                              onChanged: (bool? value) {
                                setState(() {
                                  _firstBorn = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Text('Blood Transfusion:'),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<bool>(
                              value: true,
                              title: Text('Yes'),
                              groupValue: _bloodTransfusion,
                              onChanged: (bool? value) {
                                setState(() {
                                  _bloodTransfusion = value!;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<bool>(
                              value: false,
                              title: Text('No'),
                              groupValue: _bloodTransfusion,
                              onChanged: (bool? value) {
                                setState(() {
                                  _bloodTransfusion = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  DropdownButtonFormField<PlaceOfBirth>(
                    decoration: InputDecoration(
                        labelText: 'place of birth',
                        hintText: 'select an option'),
                    value: _placeOfBirth,
                    onChanged: (newValue) {
                      setState(() {
                        _placeOfBirth = newValue;
                      });
                    },
                    items: PlaceOfBirth.values.map((value) {
                      return DropdownMenuItem<PlaceOfBirth>(
                        value: value,
                        child: Text(value.toString().split('.').last),
                      );
                    }).toList(),
                  ),
                  TextFormField(
                    controller: _BPController,
                    decoration: InputDecoration(
                      labelText: 'Blood Pressure (mmHg)',
                      suffixText: _bpClassification,
                      suffixStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _bpClassification == 'Normal'
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter blood pressure';
                      }
                      if (!RegExp(r'^\d{2,3}/\d{2,3}$').hasMatch(value)) {
                        return 'Please enter blood pressure in format of xx/xx';
                      }
                      final bpValues = value.split('/');
                      final systolic = int.tryParse(bpValues[0]);
                      final diastolic = int.tryParse(bpValues[1]);
                      if (systolic == null || diastolic == null) {
                        return 'Please enter valid numbers for systolic and diastolic values';
                      }
                      if (systolic < 90 || diastolic < 60) {
                        _bpClassification = 'Low';
                      } else if (systolic >= 90 &&
                          systolic <= 129 &&
                          diastolic >= 60 &&
                          diastolic <= 89) {
                        _bpClassification = 'Stage 1 hypertension';
                      } else if (systolic >= 130 && systolic <= 139 ||
                          diastolic >= 90 && diastolic <= 99) {
                        _bpClassification = 'Stage 2 hypertension';
                      } else if (systolic >= 140 || diastolic >= 100) {
                        _bpClassification = 'Hypertensive crisis';
                      } else {
                        _bpClassification = 'Normal';
                      }
                      return null;
                    },
                  ),
                  TextField(
                    controller: _complicationAfterDelivery,
                    decoration: InputDecoration(
                      labelText: 'complicationAfterDelivery',
                      hintText: 'Enter complicationAfterDelivery details',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 20),
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                  SizedBox(width: 20),
                  TextFormField(
                    controller: _tempController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      labelText: 'Temperature',
                      suffixIcon: Icon(Icons.ac_unit),
                      suffixText: '°C',
                      suffixStyle: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please fill this field';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _motherWeight,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                      labelText: 'Mother weight',
                      suffixIcon: Icon(Icons.fitness_center),
                      suffixText: 'kg',
                      suffixStyle: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please fill this field';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _strengthOfBlood,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      labelText: 'Strength of blood',
                      suffixIcon: Icon(Icons.favorite),
                      suffixText: 'ml',
                      suffixStyle: TextStyle(fontWeight: FontWeight.bold),
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
                        hintText: 'Enter diagnosis details',
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
                    controller: _referredController,
                    decoration: InputDecoration(labelText: 'Referred'),
                    maxLines: null,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please fill this field';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<PerinealTear>(
                    decoration: InputDecoration(
                        labelText: 'PerinealTear grade',
                        hintText: 'select an option'),
                    value: _perinealTear,
                    onChanged: (newValue) {
                      setState(() {
                        _perinealTear = newValue;
                      });
                    },
                    items: PerinealTear.values.map((value) {
                      return DropdownMenuItem<PerinealTear>(
                        value: value,
                        child: Text(value.toString().split('.').last),
                      );
                    }).toList(),
                  ),
                  DropdownButtonFormField<MethodOfDelivery>(
                    decoration: InputDecoration(
                      labelText: 'Method of delivery',
                      hintText: 'Select an option',
                    ),
                    value: _methodOfDeliveryController,
                    onChanged: (newValue) {
                      setState(() {
                        _methodOfDeliveryController = newValue;
                      });
                    },
                    items: MethodOfDelivery.values.map((value) {
                      return DropdownMenuItem<MethodOfDelivery>(
                        value: value,
                        child: Text(value.toString().split('.').last),
                      );
                    }).toList(),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _weeksOfPregnancyController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            labelText: 'Weeks',
                            suffixText: 'week',
                            suffixStyle: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text('Number ofDays'),
                      DropdownButton<int>(
                        value: _selectedDay,
                        onChanged: (int? newValue) {
                          setState(() {
                            _selectedDay = newValue;
                          });
                        },
                        items: _days
                            .asMap()
                            .entries
                            .map(
                              (entry) => DropdownMenuItem<int>(
                                value: entry.key,
                                child: Text(entry.value),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      labelText: 'Enter age of mother',
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a number';
                      }

                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _dateOfDeliveryController,
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
                          _dateOfDeliveryController.text = formattedDate;
                        });
                      }
                    },
                  ),
                  TextFormField(
                    controller: _timeOfDeliveryController,
                    onTap: () async {
                      final initialTime = TimeOfDay.now();
                      final selectedTime = await showTimePicker(
                        context: context,
                        initialTime: initialTime,
                      );
                      if (selectedTime != null) {
                        _timeOfDeliveryController.text =
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
                    ],
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

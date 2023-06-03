import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:newborn_app/alert/motherExaminationAlert.dart';
import 'package:newborn_app/alert/motherPostnatalAlerts.dart';
import 'package:newborn_app/constant/models/motherExamination.dart';
import 'package:newborn_app/constant/models/postnatalExaminations.dart';
import 'package:newborn_app/methods/doctor_api.dart';
import 'package:newborn_app/methods/motherExamination_api.dart';
import 'package:newborn_app/methods/postnatalExamination_api.dart';
import 'dart:convert';

import 'package:uuid/uuid.dart';

class MotherPostnatalExamination extends StatefulWidget {
  final int motherId;
  const MotherPostnatalExamination({Key? key, required this.motherId})
      : super(key: key);
  _MotherPostnatalFormState createState() => _MotherPostnatalFormState();
}

class _MotherPostnatalFormState extends State<MotherPostnatalExamination> {
  @override
  final _formKey = GlobalKey<FormState>();
  String _bpClassification = '';
  DateTime? futureDate;
  final _TempController = TextEditingController();
  final _PulseController = TextEditingController();
  final _BPController = TextEditingController();
  final _HbController = TextEditingController();
  final _RecommendationsController = TextEditingController();
  final _RemarksController = TextEditingController();
  final _Family_Planing_Counseling = TextEditingController();
  final _Fundal_HeightController = TextEditingController();
  final _day_after_deliveryController = TextEditingController();

  Breasts? _breast;
  Lochia_Color? _lochia_color;
  Incision? _incision;
  if_yes? _trueValue;
  bool _Blood_Transfusion = false;
  bool _Seizures = false;
  bool _Rupture_Uterus = false;
  bool _DVT = false;
  bool bleeding_after_delivery = false;

  final _FPappointment = TextEditingController(text: 'yyyy,MM,dd');
  final _date_of_visit = TextEditingController(text: 'yyyy,MM,dd');

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

  void _saveKey() async {
    if (_formKey.currentState!.validate()) {
      var uuid = Uuid().v4();
      var mother = PostnatalExaminations(
        id: uuid,
        dayAfterDelivery: int.parse(_day_after_deliveryController.text),
        dateOfVisit: DateTime.parse(_date_of_visit.text),
        temp: _TempController.text,
        pulse: _PulseController.text,
        bp: _BPController.text,
        bleedingAfterDelivery: bleeding_after_delivery,
        hb: _HbController.text,
        dvt: _DVT,
        ruptureUterus: _Rupture_Uterus,
        ifYes: if_yes.Repaired,
        lochiaColor: Lochia_Color.Red,
        incision: Incision.Clean,
        seizures: _Seizures,
        bloodTransfusion: _Blood_Transfusion,
        breasts: Breasts.Abnormal_Secretions,
        fundalHeight: int.parse(_Fundal_HeightController.text),
        familyPlanningCounseling: _Family_Planing_Counseling.text,
        fpAppointment: DateTime.parse(_FPappointment.text),
        recommendations: _RecommendationsController.text,
        remarks: _RemarksController.text,
        doctorName: selectedDoctor ?? '',
        midwifeName: selectedMidwife ?? '',
        nurseName: selectedNurses ?? '',
        midwifeid: int.parse(selectedMidwife ?? '0'),
        doctorid: int.parse(selectedDoctor ?? '0'),
        nurseid: int.parse(selectedNurses ?? '0'),
      );
      try {
        // Call the createMother function to submit the data to the server
        await createPostnatalExamination(mother);
        //show success alert
        MotherPostnatalAlert.showSuccessAlert(context);
        //clear form
        _formKey.currentState!.reset();
        _TempController.clear();
        _PulseController.clear();
        _BPController.clear();
        _HbController.clear();
        _RecommendationsController.clear();
        _RemarksController.clear();
        _Family_Planing_Counseling.clear();
        _Fundal_HeightController.clear();
        _day_after_deliveryController.clear();
    
      } catch (e) {
        MotherPostnatalAlert.showError(context);
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
                    controller: _TempController,
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
                    controller: _PulseController,
                    decoration: InputDecoration(
                      labelText: 'pulse',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please fill this field';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _HbController,
                    decoration: InputDecoration(
                      labelText: 'HB',
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
                      Text('bleeding_after_delivery:'),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<bool>(
                              value: true,
                              title: Text('Yes'),
                              groupValue: bleeding_after_delivery,
                              onChanged: (bool? value) {
                                setState(() {
                                  bleeding_after_delivery = value!;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<bool>(
                              value: false,
                              title: Text('No'),
                              groupValue: bleeding_after_delivery,
                              onChanged: (bool? value) {
                                setState(() {
                                  bleeding_after_delivery = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Text('DVT:'),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<bool>(
                              value: true,
                              title: Text('Yes'),
                              groupValue: _DVT,
                              onChanged: (bool? value) {
                                setState(() {
                                  _DVT = value!;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<bool>(
                              value: false,
                              title: Text('No'),
                              groupValue: _DVT,
                              onChanged: (bool? value) {
                                setState(() {
                                  _DVT = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Text('Rupture_Uterus'),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<bool>(
                              value: true,
                              title: Text('yes'),
                              groupValue: _Rupture_Uterus,
                              onChanged: (bool? value) {
                                setState(() {
                                  _Rupture_Uterus = value!;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<bool>(
                              value: false,
                              title: Text('No'),
                              groupValue: _Rupture_Uterus,
                              onChanged: (bool? value) {
                                setState(() {
                                  _Rupture_Uterus = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Text('Seizures:'),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<bool>(
                              value: true,
                              title: Text('Yes'),
                              groupValue: _Seizures,
                              onChanged: (bool? value) {
                                setState(() {
                                  _Seizures = value!;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<bool>(
                              value: false,
                              title: Text('No'),
                              groupValue: _Seizures,
                              onChanged: (bool? value) {
                                setState(() {
                                  _Seizures = value!;
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
                              groupValue: _Blood_Transfusion,
                              onChanged: (bool? value) {
                                setState(() {
                                  _Blood_Transfusion = value!;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<bool>(
                              value: false,
                              title: Text('No'),
                              groupValue: _Blood_Transfusion,
                              onChanged: (bool? value) {
                                setState(() {
                                  _Blood_Transfusion = value!;
                                });
                              },
                            ),
                          ),
                        ],
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
                  TextFormField(
                    controller: _Family_Planing_Counseling,
                    decoration: InputDecoration(
                      labelText: 'Family_Planing_Counseling',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please fill this field';
                      }
                      return null;
                    },
                  ),
                  TextField(
                    controller: _RecommendationsController,
                    decoration: InputDecoration(
                      labelText: 'Recommendation',
                      hintText: 'Enter Recomendation details',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 20),
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                  TextField(
                    controller: _RemarksController,
                    decoration: InputDecoration(
                      labelText: 'Remarks',
                      hintText: 'Enter Remarks details',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 20),
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                  DropdownButtonFormField<Breasts>(
                    decoration: InputDecoration(
                        labelText: 'Breasts', hintText: 'select an option'),
                    value: _breast,
                    onChanged: (newValue) {
                      setState(() {
                        _breast = newValue;
                      });
                    },
                    items: Breasts.values.map((value) {
                      return DropdownMenuItem<Breasts>(
                        value: value,
                        child: Text(value.toString().split('.').last),
                      );
                    }).toList(),
                  ),
                  DropdownButtonFormField<Incision>(
                    decoration: InputDecoration(
                        labelText: 'Incision', hintText: 'select an option'),
                    value: _incision,
                    onChanged: (newValue) {
                      setState(() {
                        _incision = newValue;
                      });
                    },
                    items: Incision.values.map((value) {
                      return DropdownMenuItem<Incision>(
                        value: value,
                        child: Text(value.toString().split('.').last),
                      );
                    }).toList(),
                  ),
                  DropdownButtonFormField<if_yes>(
                    decoration: InputDecoration(
                        labelText: 'Incision', hintText: 'select an option'),
                    value: _trueValue,
                    onChanged: (newValue) {
                      setState(() {
                        _trueValue = newValue;
                      });
                    },
                    items: if_yes.values.map((value) {
                      return DropdownMenuItem<if_yes>(
                        value: value,
                        child: Text(value.toString().split('.').last),
                      );
                    }).toList(),
                  ),
                  DropdownButtonFormField<Lochia_Color>(
                    decoration: InputDecoration(
                        labelText: 'Lochia_Color',
                        hintText: 'select an option'),
                    value: _lochia_color,
                    onChanged: (newValue) {
                      setState(() {
                        _lochia_color = newValue;
                      });
                    },
                    items: Lochia_Color.values.map((value) {
                      return DropdownMenuItem<Lochia_Color>(
                        value: value,
                        child: Text(value.toString().split('.').last),
                      );
                    }).toList(),
                  ),
                  TextFormField(
                    controller: _day_after_deliveryController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      labelText: 'Enter numbers after delivery newborns',
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a number of days after delivery of newborns';
                      }

                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _Fundal_HeightController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      labelText: 'Enter  number Fundal_Height',
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
                    controller: _date_of_visit,
                    decoration: InputDecoration(labelText: 'Date of visit'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a date of visit';
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
                          _date_of_visit.text = formattedDate;
                        });
                      }
                    },
                  ),
                  TextFormField(
                    controller: _FPappointment,
                    decoration:
                        InputDecoration(labelText: 'Date of appointment'),
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
                        firstDate: DateTime
                            .now(), // Update firstDate to be current date
                        lastDate: DateTime.now().add(Duration(
                            days: 365)), // Limit selection to one year from now
                      );
                      if (pickedDate != null) {
                        // Add the number of days you want to advance the appointment to the selected date
                        futureDate = pickedDate.add(Duration(
                            days: 7)); // Example: advance appointment by 7 days
                        final formattedDate =
                            DateFormat('yyyy-MM-dd').format(futureDate!);
                        setState(() {
                          _FPappointment.text = formattedDate;
                        });
                      }
                    },
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

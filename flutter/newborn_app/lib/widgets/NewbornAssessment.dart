import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:newborn_app/alert/newbornAssessmentAlert.dart';
import 'package:newborn_app/constant/models/newbornAssessments.dart';
import 'package:newborn_app/methods/newbornAssessments_api.dart';

import 'dart:convert';

import 'package:uuid/uuid.dart';

class NewbornAssessmentForm extends StatefulWidget {
  final int motherId;
  const NewbornAssessmentForm({Key? key, required this.motherId})
      : super(key: key);
  _NewbornAssessmentState createState() => _NewbornAssessmentState();
}

class _NewbornAssessmentState extends State<NewbornAssessmentForm> {
  final _formKey = GlobalKey<FormState>();
  final _birthWeightController = TextEditingController();
  final _dateOfDeliveryController = TextEditingController();
  mode_of_delivery? _modeOfDelivery;
  final _gestationalAgeAtDeliveryController = TextEditingController();
  final _tempController = TextEditingController();
  final _pulseController = TextEditingController();
  final _respRateController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _hcController = TextEditingController();
  Sex? _sex;
  Congenital_Malformation? _congenitalMalformation;
  Jaundice? _jaundice;
  Cyanosis? _cyanosis;
  final _umbilicalStumpController = TextEditingController();
  Feeding? _feeding;
  final _remarksController = TextEditingController();
  final _doctorNameController = TextEditingController();
  final _midwifeNameController = TextEditingController();
  final _nurseNameController = TextEditingController();

  void _saveKey() async {
    if (_formKey.currentState!.validate()) {
      var uuid = Uuid().v4(); // generate a unique ID
      var newborn = NewbornAssessments(
        id: uuid,
        birthWeight: _birthWeightController.text,
        dateOfDelivery: DateTime.parse(_dateOfDeliveryController.text),
        modeOfDelivery: _modeOfDelivery!,
        gestationalAgeAtDelivery: _gestationalAgeAtDeliveryController.text,
        temp: _tempController.text,
        pulse: _pulseController.text,
        respRate: _respRateController.text,
        weight: int.parse(_weightController.text),
        height: int.parse(_heightController.text),
        hc: int.parse(_hcController.text),
        sex: Sex.Female,
        congenitalMalformation: _congenitalMalformation!,
        jaundice: _jaundice!,
        cyanosis: _cyanosis!,
        umbilicalStump: _umbilicalStumpController.text,
        feeding: _feeding!,
        remarks: _remarksController.text,
        doctorName: _doctorNameController.text,
        midwifeName: _midwifeNameController.text,
        nurseName: _nurseNameController.text,
      );
      // Call the createNewborn function to submit the data to the server
      try {
        await createNewbornAssessment(newborn);
        // Show success alert
        NewbornAssessmentAlert.showSuccessAlert(context, newborn);
        // Clear form
        _formKey.currentState!.reset();
        _birthWeightController.clear();
        _dateOfDeliveryController.clear();
        _gestationalAgeAtDeliveryController.clear();
        _tempController.clear();
        _pulseController.clear();
        _respRateController.clear();
        _weightController.clear();
        _heightController.clear();
        _hcController.clear();
        _umbilicalStumpController.clear();
        _remarksController.clear();
        _doctorNameController.clear();
        _midwifeNameController.clear();
        _nurseNameController.clear();
      } catch (e) {
        // Show error alert
        NewbornAssessmentAlert.showError(context, e.toString());
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
                    controller: _gestationalAgeAtDeliveryController,
                    decoration: InputDecoration(
                      labelText: 'gestational Age At Deliver',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please fill this field';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _birthWeightController,
                    decoration: InputDecoration(
                      labelText: 'gestational birth Weight',
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
                      labelText: 'pulse of newborn',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please fill this field';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _respRateController,
                    decoration: InputDecoration(
                      labelText: 'respRate',
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
                        labelText: 'Sex', hintText: 'select an option'),
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
                  TextFormField(
                    controller: _remarksController,
                    decoration: InputDecoration(
                      labelText: 'Remark',
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    style: TextStyle(fontSize: 16, height: 1.5),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please fill this field';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _umbilicalStumpController,
                    decoration: InputDecoration(
                      labelText: 'umbilical Stump',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please fill this field';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<mode_of_delivery>(
                    decoration: InputDecoration(
                        labelText: 'mode_of_delivery',
                        hintText: 'select an option'),
                    value: _modeOfDelivery,
                    onChanged: (newValue) {
                      setState(() {
                        _modeOfDelivery = newValue;
                      });
                    },
                    items: mode_of_delivery.values.map((value) {
                      return DropdownMenuItem<mode_of_delivery>(
                        value: value,
                        child: Text(value.toString().split('.').last),
                      );
                    }).toList(),
                  ),
                  DropdownButtonFormField<Jaundice>(
                    decoration: InputDecoration(
                        labelText: 'Jaundice', hintText: 'select an option'),
                    value: _jaundice,
                    onChanged: (newValue) {
                      setState(() {
                        _jaundice = newValue;
                      });
                    },
                    items: Jaundice.values.map((value) {
                      return DropdownMenuItem<Jaundice>(
                        value: value,
                        child: Text(value.toString().split('.').last),
                      );
                    }).toList(),
                  ),
                  DropdownButtonFormField<Cyanosis>(
                    decoration: InputDecoration(
                        labelText: 'Cyanosis', hintText: 'Cyanosis'),
                    value: _cyanosis,
                    onChanged: (newValue) {
                      setState(() {
                        _cyanosis = newValue;
                      });
                    },
                    items: Cyanosis.values.map((value) {
                      return DropdownMenuItem<Cyanosis>(
                        value: value,
                        child: Text(value.toString().split('.').last),
                      );
                    }).toList(),
                  ),
                  DropdownButtonFormField<Feeding>(
                    decoration: InputDecoration(
                        labelText: 'Feeding', hintText: 'select an option'),
                    value: _feeding,
                    onChanged: (newValue) {
                      setState(() {
                        _feeding = newValue;
                      });
                    },
                    items: Feeding.values.map((value) {
                      return DropdownMenuItem<Feeding>(
                        value: value,
                        child: Text(value.toString().split('.').last),
                      );
                    }).toList(),
                  ),
                  DropdownButtonFormField<Congenital_Malformation>(
                    decoration: InputDecoration(
                        labelText: 'Congenital_Malformation',
                        hintText: 'select an option'),
                    value: _congenitalMalformation,
                    onChanged: (newValue) {
                      setState(() {
                        _congenitalMalformation = newValue;
                      });
                    },
                    items: Congenital_Malformation.values.map((value) {
                      return DropdownMenuItem<Congenital_Malformation>(
                        value: value,
                        child: Text(value.toString().split('.').last),
                      );
                    }).toList(),
                  ),
                  TextFormField(
                    controller: _doctorNameController,
                    decoration: InputDecoration(labelText: 'Name of Doctor'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please fill this field';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _midwifeNameController,
                    decoration: InputDecoration(labelText: 'midwife Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please fill this field';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _nurseNameController,
                    decoration: InputDecoration(labelText: 'Name of Nurse'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please fill this field';
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
                  //
                  //Weight of newborn text field
                  TextField(
                    controller: _weightController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      labelText: 'Weight of newborn',
                      suffixText: 'grams',
                      suffixStyle: TextStyle(fontWeight: FontWeight.bold),
                    ),
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
                  TextField(
                    controller: _heightController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      labelText: 'Height of newborn',
                      suffixText: 'centimeters',
                      suffixStyle: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),

                  TextField(
                    controller: _hcController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      labelText: 'Head circumference of newborn',
                      suffixText: 'centimeters',
                      suffixStyle: TextStyle(fontWeight: FontWeight.bold),
                    ),
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

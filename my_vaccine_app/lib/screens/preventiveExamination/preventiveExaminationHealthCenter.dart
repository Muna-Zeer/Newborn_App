import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:my_vaccine_app/apiServer.dart';

class PreventiveExaminationCenter extends StatefulWidget {
  @override
  _PreventiveExaminationCenterState createState() =>
      _PreventiveExaminationCenterState();
}

class _PreventiveExaminationCenterState
    extends State<PreventiveExaminationCenter> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _examTypeController = TextEditingController();
  TextEditingController _dateController =
      TextEditingController(text: 'yyyy,MM,dd');
  TextEditingController _timeController = TextEditingController(text: '12:00');
  TextEditingController _resultController = TextEditingController();
  TextEditingController _newbornIdController = TextEditingController();
  TextEditingController _healthCenterIdController = TextEditingController();
  TextEditingController _ministryIdController = TextEditingController();
  TextEditingController _nurseIdController = TextEditingController();

  void submitForm() async {
    if (_formKey.currentState!.validate()) {
      final preventiveExamination = {
        'exam_type': _examTypeController.text,
        'date': _dateController.text,
        'time': _timeController.text,
        'result': _resultController.text,
        'newborn_id': _newbornIdController.text,
        'health_center_id': int.parse(_healthCenterIdController.text),
        'ministry_id': int.parse(_ministryIdController.text),
        'nurse_id': int.parse(_nurseIdController.text),
      };
      final baseUrl = ApiService.getBaseUrl();

      final url =
          Uri.parse('$baseUrl/preventiveExaminationsMinistry');
      final headers = <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      };
      final body = jsonEncode(preventiveExamination);

      try {
        final response = await http.post(url, headers: headers, body: body);
        if (response.statusCode == 201) {
          final responseData = json.decode(response.body);
          // Handle the created preventive examination object as needed
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Success'),
                content: Text('Preventive examination created successfully.'),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
          _examTypeController.clear();
          _dateController.clear();
          _timeController.clear();
          _resultController.clear();
          _newbornIdController.clear();
          _healthCenterIdController.clear();
          _ministryIdController.clear();
          _nurseIdController.clear();
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Failure'),
                content: Text('Failed to create preventive examination.'),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      } catch (error) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('An error occurred.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  void dispose() {
    _examTypeController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _resultController.dispose();
    _newbornIdController.dispose();
    _healthCenterIdController.dispose();
    _ministryIdController.dispose();
    _nurseIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preventive Examination Form'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _examTypeController,
                decoration: InputDecoration(
                  labelText: 'Exam Type',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an exam type';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Date',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a date';
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
                      _dateController.text = formattedDate;
                    });
                  }
                },
              ),
              TextFormField(
                controller: _timeController,
                decoration: InputDecoration(
                  labelText: 'Time',
                ),
                onTap: () async {
                  final initialTime = TimeOfDay.now();
                  final selectedTime = await showTimePicker(
                    context: context,
                    initialTime: initialTime,
                  );
                  if (selectedTime != null) {
                    _timeController.text = selectedTime.format(context);
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter time of delivery';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _resultController,
                decoration: InputDecoration(
                  labelText: 'Result',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a result';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _newbornIdController,
                decoration: InputDecoration(
                  labelText: 'Newborn ID',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a newborn ID';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _healthCenterIdController,
                decoration: InputDecoration(
                  labelText: 'Health Center ID',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a health center ID';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ministryIdController,
                decoration: InputDecoration(
                  labelText: 'Ministry ID',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a ministry ID';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nurseIdController,
                decoration: InputDecoration(
                  labelText: 'Nurse ID',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a nurse ID';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                child: Text('Submit'),
                onPressed: submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

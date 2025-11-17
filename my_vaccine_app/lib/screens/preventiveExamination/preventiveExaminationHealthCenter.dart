import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:my_vaccine_app/apiServer.dart';
import 'package:my_vaccine_app/widget/RtlFormBox.dart';

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

      final url = Uri.parse('$baseUrl/preventiveExaminationsMinistry');
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
              title: const Text('Error'),
              content: const Text('An error occurred.'),
              actions: <Widget>[
                TextButton(
                  child:const  Text('OK'),
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
        title:const Text('اضافة الفحوصات الوقائية'),
      ),
      body: Padding(
        padding:const  EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
           const   SizedBox(height: 8.0),
           RtlFormBox(
                label:    'اسم الفحص الوقائي',
                controller:_examTypeController  ,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the exam type";
                  }
                  return null;
                },
              ),
           const    SizedBox(height: 8.0),
          const     Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'التاريخ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )),
        const      SizedBox(height: 8.0),
              TextFormField(
                controller: _dateController,
                textAlign: TextAlign.right,
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
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    final formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    setState(() {
                      _dateController.text = formattedDate;
                    });
                  }
                },
              ),
      const        SizedBox(height: 8.0),
       const       Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'الوقت',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              TextFormField(
                controller: _timeController,
                textAlign: TextAlign.right,
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
        const       SizedBox(height: 8.0),
              RtlFormBox(
                label:   'النتيجة',
                controller:_resultController  ,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the result";
                  }
                  return null;
                },
              ),
            const   SizedBox(height: 8.0),
               RtlFormBox(
                label:     'رقم هوية الطفل',
                controller:_newbornIdController  ,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the newborn ID";
                  }
                  return null;
                },
              ),
           const    SizedBox(height: 8.0),
              RtlFormBox(
                label:    ' رقم المركز الصحة',
                controller:_healthCenterIdController  ,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the health center ID";
                  }
                  return null;
                },
              ),
              RtlFormBox(
                label:      'وزارة الصحة 1',
                controller:_ministryIdController ,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the ministry ID";
                  }
                  return null;
                },
              ),
         const     SizedBox(height: 8.0),
           const   SizedBox(height: 8.0),
          const     SizedBox(height: 8.0),
               RtlFormBox(
                label:    'اسم الممرضة',
                controller:_nurseIdController  ,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the nurse nme";
                  }
                  return null;
                },
              ),
           const   SizedBox(height: 8.0),
              ElevatedButton(
                child: Text('ارسال'),
                onPressed: submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

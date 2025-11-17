import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:my_vaccine_app/apiServer.dart';
import 'package:my_vaccine_app/screens/preventiveExamination/preventiveExamintationTable.dart';
import 'package:my_vaccine_app/widget/RtlFormBox.dart';

class PreventiveExaminationForm extends StatefulWidget {
  @override
  _PreventiveExaminationFormState createState() =>
      _PreventiveExaminationFormState();
}

class _PreventiveExaminationFormState extends State<PreventiveExaminationForm> {
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
      print("_timeController.text: ${_timeController.text}");
      final preventiveExamination = {
        'exam_type': _examTypeController.text,
        'date': _dateController.text,
        'time': _timeController.text,
        'result': _resultController.text,
        'ministry_id': int.parse(_ministryIdController.text),
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

          _ministryIdController.clear();
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
        backgroundColor: Colors.lightBlue,
        title:const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              ' اضافة الفحوصات الوقائية',
            ),
          ],
        ),
      ),
      body: Padding(
        padding:const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Container(
                width: 200.0,
                height: 200.0,
                child: Image.asset(
                  'assets/examination.jpg',
                  width: 300.0,
                  height: 300.0,
                  fit: BoxFit.cover,
                ),
              ),
            const  SizedBox(
                height: 16.0,
              ),
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
         const     SizedBox(
                height: 16.0,
              ),
              Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 2.0,
                        color: const Color.fromARGB(255, 2, 31, 54),
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2.0,
                            blurRadius: 5.0,
                            offset: Offset(0, 3)),
                      ]),
                  child: Column(children: [
              const      Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          'التاريخ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
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
                  ])),
           const   SizedBox(
                height: 16.0,
              ),
              Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 2.0,
                        color: const Color.fromARGB(255, 2, 31, 54),
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2.0,
                            blurRadius: 5.0,
                            offset: Offset(0, 3)),
                      ]),
                  child: Column(children: [
              const      Align(
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
                  ])),
     const         SizedBox(
                height: 16.0,
              ),
            RtlFormBox(
                label:     'النتيجة',
                controller:_resultController  ,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the result";
                  }
                  return null;
                },
              ),
         const     SizedBox(
                height: 16.0,
              ),
              RtlFormBox(
                label:      'رقم وزارة الصحة ',
                controller:_ministryIdController  ,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the minsitry ID";
                  }
                  return null;
                },
              ),
          const    SizedBox(
                height: 16.0,
              ),
              // ElevatedButton(
              //   child: Text('ارسال', textAlign: TextAlign.right),
              //   onPressed: submitForm,
              // ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                        onPressed: submitForm,
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.lightBlue)),
                        child: Text(
                          'ارسال',
                          textAlign: TextAlign.right,
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PreventiveExaminationTable()),
                        );
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.lightBlue)),
                      child: Text(
                        'مشاهدة الجدول',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

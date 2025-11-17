import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:my_vaccine_app/Alert_Dialog/feedingAlert.dart';
import 'package:my_vaccine_app/apiServer.dart';
import 'package:my_vaccine_app/screens/Feeding/feedingTable.dart';

class FeedingForm extends StatefulWidget {
  @override
  _FeedingFormState createState() => _FeedingFormState();
}

class _FeedingFormState extends State<FeedingForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController feedingTypeController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController monthController = TextEditingController();
  TextEditingController instructionsController = TextEditingController();
  TextEditingController ministryIdController = TextEditingController();

  Future<void> submitForm() async {
    if (_formKey.currentState!.validate()) {
      final baseUrl = ApiService.getBaseUrl();
      final url = Uri.parse('$baseUrl/feedings');
      final response = await http.post(
        url,
        body: {
          'feeding_type': feedingTypeController.text,
          'quantity': quantityController.text,
          'date': dateController.text,
          'month': monthController.text,
          'instructions': instructionsController.text,
          'ministry_id': ministryIdController.text,
        },
      );

      if (response.statusCode == 201) {
        FeedingDialog.showSuccessDialog(context);
      } else {
        FeedingDialog.showErrorDialog(context, response.statusCode);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Text(
            'اضافة نظام غذائي جديد',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: Colors.white,
            ),
            textAlign: TextAlign.right,
          )
        ]),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                width: 200.0,
                height: 200.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 2.0,
                      color: const Color.fromARGB(255, 2, 31, 54),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.blueGrey.withOpacity(0.5),
                          spreadRadius: 2.0,
                          blurRadius: 5.0,
                          offset: Offset(0, 3))
                    ]),
                child: ClipOval(
                  child: Image.asset(
                    'assets/feed.jpg',
                    width: 200.0,
                    height: 200.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 2.0,
                        color: const Color.fromARGB(255, 2, 31, 54),
                      ),
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2.0,
                            blurRadius: 5.0,
                            offset: Offset(0, 3))
                      ]),
                  child: Column(children: [
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          'نوع الطعام',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: feedingTypeController,
                      textAlign: TextAlign.right,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the feeding type';
                        }
                        return null;
                      },
                    ),
                  ]))
                  ,
              const SizedBox(
                height: 16.0,
              ),
              Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 2.0,
                        color: const Color.fromARGB(255, 2, 31, 54),
                      ),
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2.0,
                            blurRadius: 5.0,
                            offset: Offset(0, 3))
                      ]),
                  child: Column(children: [
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          'الكمية',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: quantityController,
                      textAlign: TextAlign.right,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the quantity';
                        }
                        return null;
                      },
                    ),
                  ])
                  ),
              const SizedBox(
                height: 16.0,
              ),
              Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24.0),
                      border: Border.all(
                        width: 2.0,
                        color: const Color.fromARGB(255, 2, 31, 54),
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2.0,
                            blurRadius: 5.0,
                            offset: Offset(0, 3))
                      ]),
                  child: Column(children: [
                    const Align(
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
                      controller: dateController,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(),
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
                            builder: (BuildContext context, Widget? child) {
                              return Container(
                                width: 400,
                                height: 400,
                                child: child,
                              );
                            });

                        if (pickedDate != null) {
                          final formattedDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                          setState(() {
                            dateController.text = formattedDate;
                          });
                        }
                      },
                    ),
                  ])),
              const SizedBox(
                height: 16.0,
              ),
              Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 2.0,
                        color: const Color.fromARGB(255, 2, 31, 54),
                      ),
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2.0,
                            blurRadius: 5.0,
                            offset: Offset(0, 3))
                      ]),
                  child: Column(children: [
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          'الشهر',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: monthController,
                      textAlign: TextAlign.right,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the month';
                        }
                        return null;
                      },
                    ),
                  ])),
              const SizedBox(
                height: 16.0,
              ),
              Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 2.0,
                        color: const Color.fromARGB(255, 2, 31, 54),
                      ),
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2.0,
                            blurRadius: 5.0,
                            offset: Offset(0, 3))
                      ]),
                  child: Column(children: [
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          'التعليمات',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: instructionsController,
                      textAlign: TextAlign.right,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the instructions';
                        }
                        return null;
                      },
                    )
                  ])),
              const SizedBox(
                height: 16.0,
              ),
              Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 2.0,
                        color: const Color.fromARGB(255, 2, 31, 54),
                      ),
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2.0,
                            blurRadius: 5.0,
                            offset: Offset(0, 3))
                      ]),
                  child: Column(children: [
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          'وزارة الصحة1',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: ministryIdController,
                      textAlign: TextAlign.right,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the ministry ID';
                        }
                        return null;
                      },
                    )
                  ])),
              const SizedBox(height: 16.0),
              Row(children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: submitForm,
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.lightBlue)),
                    child: const Text(
                      'ارسال',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
              ]),
              const SizedBox(
                height: 16.0,
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FeedingTable()),
                        );
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.lightBlue)),
                      child: const Text(
                        'مشاهدة الجدول',
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

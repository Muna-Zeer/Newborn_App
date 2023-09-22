import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';
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
        final responseData = json.decode(response.body);
        // Handle success response
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Feeding record created successfully'),
              actions: [
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
      } else {
        // Handle error response
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(
                  'Failed to create feeding record: ${response.statusCode}'),
              actions: [
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('اضافة تطام غذائي جديد'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: feedingTypeController,
                decoration: InputDecoration(labelText: 'توع الطعام'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the feeding type';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: quantityController,
                decoration: InputDecoration(labelText: 'الكمية'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the quantity';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: dateController,
                decoration: InputDecoration(
                  labelText: 'التاريخ',
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
                      dateController.text = formattedDate;
                    });
                  }
                },
              ),
              TextFormField(
                controller: monthController,
                decoration: InputDecoration(labelText: 'الشهر'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the month';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: instructionsController,
                decoration: InputDecoration(labelText: 'التعليمات'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the instructions';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: ministryIdController,
                decoration: InputDecoration(labelText: 'وزارة الصحة1'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the ministry ID';
                  }
                  return null;
                },
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: submitForm,
                      child: Text('ارسال'),
                    ),
                  ),
                  SizedBox(width: 4.0), // Add spacing between the buttons
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FeedingTable()),
                        );
                      },
                      child: Text(
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

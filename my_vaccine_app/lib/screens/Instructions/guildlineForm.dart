import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:my_vaccine_app/apiServer.dart';
import 'package:my_vaccine_app/screens/Feeding/feedingTable.dart';
import 'package:my_vaccine_app/screens/Instructions/guildlineTable.dart';

class GuildlineForm extends StatefulWidget {
  @override
  _GuildlineFormState createState() => _GuildlineFormState();
}

class _GuildlineFormState extends State<GuildlineForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController vaccineNameController = TextEditingController();
  TextEditingController sideEffectsController = TextEditingController();
  TextEditingController careInstructionsController = TextEditingController();
  TextEditingController preventionMethodController = TextEditingController();
  TextEditingController ministryIdController = TextEditingController();

  Future<void> submitForm() async {
    if (_formKey.currentState!.validate()) {
      final baseUrl = ApiService.getBaseUrl();

      final url = Uri.parse('$baseUrl/guidelines');
      final response = await http.post(
        url,
        body: {
          'vaccine_name': vaccineNameController.text,
          'side_effects': sideEffectsController.text,
          'care_instructions': careInstructionsController.text,
          'prevention_method': preventionMethodController.text,
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
              content: Text('GuildlineForm record created successfully'),
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
                  'success to create guildlineForm record: ${response.statusCode}'),
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              ' اضافة ارشادات صحية',
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(8.0), // Set padding for all sides
                decoration: BoxDecoration(
                  border: Border.all(), // Add border
                  borderRadius: BorderRadius.circular(8.0), // Set border radius
                ),

                child: TextFormField(
                  controller: vaccineNameController,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    labelText: 'اسم التطعيم',
                    border: InputBorder.none, // Remove default border
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the vaccine name';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextFormField(
                  controller: sideEffectsController,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    labelText: 'الاثار الجانبية',
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the side effects';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextFormField(
                  controller: careInstructionsController,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    labelText: 'التتعليمات الصحية',
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the care instructions';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextFormField(
                  controller: preventionMethodController,
                  decoration: InputDecoration(
                    labelText: 'طريقة الوفاية',
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the prevention method';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextFormField(
                  controller: ministryIdController,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    labelText: 'ووارة الصحة1',
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the ministry ID';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                        onPressed: submitForm,
                        child: Text(
                          'ارسال',
                          textAlign: TextAlign.right,
                        )),
                  ),
                  SizedBox(width: 4.0), // Add spacing between the buttons
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GuildlineTable()),
                        );
                      },
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

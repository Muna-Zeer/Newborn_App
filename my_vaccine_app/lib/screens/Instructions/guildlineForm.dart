import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:my_vaccine_app/apiServer.dart';
import 'package:my_vaccine_app/screens/Instructions/guildlineTable.dart';
import 'package:my_vaccine_app/Alert_Dialog/guildlineAlert.dart';

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

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['status'] == 'error') {
        DialogHelper.showErrorDialog(context,
            'Failed to create guidelineForm record: ${response.statusCode}');
      } else {
        DialogHelper.showSuccessDialog(
          context,
          'GuildlineForm record created successfully',
        );
      }
      vaccineNameController.clear();
      sideEffectsController.clear();
      careInstructionsController.clear();
      preventionMethodController.clear();
      ministryIdController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              Icons.local_hospital,
              size: 40.0,
              color: Colors.white,
            ),
            SizedBox(width: 10.0),
            Text(
              ' اضافة ارشادات صحية',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
                color: Colors.white,
              ),
              textAlign: TextAlign.right,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Image.asset(
                'assets/baby.png',
                width: 300.0,
                height: 200.0,
              ),
              Container(
                padding: EdgeInsets.all(8.0),
                // Set padding for all sides
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
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        ' اسم التطعيم',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  TextFormField(
                    controller: vaccineNameController,
                    textAlign: TextAlign.right,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the vaccine name';
                      }
                      return null;
                    },
                  ),
                ]),
              ),
              SizedBox(height: 16.0),
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
                            offset: Offset(0, 3))
                      ]),
                  child: Column(children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          'الاثار الجانبية',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: sideEffectsController,
                      textAlign: TextAlign.right,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the side effects';
                        }
                        return null;
                      },
                    ),
                  ])),
              SizedBox(height: 16.0),
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
                            offset: Offset(0, 3))
                      ]),
                  child: Column(children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          'التتعليمات الصحية',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: careInstructionsController,
                      textAlign: TextAlign.right,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the care instructions';
                        }
                        return null;
                      },
                    ),
                  ])),
              SizedBox(height: 16.0),
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
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(2, 3),
                      ),
                    ],
                  ),
                  child: Column(children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          'طريقة الوفاية',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: preventionMethodController,
                      textAlign: TextAlign.right,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the prevention method';
                        }
                        return null;
                      },
                    ),
                  ])),
              SizedBox(height: 16.0),
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
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3)),
                      ]),
                  child: Column(children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          'ووارة الصحة1',
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
                    ),
                  ])),
              SizedBox(height: 16.0),
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
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GuildlineTable()),
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

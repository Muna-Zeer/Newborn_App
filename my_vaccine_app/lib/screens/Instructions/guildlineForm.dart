import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:my_vaccine_app/apiServer.dart';
import 'package:my_vaccine_app/screens/Instructions/guildlineTable.dart';
import 'package:my_vaccine_app/Alert_Dialog/guildlineAlert.dart';
import 'package:my_vaccine_app/widget/RtlFormBox.dart';

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
            'للأسف لم يتم اضافة التعليمات الصحية : ${response.statusCode}');
      } else {
        DialogHelper.showSuccessDialog(
          context,
          'لقد تم اضافة الارشادات الصحية بنجاح',
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
        title:const Row(
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
              RtlFormBox(
                label:  ' اسم التطعيم',
                controller: vaccineNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the vaccine name";
                  }
                  return null;
                },
              ),
          const    SizedBox(height: 16.0),
               RtlFormBox(
                label:  'الاثار الجانبية',
                controller: sideEffectsController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the side effects";
                  }
                  return null;
                },
              ),
            const  SizedBox(height: 16.0),
               RtlFormBox(
                label: 'التتعليمات الصحية',
                controller: careInstructionsController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the care instruction";
                  }
                  return null;
                },
              ),
           const   SizedBox(height: 16.0),
               RtlFormBox(
                label: 'طريقةالوفاية',
                controller: preventionMethodController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the prevention method";
                  }
                  return null;
                },
              ),
          const    SizedBox(height: 16.0),
               RtlFormBox(
                label:  'ووارة الصحة1',
                controller: ministryIdController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the ministry Id";
                  }
                  return null;
                },
              ),
            const  SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                        onPressed: submitForm,
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.lightBlue)),
                        child:const Text(
                          'ارسال',
                          textAlign: TextAlign.right,
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                ],
              ),
            const  SizedBox(height: 8.0),
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
                      child: const Text(
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

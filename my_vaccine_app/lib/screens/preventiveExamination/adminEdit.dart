import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:my_vaccine_app/Alert_Dialog/guildlineAlert.dart';
import 'package:my_vaccine_app/apiServer.dart';
import 'package:my_vaccine_app/screens/preventiveExamination/AdminExamType.dart';
import 'package:my_vaccine_app/widget/RtlFormBox.dart';

class AdminEditPrevExam extends StatefulWidget {
  final int examinationId;
  const AdminEditPrevExam({
    Key? key,
    required this.examinationId,
  }) : super(key: key);
  @override
  _PreventiveExaminationAdmin createState() => _PreventiveExaminationAdmin();
}

class _PreventiveExaminationAdmin extends State<AdminEditPrevExam> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _examType = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  void submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final updatedPrevExam = AdminExamType(
            id: widget.examinationId,
            examType: _examType.text,
            description: _descriptionController.text);
        print(updatedPrevExam);

        await updatePrevExam(updatedPrevExam);
      } catch (e) {
        print("Error creating PreventiveExamination: $e");
      }
    }
  }

  Future<void> updatePrevExam(AdminExamType examination) async {
    final baseUrl = ApiService.getBaseUrl();

    final url = Uri.parse('$baseUrl/admin_prevExamination/${examination.id}');
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final body = jsonEncode(examination.toJson());
    print('${body}');
    try {
      final response = await http.put(url, headers: headers, body: body);
      print('Response: ${response.statusCode} - ${response.body}');
      print('response${response.body}');
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final updatedGuideline = AdminExamType.fromJson(responseData['data']);
        _examType.text = examination.examType;
        _descriptionController.text = examination.description;
      }
      DialogHelper.showSuccessDialog(context, 'successfully updated');
      _examType.clear();
      _descriptionController.clear();
    } catch (error) {
      DialogHelper.showErrorDialog(context, 'sorry it\'s wrong');
      print(error);
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
              Text(
                '  تحديث الفحوصات الوقائية',
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color:const Color.fromARGB(255, 7, 26, 48).withOpacity(0.5),
                  spreadRadius: 8,
                  blurRadius: 15,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.asset(
                        'assets/vaccine10.jpg',
                        width: 120.0,
                        height: 100.0,
                      ),
                    RtlFormBox(
                label:    'اسم الفحص الوقائي',
                controller:_examType  ,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the exam type";
                  }
                  return null;
                },
              ),
                   const   SizedBox(height: 16.0),
                       RtlFormBox(
                label:    'المعلومات',
                controller:_descriptionController ,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the description";
                  }
                  return null;
                },
              ),
                    const  SizedBox(height: 24.0),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: submitForm,
                              child: Text(
                                'تحديث',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.lightBlue),
                              ),
                            ),
                          ),
                          SizedBox(width: 4.0),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: submitForm,
                              child: Text(
                                'القائمة',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.lightBlue),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ])),
          ),
        ));
  }
}

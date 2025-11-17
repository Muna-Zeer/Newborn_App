import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:my_vaccine_app/Alert_Dialog/guildlineAlert.dart';
import 'package:my_vaccine_app/apiServer.dart';

class AdminAddPrevExam extends StatefulWidget {
  @override
  _PreventiveExaminationAdmin createState() => _PreventiveExaminationAdmin();
}

class _PreventiveExaminationAdmin extends State<AdminAddPrevExam> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _examType = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  void submitForm() async {
    if (_formKey.currentState!.validate()) {
      final preventiveExamination = {
        'exam_type': _examType.text,
        'description': _descriptionController.text,
      };
      final baseUrl = ApiService.getBaseUrl();

      final url = Uri.parse('$baseUrl/admin_prevExamination');
      final headers = <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      };
      final body = jsonEncode(preventiveExamination);

      try {
        final response = await http.post(url, headers: headers, body: body);
        if (response.statusCode == 201) {
          final responseData = json.decode(response.body);
          DialogHelper.showSuccessDialog(
              context, 'تم إضافة الفحص الوقائي بنجاح');
          _examType.clear();
          _descriptionController.clear();
        }
      } catch (error) {
        DialogHelper.showErrorDialog(context, 'للأسف لم يتم الإضافة');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '  اضافة الفحوصات الوقائية',
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            margin:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 7, 26, 48).withOpacity(0.5),
                  spreadRadius: 8,
                  blurRadius: 15,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Form(
                key: _formKey,
                child: Column(children: [
                  Image.asset(
                    'assets/vaccine10.jpg',
                    width: 120.0,
                    height: 100.0,
                  ),
                  Container(
                      child: Column(children: [
                    const Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          'اسم الفحص الوقائي',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16.0),
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _examType,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter exam type';
                        }
                        return null;
                      },
                    ),
                  ])),
                  const SizedBox(height: 16.0),
                  Container(
                      child: Column(children: [
                    const Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          'المعلومات',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.0),
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter description';
                        }
                        return null;
                      },
                    ),
                  ])),
                  const SizedBox(height: 24.0),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: submitForm,
                          child: Text(
                            'ارسال',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.lightBlue),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4.0),
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
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.lightBlue),
                          ),
                        ),
                      ),
                    ],
                  ),
                ])),
          ),
        ),
      ),
    );
  }
}

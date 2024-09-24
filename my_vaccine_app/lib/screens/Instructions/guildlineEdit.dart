import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:my_vaccine_app/apiServer.dart';
import 'package:my_vaccine_app/screens/Instructions/guildlineClass.dart';
import 'package:my_vaccine_app/screens/Instructions/guildlineTable.dart';

class GuidelineEdit extends StatefulWidget {
  final int GuidelineId;

  const GuidelineEdit({
    Key? key,
    required this.GuidelineId,
  }) : super(key: key);
  @override
  _GuidelineEditState createState() => _GuidelineEditState();
}

class _GuidelineEditState extends State<GuidelineEdit> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController preventionMethodController = TextEditingController();
  TextEditingController careInstructionsController = TextEditingController();
  TextEditingController sideEffectsController = TextEditingController();
  TextEditingController vaccineNameController = TextEditingController();

  void submitForm() {
    if (_formKey.currentState!.validate()) {
      final updatedGuildline = Guideline(
        id: widget.GuidelineId,
        careInstructions: careInstructionsController.text,
        preventionMethod: preventionMethodController.text,
        vaccineName: vaccineNameController.text,
        sideEffects: sideEffectsController.text,
        ministryId: 1,
      );

      updateGuideline(updatedGuildline);
    }
  }

  Future<void> updateGuideline(Guideline guideline) async {
    final baseUrl = ApiService.getBaseUrl();

    final url = Uri.parse('$baseUrl/guidelines/${guideline.id}');
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final body = jsonEncode(guideline.toJson());

    try {
      final response = await http.put(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final updatedGuideline = Guideline.fromJson(responseData['data']);

        preventionMethodController.text =
            updatedGuideline.preventionMethod ?? '';
        sideEffectsController.text = updatedGuideline.sideEffects ?? '';
        vaccineNameController.text = updatedGuideline.vaccineName ?? '';
        careInstructionsController.text =
            updatedGuideline.careInstructions ?? '';

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 0,
                backgroundColor: Colors.transparent,
                content: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: const Color.fromARGB(255, 2, 31, 54),
                          width: 2.0),
                      borderRadius: BorderRadius.circular(8.0)),
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Image.asset(
                        'assets/doneImg.jpg',
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'تم التحديث بنجاح',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            color: Colors.green),
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    TextButton(
                      child: Text(
                        'OK',
                        style: TextStyle(color: Colors.blue),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ]),
                ));
          },
        );
      }
    } catch (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              elevation: 0,
              content: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: const Color.fromARGB(255, 2, 31, 54),
                        width: 2.0,
                      )),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Image.asset(
                          'assets/sadBaby.png',
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'خطا',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: const Color.fromARGB(255, 2, 31, 54),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'لم يتم التحديث',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            color: const Color.fromARGB(255, 2, 31, 54),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      TextButton(
                        child: Text(
                          'OK',
                          style: TextStyle(color: Colors.green),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  )));
        },
      );
    }
    preventionMethodController.clear();
    vaccineNameController.clear();
    sideEffectsController.clear();
    careInstructionsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              ' تحديث الاراشادات الصحية',
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
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          'اسم التطعيم',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: vaccineNameController,
                      textDirection: TextDirection.rtl,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the Vaccine Name';
                        }
                        return null;
                      },
                    ),
                  ])),
              SizedBox(height: 8.0),
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
                    ],
                  ),
                  child: Column(children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          'الاثارالجانبية',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: sideEffectsController,
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the Side Effect';
                        }
                        return null;
                      },
                    ),
                  ])),
              SizedBox(
                height: 8.0,
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
                        blurRadius: 5.0,
                        spreadRadius: 2.0,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            'التعليمات الصحية',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: careInstructionsController,
                        textDirection: TextDirection.rtl,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter the care Instruction';
                          }
                          return null;
                        },
                      ),
                    ],
                  )),
              SizedBox(
                height: 8.0,
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
                        blurRadius: 5.0,
                        spreadRadius: 2.0,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            'طريقةالوفاية',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: preventionMethodController,
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter the prevent Method';
                          }
                          return null;
                        },
                      ),
                    ],
                  )),
              SizedBox(
                height: 16.0,
              ),
              Row(children: [
                Expanded(
                    child: ElevatedButton(
                  onPressed: () {
                    submitForm();
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>((Colors.lightBlue))),
                  child: Text(
                    'تحديث',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ))
              ]),
              Row(children: [
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
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.lightBlue)),
                    child: Text(
                      'مشاهدة الجدول',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ]),
            ],
          ),
        ),
      ),
    );
  }
}

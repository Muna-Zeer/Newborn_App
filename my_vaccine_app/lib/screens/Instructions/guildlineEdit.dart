import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';
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
              title: Text('تم'),
              content: Text('تم التحديث يتجاح.'),
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
      preventionMethodController.clear();
      vaccineNameController.clear();
      sideEffectsController.clear();
      careInstructionsController.clear();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('خطا'),
            content: Text('لم يام التحديث'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              ' تحديث الاراشادات الصحية',
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
              TextFormField(
                controller: preventionMethodController,
                textAlign: TextAlign.right,
                decoration: InputDecoration(labelText: 'طريقةالوفاية'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the prevent Method';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: careInstructionsController,
                textAlign: TextAlign.right,
                decoration: InputDecoration(labelText: 'التعليمات الصحية'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the care Instruction';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: sideEffectsController,
                textAlign: TextAlign.right,
                decoration: InputDecoration(labelText: 'الاثارا الجانبية'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the Side Effect';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: vaccineNameController,
                textAlign: TextAlign.right,
                decoration: InputDecoration(labelText: 'اسم التطعيم'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the Vaccine Name';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  submitForm();
                },
                child: Text(
                  'تحديث',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GuildlineTable()),
                  );
                },
                child: Text(
                  'مشاعدة الجدول',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

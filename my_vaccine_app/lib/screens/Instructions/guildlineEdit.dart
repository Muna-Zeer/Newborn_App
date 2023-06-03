import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';
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
    final url =
        Uri.parse('http://127.0.0.1:8000/api/guidelines/${guideline.id}');
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
              title: Text('Success'),
              content: Text('Guideline updated successfully.'),
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
            title: Text('Error'),
            content: Text('Failed to update guideline.'),
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
        title: Text('Guildline Form'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: preventionMethodController,
                decoration: InputDecoration(labelText: 'prevent Method'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the prevent Method';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: careInstructionsController,
                decoration: InputDecoration(labelText: 'care Instruction'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the care Instruction';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: sideEffectsController,
                decoration: InputDecoration(labelText: 'Side Effect'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the Side Effect';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: vaccineNameController,
                decoration: InputDecoration(labelText: 'Vaccine Name'),
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
                  'Update guildline',
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
                  'View Table',
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

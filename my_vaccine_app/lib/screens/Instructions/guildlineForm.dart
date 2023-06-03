import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';
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
      final url = Uri.parse('http://192.168.105.21:8000/api/guidelines');
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
        title: Text('GuildlineForm Form'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: vaccineNameController,
                decoration: InputDecoration(labelText: 'Vaccine Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the vaccine name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: sideEffectsController,
                decoration: InputDecoration(labelText: 'sideEffects'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the sideEffects';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: careInstructionsController,
                decoration: InputDecoration(
                  labelText: 'care Instructions',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a careInstructions';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: preventionMethodController,
                decoration: InputDecoration(labelText: 'preventionMethod'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the preventionMethod';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: ministryIdController,
                decoration: InputDecoration(labelText: 'Ministry ID'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the ministry ID';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: submitForm,
                child: Text('Submit'),
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

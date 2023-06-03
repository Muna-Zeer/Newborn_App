import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:my_vaccine_app/screens/Feeding/feddingClass.dart';
import 'package:my_vaccine_app/screens/Feeding/feedingTable.dart';

class FeedingEdit extends StatefulWidget {
  final int feedingId;

  const FeedingEdit({
    Key? key,
    required this.feedingId,
  }) : super(key: key);
  @override
  _FeedingEditState createState() => _FeedingEditState();
}

class _FeedingEditState extends State<FeedingEdit> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController feedingTypeController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController monthController = TextEditingController();
  TextEditingController instructionsController = TextEditingController();
  TextEditingController ministryIdController = TextEditingController();

  void submitForm() {
    if (_formKey.currentState!.validate()) {
      final updatedFeeding = Feeding(
        id: widget.feedingId,
        quantity: double.parse(quantityController.text),
        feedingType: feedingTypeController.text,
        instructions: instructionsController.text,
        month: monthController.text,
        date: DateTime.parse(dateController.text), // Convert text to DateTime
        ministryId: int.parse(ministryIdController.text),
      );

      updateFeeding(updatedFeeding);
    }
  }

  Future<void> updateFeeding(Feeding feeding) async {
    final url = Uri.parse('http://127.0.0.1:8000/api/feedings/${feeding.id}');
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final body = jsonEncode(feeding.toJson());

    try {
      final response = await http.put(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final updatedFeeding = Feeding.fromJson(responseData['data']);

        feedingTypeController.text = updatedFeeding.feedingType ?? '';
        quantityController.text = updatedFeeding.quantity?.toString() ?? '';
        monthController.text = updatedFeeding.month ?? '';
        ministryIdController.text = updatedFeeding.ministryId?.toString() ?? '';
        instructionsController.text = updatedFeeding.instructions ?? '';
        dateController.text = updatedFeeding.date?.toString() ?? '';
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Feeding updated successfully.'),
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
      feedingTypeController.clear();
      instructionsController.clear();
      ministryIdController.clear();
      dateController.clear();
      monthController.clear();
      quantityController.clear();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('success update'),
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
        title: Text('Feeding Form'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: feedingTypeController,
                decoration: InputDecoration(labelText: 'Feeding Type'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the feeding type';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: quantityController,
                decoration: InputDecoration(labelText: 'Quantity'),
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
                  labelText: 'Date',
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
                decoration: InputDecoration(labelText: 'Month'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the month';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: instructionsController,
                decoration: InputDecoration(labelText: 'Instructions'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the instructions';
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
              ElevatedButton(
                onPressed: () {
                  submitForm();
                },
                child: Text(
                  'Update Vaccine',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FeedingTable()),
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

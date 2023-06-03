import 'package:flutter/material.dart';
import 'package:my_vaccine_app/screens/vaccine/vaccine.dart';
import 'package:my_vaccine_app/screens/vaccine/vaccineTable.dart';
import 'package:my_vaccine_app/screens/vaccine/vaccine_api.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/gestures.dart';
import 'package:collection/collection.dart';

class EditVaccine extends StatefulWidget {
  final int vaccineId;

  const EditVaccine({
    Key? key,
    required this.vaccineId,
  }) : super(key: key);

  @override
  _EditVaccineState createState() => _EditVaccineState();
}

class _EditVaccineState extends State<EditVaccine> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _dosesController;
  late TextEditingController _placeController;
  late TextEditingController _diseasesController;
  Method? _method;
  late TextEditingController _monthVaccinationsController;

  Vaccine? vaccineData;

  @override
  void initState() {
    super.initState();
    // Fetch vaccine data and populate the form
    _fetchVaccineData();
    _nameController = TextEditingController();
    _dosesController = TextEditingController();
    _placeController = TextEditingController();
    _diseasesController = TextEditingController();
    _monthVaccinationsController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dosesController.dispose();
    _placeController.dispose();
    _diseasesController.dispose();
    _monthVaccinationsController.dispose();
    super.dispose();
  }

  void _fetchVaccineData() async {
    try {
      final vaccine = await fetchVaccine(widget.vaccineId);
      setState(() {
        vaccineData = vaccine;
        _nameController.text = vaccine.name;
        _diseasesController.text = vaccine.diseases;
        _dosesController.text = vaccine.doses.toString();
        _method = vaccine.method;
        _monthVaccinationsController.text = vaccine.monthVaccinations;
        _placeController.text = vaccine.place;
      });
    } catch (e) {
      print('Error fetching vaccine data: $e');
    }
  }

  void submitForm() {
    if (_formKey.currentState!.validate()) {
      final updatedVaccine = Vaccine(
        id: widget.vaccineId,
        name: _nameController.text,
        doses: int.parse(_dosesController.text),
        place: _placeController.text,
        diseases: _diseasesController.text,
        method: _method,
        monthVaccinations: _monthVaccinationsController.text,
      );

      updateVaccine(updatedVaccine);
    }
  }

  Future<void> updateVaccine(Vaccine vaccine) async {
    final url = Uri.parse('http://127.0.0.1:8000/api/vaccine/${vaccine.id}');
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final body = jsonEncode(vaccine.toJson());

    try {
      final response = await http.put(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final updatedVaccine = Vaccine.fromJson(responseData['data']);
        _dosesController.clear();
        _nameController.clear();
        _diseasesController.clear();
        _monthVaccinationsController.clear();
        _placeController.clear();

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Vaccine updated successfully.'),
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
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content:
                Text('An error occurred while updating the vaccine: $error'),
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
        title: Text('Vaccine Form'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _dosesController,
                  decoration: InputDecoration(labelText: 'Doses'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the number of doses';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _placeController,
                  decoration: InputDecoration(labelText: 'Place'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the place';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _diseasesController,
                  decoration: InputDecoration(labelText: 'Diseases'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the disease';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<Method>(
                  decoration: InputDecoration(
                    labelText: 'Method',
                    hintText: 'Select an option',
                  ),
                  value: _method,
                  onChanged: (newValue) {
                    setState(() {
                      _method = newValue;
                    });
                  },
                  items: Method.values.map((value) {
                    return DropdownMenuItem<Method>(
                      value: value,
                      child: Text(value.toString().split('.').last),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a method';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _monthVaccinationsController,
                  decoration: InputDecoration(labelText: 'Month'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the month';
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
                      MaterialPageRoute(builder: (context) => VaccinePage()),
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
      ),
    );
  }
}

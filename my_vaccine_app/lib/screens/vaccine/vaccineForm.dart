import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_vaccine_app/apiServer.dart';
import 'package:my_vaccine_app/screens/vaccine/vaccine.dart';
import 'package:my_vaccine_app/screens/vaccine/vaccineTable.dart';
import 'package:my_vaccine_app/screens/vaccine/vaccine_api.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/gestures.dart';
import 'package:collection/collection.dart';

class VaccineForm extends StatefulWidget {
  @override
  _VaccineFormState createState() => _VaccineFormState();
}

class _VaccineFormState extends State<VaccineForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _dosesController;
  late TextEditingController _placeController;
  late TextEditingController _diseasesController;
  Method? _method;
  late TextEditingController _monthVaccinationsController;
  late TextEditingController _newbornIdController;
  late TextEditingController _ministryIdController;
  TextEditingController _vaccinationDateController =
      TextEditingController(text: 'yyyy,MM,dd');

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _dosesController = TextEditingController();
    _placeController = TextEditingController();
    _diseasesController = TextEditingController();
    _monthVaccinationsController = TextEditingController();
    _newbornIdController = TextEditingController();
    _ministryIdController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dosesController.dispose();
    _placeController.dispose();
    _diseasesController.dispose();
    _monthVaccinationsController.dispose();
    _newbornIdController.dispose();
    _ministryIdController.dispose();

    super.dispose();
  }

  void submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final vaccine = Vaccine(
        name: _nameController.text,
        doses: int.tryParse(_dosesController.text) ?? 0,

        place: _placeController.text,
        diseases: _diseasesController.text,
        method: _method, // Use the selected value from DropdownButtonFormField
        monthVaccinations: _monthVaccinationsController.text,
        newbornId: int.tryParse(_newbornIdController.text) ?? 0,
        ministryId: int.tryParse(_ministryIdController.text) ?? 0, id: 0,
      );
      print(' vaccine => $vaccine');
      storeVaccine(vaccine);
      print('$context,$vaccine');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Vaccine created successfully.'),
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

  Future<void> createVaccine(Vaccine vaccine, BuildContext context) async {
          final baseUrl = ApiService.getBaseUrl();

    final url = Uri.parse('$baseUrl/storeVaccine');
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final body = jsonEncode(vaccine.toJson());

    try {
      final response = await http.post(url, headers: headers, body: body);
      print(' response => $response');
      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        final createdVaccine = Vaccine.fromJson(responseData['data']);
        // Handle the created vaccine object as needed
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Vaccine created successfully.'),
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
        _diseasesController.clear();
        _diseasesController.clear();
        _ministryIdController.clear();
        _monthVaccinationsController.clear();
        _nameController.clear();
        _placeController.clear();
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Failure'),
              content: Text('Failed to create vaccine.'),
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
      print('error $error');
      _diseasesController.clear();
      _dosesController.clear();
      _newbornIdController.clear();
      _ministryIdController.clear();
      _monthVaccinationsController.clear();
      _nameController.clear();
      _placeController.clear();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('success insert data '),
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
                      }),
                  TextFormField(
                      controller: _monthVaccinationsController,
                      decoration: InputDecoration(labelText: 'Month Vaccine'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the disease';
                        }
                        return null;
                      }),
                  DropdownButtonFormField<Method>(
                    decoration: InputDecoration(
                        labelText: 'method', hintText: 'select an option'),
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
                  ),
                  ElevatedButton(
                    onPressed: () {
                      submitForm(context); // Call the submitForm function
                    },
                    child: Text(
                      'Vaccine',
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
                ]),
          ),
        ),
      ),
    );
  }
}

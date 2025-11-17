import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:my_vaccine_app/Alert_Dialog/guildlineAlert.dart';
import 'package:my_vaccine_app/Alert_Dialog/measurementAlert.dart';
import 'package:my_vaccine_app/apiServer.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_vaccine_app/screens/measurment/measurementView.dart';
import 'package:my_vaccine_app/widget/RtlFormBox.dart';

class MeasurementEdit extends StatefulWidget {
  final int measurementId;
  const MeasurementEdit({
    Key? key,
    required this.measurementId,
  }) : super(key: key);

  @override
  _MeasurementEditState createState() => _MeasurementEditState();
}

class _MeasurementEditState extends State<MeasurementEdit> {
  final _formKey = GlobalKey<FormState>();

  final nurseNameController = TextEditingController();
  final remarksController = TextEditingController();
  final tonicsController = TextEditingController();
  final headCircumstancesController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final ageController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchMeasurementData();
  }

  @override
  void dispose() {
    // Dispose all controllers
    nurseNameController.dispose();
    remarksController.dispose();
    tonicsController.dispose();
    headCircumstancesController.dispose();
    heightController.dispose();
    weightController.dispose();
    ageController.dispose();
    dateController.dispose();
    super.dispose();
  }

  Future<void> _fetchMeasurementData() async {
    final baseUrl = ApiService.getBaseUrl();
    final url = Uri.parse('$baseUrl/measurement/${widget.measurementId}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final measurementData = jsonDecode(response.body);
        setState(() {
          nurseNameController.text = measurementData['nurse_name'] ?? "";
          remarksController.text = measurementData['remarks'] ?? "";
          tonicsController.text = measurementData['tonics'] ?? "";
          headCircumstancesController.text =
              measurementData['head_circumstances'] ?? "";
          heightController.text = measurementData['height'] ?? "";
          weightController.text = measurementData['weight'] ?? "";
          ageController.text = measurementData['age'] ?? "";
          dateController.text = measurementData['date'] ??
              "DateFormat('yyyy-MM-dd').format(DateTime.now())";
        });
      }
    } catch (e) {
      DialogHelper.showErrorDialog(
          context, "Invalid Fetching measurement Data");
    }
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final measurementData = {
        'nurse_name': nurseNameController.text.trim(),
        'tonic': tonicsController.text.trim(),
        'remarks': remarksController.text.trim(),
        'head_circumstances': headCircumstancesController.text.trim(),
        'height': heightController.text.trim(),
        'weight': weightController.text.trim(),
        'age': ageController.text.trim(),
        "date": DateTime.parse(dateController.text).toIso8601String(),
      };

      final baseUrl = ApiService.getBaseUrl();
      final url = Uri.parse('$baseUrl/measurement/${widget.measurementId}');
      final headers = {'Content-Type': 'application/json; charset=UTF-8'};
      final body = jsonEncode(measurementData);
      try {
        final response = await http.put(url, headers: headers, body: body);
        if (response.statusCode == 200) {
          MeasurementDialog.showSuccessDialog(context);
        } else {
          MeasurementDialog.showErrorDialog(context, response.statusCode);
        }
      } catch (error) {
        DialogHelper.showErrorDialog(context, "Invalid editing field");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          title:const Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Text('تحديث الفحوصات الوقائية'),
          ])),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
              const    Text("Editing Measurent Values",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 3, 14, 63),
                          fontSize: 24.0)),
            const      SizedBox(
                    height: 16.0,
                  ),
                  RtlFormBox(
                label:    'اسم الممرضة',
                controller: nurseNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the nurse name";
                  }
                  return null;
                },
              ),
              const    SizedBox(
                    height: 16.0,
                  ),
                RtlFormBox(
                label: 'الفيتامينات',
                controller: tonicsController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the name of tonics";
                  }
                  return null;
                },
              ),
                const  SizedBox(
                    height: 16.0,
                  ),
                   RtlFormBox(
                label:   'ملاحظات',
                controller: remarksController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the remarks";
                  }
                  return null;
                },
              ),
               const   SizedBox(
                    height: 16.0,
                  ),
                  RtlFormBox(
                label:    'محيط الرأس',
                controller: headCircumstancesController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the head circumstances";
                  }
                  return null;
                },
              ),
                const   SizedBox(
                    height: 16.0,
                  ),
                 RtlFormBox(
                label:      'الطول',
                controller: heightController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the height";
                  }
                  return null;
                },
              ),
              const    SizedBox(
                    height: 16.0,
                  ),
                RtlFormBox(
                label:     'الوزن',
                controller: weightController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the wight";
                  }
                  return null;
                },
              ),
             const     SizedBox(
                    height: 16.0,
                  ),
                RtlFormBox(
                label:     'العمر',
                controller: ageController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the age";
                  }
                  return null;
                },
              ),
              const    SizedBox(
                    height: 16.0,
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    width: MediaQuery.of(context).size.width *
                        0.9, 
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2.0,
                        color: const Color.fromARGB(255, 2, 31, 54),
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      children: [
                   const     Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              'التاريخ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: dateController,
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
                              lastDate: DateTime.now(),
                            );
                            if (pickedDate != null) {
                              final formattedDate =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                              setState(() {
                                dateController.text = formattedDate;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  Column(children: [
                    ElevatedButton(
                      onPressed: () {
                        _submitForm(); 
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.lightBlue),
                      ),
                      child:const Text(
                        'تحديث القائمة',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MeasurementTable()),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.lightBlue),
                      ),
                      child:const Text(
                        'الاطلاع على الجدول',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ]),
             const     SizedBox(
                    height: 16.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

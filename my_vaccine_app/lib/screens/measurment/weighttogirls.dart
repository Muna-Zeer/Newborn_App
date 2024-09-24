import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:my_vaccine_app/Alert_Dialog/guildlineAlert.dart';
import 'package:my_vaccine_app/apiServer.dart';

class MeasurementWeightGirls extends StatefulWidget {
  const MeasurementWeightGirls({Key? key}) : super(key: key);

  @override
  _MeasurementFormState createState() => _MeasurementFormState();
}

class _MeasurementFormState extends State<MeasurementWeightGirls> {
  final _formKey = GlobalKey<FormState>();
  int currentIndex = 0;
  // List to store controller for each role

  List<Map<String, TextEditingController>> rowsController = [];
  List<DataRow> rows = [];
//state for selected image
  String selectedImage = 'assets/weight-girl.png';
  @override
  void initState() {
    super.initState();
    rows = [];
    _initializeRows();
  }

  void _onImageSelect(String imagePath) {
    setState(() {
      selectedImage = imagePath;
    });
  }

  @override
  void dispose() {
    //Dispose all controller to avoid memory leak
    for (var row in rowsController) {
      for (var row in rowsController) {
        row['nurseNameController']?.dispose();
        row['remarksController']?.dispose();
        row['tonicsController']?.dispose();
        row['headCircumferenceController']?.dispose();
        row['heightController']?.dispose();
        row['weightController']?.dispose();
        row['ageController']?.dispose();
        row['dateController']?.dispose();
      }
      super.dispose();
    }
  }

  void _initializeRows() {
    const int numberOfRows = 10;
    List<DataRow> initializeRow = [];
    List<Map<String, TextEditingController>> initialControllers = [];

    for (int i = 0; i < numberOfRows; i++) {
      Map<String, TextEditingController> newRowControllers = {
        'nurseNameController': TextEditingController(),
        'remarksController': TextEditingController(),
        'tonicsController': TextEditingController(),
        'headCircumferenceController': TextEditingController(),
        'heightController': TextEditingController(),
        'weightController': TextEditingController(),
        'ageController': TextEditingController(),
        'dateController': TextEditingController(
            text: DateFormat('yyyy-MM-dd').format(DateTime.now())),
      };
      initialControllers.add(newRowControllers);
      initializeRow.add(DataRow(cells: [
        DataCell(TextFormField(
            controller: newRowControllers['nurseNameController'])),
        DataCell(TextFormField(
          controller: newRowControllers['remarksController'],
        )),
        DataCell(TextFormField(
          controller: newRowControllers['tonicsController'],
        )),
        DataCell(TextFormField(
          controller: newRowControllers['headCircumferenceController'],
        )),
        DataCell(TextFormField(
          controller: newRowControllers['heightController'],
        )),
        DataCell(TextFormField(
          controller: newRowControllers['weightController'],
        )),
        DataCell(TextFormField(
          controller: newRowControllers['ageController'],
        )),
        DataCell(TextFormField(
          controller: newRowControllers['dateController'],
          textAlign: TextAlign.right,
          onTap: () async {
            final DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (pickedDate != null) {
              setState(() {
                newRowControllers['dateController']?.text =
                    DateFormat("yyyy-MM-dd").format(pickedDate);
              });
            }
          },
        )),
      ]));
    }
    setState(() {
      rows = initializeRow;
      rowsController = initialControllers;
    });
  }

  void submitForm() async {
    if (currentIndex < 0 || currentIndex >= rowsController.length) {
      DialogHelper.showErrorDialog(context, "No row selected");
      return;
    }
    final controllers = rowsController[currentIndex];
    final measurement = {
      'height': controllers['heightController']?.text.trim() ?? '',
      'weight': controllers['weightController']?.text.trim() ?? '',
      'head_circumference':
          controllers['headCircumferenceController']?.text.trim() ?? '',
      'date': controllers['dateController']?.text.trim() ?? '',
      'nurse_name': controllers['nurseNameController']?.text.trim() ?? '',
      'remarks': controllers['remarksController']?.text.trim() ?? '',
      'age': controllers['ageController']?.text.trim() ?? '',
      'tonics': controllers['tonicsController']?.text.trim() ?? '',
    };
    print("Measurement data being sent: $measurement");

    final baseUrl = ApiService.getBaseUrl();
    final url = Uri.parse('$baseUrl/measurement');
    final headers = {'Content-Type': 'application/json; charset=UTF-8'};
    final body = jsonEncode(measurement);

    try {
      final response = await http.post(url, headers: headers, body: body);
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 201) {
        DialogHelper.showSuccessDialog(
            context, 'Measurement added successfully');
      } else if (response.statusCode == 422) {
        final errors = json.decode(response.body)['errors'];
        String errorMessage = 'Validation Errors:\n';
        errors.forEach((field, messages) {
          errorMessage += '$field: ${messages.join(', ')}\n';
        });
        DialogHelper.showErrorDialog(context, errorMessage);
      } else {
        DialogHelper.showErrorDialog(context, 'Error: Could not submit form.');
      }
    } catch (error) {
      DialogHelper.showErrorDialog(context, 'Server communication error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 228, 71, 197),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('Measurement Of Girls '),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(padding: EdgeInsets.zero, children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Color.fromARGB(255, 228, 71, 197)),
            child: Text(
              'Measurement Options',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            title: Text('Weight for Age - Girls'),
            onTap: () {
              _onImageSelect('assets/weight-girl.png');
              Navigator.pop(context);
            },
          ),
          ListTile(
              title: Text('Length/height-for-age Gils'),
              onTap: () {
                _onImageSelect('assets/length-height-girls.png');
                Navigator.pop(context);
              }),
          ListTile(
              title: Text('Weight for Length Girls'),
              onTap: () {
                _onImageSelect('assets/weight-for-length-girl.png');
                Navigator.pop(context);
              }),
          ListTile(
              title: Text('Weight for Height Girls'),
              onTap: () {
                _onImageSelect('assets/weight-for-height-girl.png');
                Navigator.pop(context);
              }),
          ListTile(
              title: Text('Head circumference-for-age-girls'),
              onTap: () {
                _onImageSelect('assets/growth-chartspdf-head-girl.webp');
                Navigator.pop(context);
              }),
        ]),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Image.asset(
                selectedImage,
                width: 1000,
                height: 700,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Color.fromARGB(255, 10, 0, 12), width: 3.0),
                ),
                child: DataTable(
                  columns: [
                    DataColumn(label: Text(' اسم وتوقيع الممرضة')),
                    DataColumn(label: Text('ملاحظات\n Remarks')),
                    DataColumn(label: Text('المقويات \n فيتامين أ+د \n وحديد')),
                    DataColumn(label: Text(' محيط الرأس \n HC\n (cm)')),
                    DataColumn(label: Text('الطول\n Ht/Lt \n (cm)')),
                    DataColumn(label: Text('الوزن\n Wt \n (kg)')),
                    DataColumn(label: Text(' العمر \n Age\n (yr/mo)')),
                    DataColumn(label: Text('التاريخ\n Date')),
                  ],
                  rows: rows,
                ),
              ),
              SizedBox(height: 24.0),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center the button horizontally
                children: [
                  ElevatedButton(
                    onPressed: submitForm,
                    child: Text(
                      'ارسال',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 218, 160, 206)),
                      minimumSize: MaterialStateProperty.all<Size>(
                          Size(150, 40)), // Set a custom button size
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.0),
            ],
          ),
        ),
      ),
    );
  }
}

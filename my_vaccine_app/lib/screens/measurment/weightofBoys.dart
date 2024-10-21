import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:my_vaccine_app/Alert_Dialog/guildlineAlert.dart';
import 'package:my_vaccine_app/apiServer.dart';

class MeasurementWeight extends StatefulWidget {
  const MeasurementWeight({Key? key}) : super(key: key);

  @override
  _MeasurementFormState createState() => _MeasurementFormState();
}

class _MeasurementFormState extends State<MeasurementWeight> {
  // Index to track the currently active row
  int currentIndex = 0;

  // List to store controllers for each row
  List<Map<String, TextEditingController>> rowsControllers = [];
  List<DataRow> rows = [];
  String selectedImage = 'assets/weight-for-age-boys.webp';
  void _onImageSelect(String imagePath) {
    setState(() {
      selectedImage = imagePath;
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeRows();
  }

  @override
  void dispose() {
    // Dispose all controllers for each row to avoid memory leaks
    for (var row in rowsControllers) {
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

  void _initializeRows() {
    // Number of rows you want to initialize
    const int numberOfRows = 10;

    List<DataRow> initialRows = [];
    List<Map<String, TextEditingController>> initialControllers = [];

    for (int i = 0; i < numberOfRows; i++) {
      // Create new controllers for this specific row
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

      initialRows.add(
        DataRow(
          cells: [
            DataCell(TextFormField(
                controller: newRowControllers['nurseNameController'])),
            DataCell(TextFormField(
                controller: newRowControllers['remarksController'])),
            DataCell(TextFormField(
                controller: newRowControllers['tonicsController'])),
            DataCell(TextFormField(
                controller: newRowControllers['headCircumferenceController'])),
            DataCell(TextFormField(
                controller: newRowControllers['heightController'])),
            DataCell(TextFormField(
                controller: newRowControllers['weightController'])),
            DataCell(
                TextFormField(controller: newRowControllers['ageController'])),
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
          ],
        ),
      );
    }

    setState(() {
      rows = initialRows;
      rowsControllers = initialControllers;
    });
  }

  void submitForm() async {
    print("Inside submit function");

    if (currentIndex < 0 || currentIndex >= rowsControllers.length) {
      DialogHelper.showErrorDialog(context, 'No row selected.');
      return;
    }

    // Collect data from the currently active row
    final controllers = rowsControllers[currentIndex];
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
        // Handle validation errors
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
        backgroundColor: Colors.lightBlue,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('Weight-age-for-boys'),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(padding: EdgeInsets.zero, children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.lightBlue),
            child: Text(
              'Measurement Options',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            title: Text('Weight for Age - Boys'),
            onTap: () {
              _onImageSelect('assets/weight-for-age-boys.webp');
              Navigator.pop(context);
            },
          ),
          ListTile(
              title: Text('Height Age for boys'),
              onTap: () {
                _onImageSelect('assets/height-for-age-boys.webp');
                Navigator.pop(context);
              }),
          ListTile(
              title: Text('Weight for Length Boys'),
              onTap: () {
                _onImageSelect('assets/weight-for-lengthboys.png');
                Navigator.pop(context);
              }),
          ListTile(
              title: Text('Weight for Height Boys'),
              onTap: () {
                _onImageSelect('assets/weight-for-height-boys.png');
                Navigator.pop(context);
              }),
          ListTile(
              title: Text('Head circumference-for-age-boys'),
              onTap: () {
                _onImageSelect('assets/growth-chartspdf-boy.webp');
                Navigator.pop(context);
              }),
        ]),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              selectedImage,
              width: 1000,
              height: 700,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.lightBlue, width: 3.0),
              ),
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('اسم وتوقيع الممرضة')),
                  DataColumn(label: Text('ملاحظات\n Remarks')),
                  DataColumn(label: Text('المقويات \n فيتامين أ+د \n وحديد')),
                  DataColumn(label: Text('محيط الرأس \n HC\n (cm)')),
                  DataColumn(label: Text('الطول\n Ht/Lt \n (cm)')),
                  DataColumn(label: Text('الوزن\n Wt \n (kg)')),
                  DataColumn(label: Text('العمر \n Age\n (yr/mo)')),
                  DataColumn(label: Text('التاريخ\n Date')),
                ],
                rows: rows,
              ),
            ),
            SizedBox(height: 24.0),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,
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
                        Color.fromARGB(255, 8, 40, 111)),
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
    );
  }
}

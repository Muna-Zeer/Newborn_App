
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:my_vaccine_app/apiServer.dart';

class NewbornVaccinePage extends StatefulWidget {
  @override
  _VaccinePageState createState() => _VaccinePageState();
}

class _VaccinePageState extends State<NewbornVaccinePage> {
  List<Map<String, dynamic>> newbornRecords = [];
  List<String> vaccineNames = [];
  String? selectedVaccine;
  List<Map<String, dynamic>> filteredRecords = [];

  @override
  void initState() {
    super.initState();
    fetchNewbornRecords();
    fetchVaccineNames();
  }

  Future<void> fetchNewbornRecords({String? selectedVaccine}) async {
    final baseUrl = ApiService.getBaseUrl();

    final response = await http.get(Uri.parse('$baseUrl/compare-newborn-age'));

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);
        final matchingNewborns = data['matchingNewborns'];

        setState(() {
          newbornRecords = List<Map<String, dynamic>>.from(matchingNewborns);
          filterRecords(
              selectedVaccine); // Filter records based on the selected vaccine
        });
      } catch (e) {
        print('Error parsing JSON: $e');
      }
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }

  Future<void> fetchVaccineNames() async {
    final baseUrl = ApiService.getBaseUrl();

    final response = await http.get(Uri.parse('$baseUrl/allVaccines'));

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);
        final jsonData = data['data'];

        setState(() {
          vaccineNames = jsonData.isNotEmpty
              ? List<String>.from(
                  jsonData.map((vaccine) => vaccine['name'].toString()))
              : [];
          selectedVaccine = vaccineNames.isNotEmpty ? vaccineNames.first : null;
        });
      } catch (e) {
        print('Error parsing JSON: $e');
      }
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }

  void filterRecords(String? selectedVaccine) {
    if (selectedVaccine == null) {
      filteredRecords = List<Map<String, dynamic>>.from(newbornRecords);
    } else {
      filteredRecords = newbornRecords
          .where((record) =>
              record['vaccineName'] ==
              selectedVaccine) // Modify the field name to match the actual field containing the vaccine name
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const  Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'قائمة التطعيمات',
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding:const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
           const   SizedBox(height: 16.0),
           const   Text(
                'معلومات الطفل:',
                style: TextStyle(fontSize: 18),
              ),
              DropdownButton<String>(
                value: selectedVaccine,
                hint:const Text('اختر اسم التطعيم'),
                items: vaccineNames.map((String vaccineName) {
                  return DropdownMenuItem<String>(
                    value: vaccineName,
                    child: Text(vaccineName),
                  );
                }).toList(),
                onChanged: (String? selectedVaccine) {
                  setState(() {
                    this.selectedVaccine = selectedVaccine;
                    filterRecords(selectedVaccine);
                  });
                },
              ),
              Expanded(
                child: Container(
                  width: 600.0,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: ListView.builder(
                      itemCount: filteredRecords.length,
                      itemBuilder: (BuildContext context, int index) {
                        final record = filteredRecords[index];
                        final newbornName =
                            '${record['firstName']} ${record['lastName']}';
                        final motherName =
                            'Mother: ${record['mother_id']}'; // Replace 'mother_id' with the actual field name for mother's name
                        return Card(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  newbornName,
                                  style:const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                             const   SizedBox(height: 8.0),
                                Text(
                                  'رقم الهوية : ${record['identity_number']}',
                                  textAlign: TextAlign.right,
                                ),
                                Text(
                                    'تاريخ الميلاد: ${record['date_of_birth']}',
                                    textAlign: TextAlign.right),
                                Text('الجنس: ${record['gender']}',
                                    textAlign: TextAlign.right),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
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

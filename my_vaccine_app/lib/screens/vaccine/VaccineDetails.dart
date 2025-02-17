import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:my_vaccine_app/apiServer.dart';

class VaccineTable extends StatefulWidget {
  final String identityNumber;
  final String newbornName;

  VaccineTable({required this.identityNumber, required this.newbornName});

  @override
  _VaccineTableState createState() => _VaccineTableState();
}

class _VaccineTableState extends State<VaccineTable> {
  List<Map<String, dynamic>> vaccineData = [];
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final baseUrl = ApiService.getBaseUrl();
    final response = await http.get(
      Uri.parse('$baseUrl/vaccines/${widget.identityNumber}'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        final dynamic responseData = data['data'];
        if (responseData is List) {
          setState(() {
            vaccineData = responseData
                .map((newborn) => newborn['vaccines'] as List)
                .expand((vaccines) => vaccines)
                .map((vaccine) {
              return {
                'id': (vaccine['id'] as int?) ?? 1,
                'name': (vaccine['name'] as String?) ?? '',
                'month': (vaccine['month_vaccinations'] as String?) ?? '',
                'taken': (vaccine['taken'] as bool?) ?? false,
                'vaccinationDate':
                    (vaccine['vaccination_date'] as String?) ?? '',
                'doctorName': (vaccine['doctor_name'] as String?) ?? '',
                'isSent': false,
              };
            }).toList();
          });
        }
      } else {
        throw Exception('Failed to fetch vaccination table data');
      }
    } else {
      throw Exception('Failed to fetch data: ${response.statusCode}');
    }
  }

  Future<void> insertNewbornVaccine(
      Map<String, dynamic> vaccine, int index) async {
    final baseUrl = ApiService.getBaseUrl();
    final response = await http.post(
      Uri.parse('$baseUrl/newborn-vaccines'),
      body: json.encode({
        'identity_number': widget.identityNumber,
        'vaccination_table_id': vaccine['id'] ?? 1,
        'doctor_name': vaccine['doctorName'],
        'vaccination_date': vaccine['vaccinationDate'],
        'taken': vaccine['taken'],
        'vaccineName':vaccine['name'],
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      setState(() {
        vaccineData[index]['isSent'] = true;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Newborn vaccine record inserted successfully'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(
                'Failed to insert newborn vaccine record: ${response.statusCode}'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
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
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'جدول التطعيمات',
            ),
          ],
        ),
        backgroundColor: Colors.lightBlue,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              Text('اسم الطفل: ${widget.newbornName}',
                  textAlign: TextAlign.right),
              Text('رقم الهوية: ${widget.identityNumber}',
                  textAlign: TextAlign.right),
              const SizedBox(height: 16),
              DataTable(
                border: TableBorder.all(),
                columns: const [
                  DataColumn(
                      label: Text('اسم التطعيم', textAlign: TextAlign.right)),
                  DataColumn(
                      label: Text('تاريخ التطعيم', textAlign: TextAlign.right)),
                  DataColumn(
                      label: Text('اسم الدكتور', textAlign: TextAlign.right)),
                  DataColumn(
                      label: Text('اخذ التطعيم', textAlign: TextAlign.right)),
                  DataColumn(
                      label: Text('الوظيفة', textAlign: TextAlign.right)),
                ],
                rows: vaccineData.map((vaccine) {
                  final index = vaccineData.indexOf(vaccine);
                  final bool isSent = vaccine['isSent'] ?? false;
                  return DataRow(
                    cells: [
                      DataCell(
                        TextFormField(
                          onChanged: isSent
                              ? null
                              : (value) {
                                  setState(() {
                                    vaccineData[index]['name'] = value;
                                  });
                                },
                          initialValue: vaccine['name'],
                          textAlign: TextAlign.right,
                          decoration: InputDecoration(enabled: !isSent),
                        ),
                      ),
                      DataCell(
                        InkWell(
                          onTap: isSent
                              ? null
                              : () async {
                                  final selectedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100),
                                  );

                                  if (selectedDate != null) {
                                    setState(() {
                                      final formattedDate =
                                          '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
                                      vaccineData[index]['vaccinationDate'] =
                                          formattedDate;
                                    });
                                  }
                                },
                          child: TextFormField(
                            enabled: false,
                            controller: TextEditingController(
                                text: vaccine['vaccinationDate'] ?? ''),
                            decoration: const InputDecoration(
                                suffixIcon: Icon(Icons.calendar_today)),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                      DataCell(
                        TextFormField(
                          onChanged: isSent
                              ? null
                              : (value) {
                                  setState(() {
                                    vaccineData[index]['doctorName'] = value;
                                  });
                                },
                          initialValue: vaccine['doctorName'] ?? '',
                          textAlign: TextAlign.right,
                          decoration: InputDecoration(enabled: !isSent),
                        ),
                      ),
                      DataCell(
                        Checkbox(
                          value: vaccine['taken'] ?? false,
                          onChanged: isSent
                              ? null
                              : (value) {
                                  setState(() {
                                    vaccineData[index]['taken'] = value;
                                  });
                                },
                        ),
                      ),
                      DataCell(
                        ElevatedButton(
                          onPressed: vaccine['isSent'] == true
                              ? null 
                              : () async {
                                  await insertNewbornVaccine(
                                      vaccineData[index], index);
                                },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              vaccine['isSent'] == true
                                  ? Colors.grey
                                  : Colors.lightBlue,
                            ),
                          ),
                          child: Text(
                            vaccine['isSent'] == true ? 'تم الإرسال' : 'تم',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

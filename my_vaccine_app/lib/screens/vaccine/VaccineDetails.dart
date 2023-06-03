import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/vaccines/${widget.identityNumber}'),
    );
    print('response$response');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('response$response');
      if (data['status'] == 'success') {
        final dynamic responseData = data['data'];
        print('data$data');
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
              };
            }).toList();
          });
        }
      } else {
        print('Failed to fetch vaccination table data');
      }
    } else {
      print('Failed to fetch data: ${response.statusCode}');
    }
  }

  Future<void> updateVaccine(
      String id, Map<String, dynamic> updatedVaccine) async {
    final response = await http.put(
      Uri.parse('http://127.0.0.1:8000/api/vaccines/$id'),
      body: json.encode(updatedVaccine),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      print('Vaccine record updated successfully');
    } else {
      print('Failed to update vaccine record: ${response.statusCode}');
    }
  }

  Future<void> insertNewbornVaccine(Map<String, dynamic> vaccine) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/newborn-vaccines'),
      body: json.encode({
        'identity_number': widget.identityNumber,
        'vaccination_table_id': vaccine['id'] ?? 1,
        'doctor_name': vaccine['doctorName'],
        'vaccination_date': vaccine['vaccinationDate'],
        'taken': vaccine['taken'],
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
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
        title: Text('Vaccine Table'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Newborn Name: ${widget.newbornName}'),
            Text('Identity Number: ${widget.identityNumber}'),
            SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Vaccine Name')),
                  DataColumn(label: Text('Month')),
                  DataColumn(label: Text('Vaccine Date')),
                  DataColumn(label: Text('Doctor Name')),
                  DataColumn(label: Text('Vaccine Taken')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: vaccineData.map((vaccine) {
                  final index = vaccineData.indexOf(vaccine);
                  return DataRow(
                    cells: [
                      DataCell(
                        TextFormField(
                          onChanged: (value) {
                            setState(() {
                              vaccineData[index]['name'] = value;
                            });
                          },
                          initialValue: vaccine['name'],
                        ),
                      ),
                      DataCell(Text(vaccine['month'])),
                      DataCell(
                        InkWell(
                          onTap: () async {
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
                                text: vaccine['vaccinationDate']),
                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        TextFormField(
                          onChanged: (value) {
                            setState(() {
                              vaccineData[index]['doctorName'] = value;
                            });
                          },
                          initialValue: vaccine['doctorName'],
                        ),
                      ),
                      DataCell(
                        Checkbox(
                          value: vaccine['taken'],
                          onChanged: (value) {
                            setState(() {
                              vaccineData[index]['taken'] = value;
                            });
                          },
                        ),
                      ),
                      DataCell(
                        ElevatedButton(
                          onPressed: () {
                            insertNewbornVaccine(vaccineData[index]);
                          },
                          child: Text('Done'),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

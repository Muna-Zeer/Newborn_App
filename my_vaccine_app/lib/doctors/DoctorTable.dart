import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:my_vaccine_app/doctors/EditDoctorPage.dart';
import 'package:my_vaccine_app/doctors/ViewDoctorPage.dart';
import 'dart:convert';

import 'package:my_vaccine_app/doctors/doctor.dart';
import 'package:my_vaccine_app/doctors/doctor_api.dart';

class DoctorPage extends StatefulWidget {
  @override
  _DoctorTableState createState() => _DoctorTableState();
}

class _DoctorTableState extends State<DoctorPage> {
  List<Doctor> doctors = [];
  List<Doctor> filteredDoctors = [];
  String searchText = '';
  int _currentPage = 1;
  int _itemsPerPage = 4;
  bool sort = true;
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    getDoctors();
  }

  Future<void> getDoctors() async {
    final response = await http
        .get(Uri.parse('$baseUrl/doctorsTables'))
        .catchError((error) => print(error));
    print('$response');
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      print('$data');
      setState(() {
        doctors = data.map((json) => Doctor.fromJson(json)).toList();
        filteredDoctors = doctors;
        print('$doctors');
      });
    } else {
      throw Exception('Failed to load doctors');
    }
  }

  List<Doctor> getCurrentPageItems() {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    return filteredDoctors.sublist(startIndex,
        endIndex > filteredDoctors.length ? filteredDoctors.length : endIndex);
  }

  void goToPreviousPage() {
    setState(() {
      if (_currentPage > 1) {
        _currentPage--;
      }
    });
  }

  void goToNextPage() {
    setState(() {
      if (_currentPage < getTotalPages()) {
        _currentPage++;
      }
    });
  }

  int getTotalPages() {
    return (filteredDoctors.length / _itemsPerPage).ceil();
  }

  void onsortColum(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
      if (columnIndex == 0) {
        if (ascending) {
          filteredDoctors.sort((a, b) => a.name!.compareTo(b.name!));
        } else {
          filteredDoctors.sort((a, b) => b.name!.compareTo(a.name!));
        }
      }
    });
  }

  void performAction(BuildContext context, Doctor doctor, String action) async {
    // Navigate to another page based on the action
    if (action == 'view') {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ViewDoctorPage(doctor: doctor),
        ),
      );
    } else if (action == 'edit') {
      // Show edit confirmation dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Edit Doctor'),
            content: Text('Are you sure you want to edit this doctor record?'),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: Text('Edit'),
                onPressed: () async {
                  bool success = await editDoctor(doctor.id, context);
                  Navigator.of(context).pop(success);
                },
              ),
            ],
          );
        },
      ).then((value) {
        if (value != null && value == true) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EditDoctorPage(doctorId: doctor.id),
          ));
        }
      });
    } else if (action == 'delete') {
      // Show confirmation dialog before deleting
      bool confirmDelete = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm Delete'),
            content:
                Text('Are you sure you want to delete this doctor record?'),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: Text('Delete'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        },
      );
      if (confirmDelete) {
        try {
          await deleteDoctor(doctor.id, context);

          // Remove the deleted record from the list
          setState(() {
            doctors.remove(doctor);
          });

          // Show alert dialog after deletion
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Success'),
                content: Text('The doctor record has been deleted.'),
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
        } catch (e) {
          print('Error deleting doctor record: $e');
        }
      }
    }
  }

  Widget build(BuildContext context) {
    Text(
      'Doctor List',
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
    return Material(
      child: Padding(
        padding: EdgeInsets.all(45), // Adjust the margin values as needed
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue),
          ),
          child: Column(children: [
            SizedBox(height: 10),
            Flexible(
              child: ListView(shrinkWrap: true, children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      DataColumn(
                        label: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.blue),
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                'ID',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              if (_sortColumnIndex == 1)
                                Icon(
                                  _sortAscending
                                      ? Icons.arrow_upward
                                      : Icons.arrow_downward,
                                  size: 16,
                                ),
                            ],
                          ),
                        ),
                        numeric: true,
                        onSort: (columnIndex, ascending) =>
                            onsortColum(columnIndex, ascending),
                        tooltip: 'Sort by ID',
                      ),
                      DataColumn(
                        label: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.blue),
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Name',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              if (_sortColumnIndex == 0)
                                Icon(
                                  _sortAscending
                                      ? Icons.arrow_upward
                                      : Icons.arrow_downward,
                                  size: 16,
                                ),
                            ],
                          ),
                        ),
                        onSort: (columnIndex, ascending) =>
                            onsortColum(columnIndex, ascending),
                        tooltip: 'Sort by name',
                      ),
                      DataColumn(
                        label: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.blue),
                            ),
                          ),
                          child: Text(
                            'Specialization',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        onSort: (columnIndex, ascending) {
                          setState(() {
                            _sortColumnIndex = columnIndex;
                            _sortAscending = ascending;
                            filteredDoctors.sort((a, b) {
                              if (a.specialization == b.specialization) {
                                return 0;
                              } else if (ascending) {
                                return a.specialization
                                    .compareTo(b.specialization);
                              } else {
                                return b.specialization
                                    .compareTo(a.specialization);
                              }
                            });
                          });
                        },
                      ),

                      DataColumn(
                        label: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.blue),
                            ),
                          ),
                          child: Text(
                            'City',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        onSort: (columnIndex, ascending) {
                          setState(() {
                            _sortColumnIndex = columnIndex;
                            _sortAscending = ascending;
                            if (columnIndex == 3) {
                              filteredDoctors
                                  .sort((a, b) => a.city.compareTo(b.city));
                            } else if (columnIndex == 2) {
                              filteredDoctors.sort(
                                  (a, b) => a.country.compareTo(b.country));
                            }
                            if (!_sortAscending) {
                              filteredDoctors =
                                  filteredDoctors.reversed.toList();
                            }
                          });
                        },
                      ),
                      DataColumn(
                        label: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.blue),
                            ),
                          ),
                          child: Text(
                            'Email',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        onSort: (columnIndex, ascending) {
                          setState(() {
                            _sortColumnIndex = columnIndex;
                            _sortAscending = ascending;
                            filteredDoctors.sort((a, b) {
                              if (a.email == b.email) {
                                return 0;
                              } else if (ascending) {
                                return a.email.compareTo(b.email);
                              } else {
                                return b.email.compareTo(a.email);
                              }
                            });
                          });
                        },
                      ),
                      DataColumn(
                        label: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.blue),
                            ),
                          ),
                          child: Text(
                            'Phone',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.blue),
                            ),
                          ),
                          child: Text(
                            'Salary',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ), // adjust the width as needed
                      DataColumn(
                        label: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.blue),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Text(
                              'Action',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                    rows: [
                      DataRow(cells: [
                        DataCell(
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'Search',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              isCollapsed: true,
                            ),
                            onChanged: (value) {
                              setState(() {
                                searchText = value;
                                if (searchText.isEmpty) {
                                  filteredDoctors = doctors;
                                } else {
                                  filteredDoctors = doctors
                                      .where((doctor) =>
                                          doctor.name.toLowerCase().contains(
                                              searchText.toLowerCase()) ||
                                          doctor.specialization
                                              .toLowerCase()
                                              .contains(
                                                  searchText.toLowerCase()) ||
                                          doctor.country.toLowerCase().contains(
                                              searchText.toLowerCase()) ||
                                          doctor.city.toLowerCase().contains(
                                              searchText.toLowerCase()) ||
                                          doctor.email.toLowerCase().contains(
                                              searchText.toLowerCase()) ||
                                          doctor.phone.toLowerCase().contains(
                                              searchText.toLowerCase()) ||
                                          doctor.salary.toLowerCase().contains(
                                              searchText.toLowerCase()))
                                      .toList();
                                }
                                _currentPage =
                                    1; // Reset to first page when search changes
                              });
                            },
                          ),
                        ),
                        DataCell(Text('')),
                        DataCell(Text('')),
                        DataCell(Text('')),
                        DataCell(Text('')),
                        DataCell(Text('')),
                        DataCell(Text('')),
                        DataCell(Text('')),
                        // DataCell(Text('')),
                      ]),
                      for (var doctor in getCurrentPageItems())
                        DataRow(cells: [
                          DataCell(Text(doctor.id.toString())),
                          DataCell(Text(doctor.name)),
                          DataCell(Text(doctor.specialization)),
                          // DataCell(Text(doctor.country)),
                          DataCell(Text(doctor.city)),
                          DataCell(Text(doctor.email)),
                          DataCell(Text(doctor.phone)),
                          DataCell(Text(doctor.salary)),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    // Perform the edit action
                                    performAction(context, doctor, 'edit');
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.visibility),
                                  onPressed: () {
                                    // Perform the view action
                                    performAction(context, doctor, 'view');
                                  },
                                ),
                                IconButton(
                                  onPressed: () async {
                                    performAction(context, doctor, 'delete');
                                  },
                                  icon: Icon(Icons.delete),
                                ),
                              ],
                            ),
                          ),
                        ]),
                      DataRow(cells: [
                        DataCell(Text('')),
                        DataCell(Text('')),
                        DataCell(Text('')),
                        DataCell(Text('')),
                        DataCell(Text('')),
                        DataCell(Text('')),
                        DataCell(Text('')),
                        DataCell(Text('')),
                        // DataCell(Text('')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('')),
                        DataCell(Text('')),
                        DataCell(Text('')),
                        DataCell(Text('')),
                        DataCell(Text('')),
                        DataCell(Text('')),
                        // DataCell(Text('')),
                        DataCell(
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Page $_currentPage of ${getTotalPages()}'),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: goToPreviousPage,
                                    icon: Icon(Icons.arrow_back),
                                  ),
                                  IconButton(
                                    onPressed: goToNextPage,
                                    icon: Icon(Icons.arrow_forward),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        DataCell(Text('')),
                      ]),
                    ],
                  ),
                ),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}

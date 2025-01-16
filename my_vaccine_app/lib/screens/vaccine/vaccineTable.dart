import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:my_vaccine_app/apiServer.dart';
import 'package:my_vaccine_app/screens/vaccine/editVaccine.dart';

import 'package:my_vaccine_app/screens/vaccine/vaccine.dart';
import 'package:my_vaccine_app/screens/vaccine/vaccineForm.dart';
import 'package:my_vaccine_app/screens/vaccine/vaccine_api.dart';

class VaccinePage extends StatefulWidget {
  @override
  _VaccineTableState createState() => _VaccineTableState();
}

class _VaccineTableState extends State<VaccinePage> {
  List<Vaccine> vaccines = [];
  List<Vaccine> filteredVaccines = [];
  String searchText = '';
  int _currentPage = 1;
  int _itemsPerPage = 4;
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    getVaccines();
  }

  Future<void> getVaccines() async {
          final baseUrl = ApiService.getBaseUrl();

    final response = await http
        .get(Uri.parse('$baseUrl/allVaccines'))
        .catchError((error) => print(error));

    print('$response');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      print('$data');

      setState(() {
        vaccines = data.map((json) => Vaccine.fromJson(json)).toList();
        filteredVaccines = vaccines;
        print('$vaccines');
      });
    } else {
      throw Exception('Failed to load vaccines');
    }
  }

  List<Vaccine> getCurrentPageItems() {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage > filteredVaccines.length
        ? filteredVaccines.length
        : startIndex + _itemsPerPage;
    return filteredVaccines.sublist(startIndex, endIndex);
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
    return (filteredVaccines.length / _itemsPerPage).ceil();
  }

  void onSortColumn(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;

      filteredVaccines.sort((a, b) {
        final Comparable? aValue = getColumnValue(a, columnIndex);
        final Comparable? bValue = getColumnValue(b, columnIndex);

        if (aValue == null && bValue == null) {
          return 0;
        } else if (aValue == null) {
          return 1;
        } else if (bValue == null) {
          return -1;
        }

        return aValue.compareTo(bValue);
      });

      if (!_sortAscending) {
        filteredVaccines = filteredVaccines.reversed.toList();
      }
    });
  }

  Comparable? getColumnValue(Vaccine vaccine, int columnIndex) {
    switch (columnIndex) {
      case 0:
        return vaccine.id;
      case 1:
        return vaccine.name;
      case 2:
        return vaccine.doses;
      case 3:
        return vaccine.place;
      case 4:
        return vaccine.diseases;

      default:
        return null;
    }
  }

  void performAction(
      BuildContext context, Vaccine vaccine, String action) async {
    // Navigate to another page based on the action
    if (action == 'insert') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => VaccineForm()),
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
                  bool success = await editVaccine(vaccine.id, context);
                  Navigator.of(context).pop(success);
                },
              ),
            ],
          );
        },
      ).then((value) {
        if (value != null && value == true) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EditVaccine(vaccineId: vaccine.id),
          ));
        }
      });
    } else if (action == 'delete') {
      bool confirmDelete = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm Delete'),
            content:
                Text('Are you sure you want to delete this vaccine record?'),
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
          await deleteVaccine(vaccine.id, context);

          // Remove the deleted record from the list
          setState(() {
            vaccines.remove(vaccine);
          });

          // Show alert dialog after deletion
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Success'),
                content: Text('The vaccine record has been deleted.'),
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
          print('Error deleting vaccine record: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          border: Border.all(color: Color.fromARGB(255, 103, 120, 134)),
        ),
        child: Column(children: [
          Text(
            'Vaccine List',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
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
                      numeric: true,
                      onSort: (columnIndex, ascending) =>
                          onSortColumn(columnIndex, ascending),
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
                      onSort: (columnIndex, ascending) =>
                          onSortColumn(columnIndex, ascending),
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
                          'Doses',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      onSort: (columnIndex, ascending) =>
                          onSortColumn(columnIndex, ascending),
                      tooltip: 'Sort by doses',
                    ),
                    DataColumn(
                      label: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.blue),
                          ),
                        ),
                        child: Text(
                          'Place',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      onSort: (columnIndex, ascending) =>
                          onSortColumn(columnIndex, ascending),
                      tooltip: 'Sort by place',
                    ),
                    DataColumn(
                      label: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.blue),
                          ),
                        ),
                        child: Text(
                          'Diseases',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      onSort: (columnIndex, ascending) =>
                          onSortColumn(columnIndex, ascending),
                      tooltip: 'Sort by diseases',
                    ),
                    // DataColumn(
                    //   label: Container(
                    //     decoration: BoxDecoration(
                    //       border: Border(
                    //         bottom: BorderSide(color: Colors.blue),
                    //       ),
                    //     ),
                    //     child: Text(
                    //       'Method',
                    //       style: TextStyle(fontWeight: FontWeight.bold),
                    //     ),
                    //   ),
                    //   onSort: (columnIndex, ascending) =>
                    //       onSortColumn(columnIndex, ascending),
                    //   tooltip: 'Sort by method',
                    // ),
                    DataColumn(
                      label: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.blue),
                          ),
                        ),
                        child: Text(
                          'MonthOfVaccine',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      onSort: (columnIndex, ascending) =>
                          onSortColumn(columnIndex, ascending),
                      tooltip: 'Sort by month of vaccine',
                    ),
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
                              vertical: 10,
                              horizontal: 20,
                            ),
                            isCollapsed: true,
                          ),
                          onChanged: (value) {
                            setState(() {
                              searchText = value;
                              if (searchText.isEmpty) {
                                filteredVaccines = vaccines;
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
                      // DataCell(Text('')),
                    ]),
                    for (var vaccine in getCurrentPageItems())
                      DataRow(cells: [
                        DataCell(Text(vaccine.id?.toString() ?? '')),
                        DataCell(Text(vaccine.name)),
                        DataCell(Text(vaccine.doses?.toString() ?? '')),
                        DataCell(Text(vaccine.place)),
                        DataCell(Text(vaccine.diseases)),
                        // DataCell(Text(
                        //     vaccine.method?.toString().split('.').last ?? '')),
                        DataCell(Text(vaccine.monthVaccinations)),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  // Perform the edit action
                                  performAction(context, vaccine, 'edit');
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  // Perform the view action
                                  performAction(context, vaccine, 'insert');
                                },
                              ),
                              IconButton(
                                onPressed: () async {
                                  performAction(context, vaccine, 'delete');
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
                    ]),
                  ],
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:newborn_app/constant/models/Newborn.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'dart:convert';

import 'package:newborn_app/methods/Newborn_api.dart';

class NewbornPage extends StatefulWidget {
  @override
  _NewbornTableState createState() => _NewbornTableState();
}

class _NewbornTableState extends State<NewbornPage> {
  List<Newborn> newborns = [];
  List<Newborn> filteredNewborns = [];
  String searchText = '';
  int _currentPage = 1;
  int _itemsPerPage = 4;
  bool sort = true;
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    getNewborns();
  }

  Future<void> getNewborns() async {
    final response = await http
        .get(Uri.parse('http://127.0.0.1:8000/api/newborn'))
        .catchError((error) => print(error));
    print('$response');
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      print('$data');
      setState(() {
        newborns = data.map((json) => Newborn.fromJson(json)).toList();
        filteredNewborns = newborns;
        print('$newborns');
      });
    } else {
      throw Exception('Failed to load newborns');
    }
  }

  List<Newborn> getCurrentPageItems() {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    return filteredNewborns.sublist(
        startIndex,
        endIndex > filteredNewborns.length
            ? filteredNewborns.length
            : endIndex);
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
    return (filteredNewborns.length / _itemsPerPage).ceil();
  }

  void onsortColum(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
      if (columnIndex == 0) {
        if (ascending) {
          filteredNewborns.sort((a, b) => a.firstName!.compareTo(b.firstName!));
        } else {
          filteredNewborns.sort((a, b) => b.firstName!.compareTo(a.firstName!));
        }
      }
    });
  }

  void performAction(
      BuildContext context, Newborn newborn, String action) async {
    // Navigate to another page based on the action
    if (action == 'view') {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => DoctorPage(doctorId: doctor.id),
      //   ),
      // );
    } else if (action == 'edit') {
      // Show edit confirmation dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Edit Newborn'),
            content: Text('Are you sure you want to edit this newborn record?'),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              // TextButton(
              //   child: Text('Edit'),
              //   onPressed: () async {
              //     bool success = await editNewborn(newborn.id as int, context);
              //     Navigator.of(context).pop(success);
              //   },
              // ),
            ],
          );
        },
      ).then((value) {
        if (value != null && value == true) {
          // Navigator.of(context).push(MaterialPageRoute(
          //   builder: (context) => EditNewbornPage(newbornId: newborn.id as int),
          // ));
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
                Text('Are you sure you want to delete this newborn record?'),
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
          // await deleteNewborn(newborn.id as int, context);

          // Remove the deleted record from the list
          // setState(() {
          //   newborns.remove(newborn);
          // });

          // Show alert dialog after deletion
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Success'),
                content: Text('The Newborn record has been deleted.'),
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
          print('Error deleting Newborn record: $e');
        }
      }
    }
  }

  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
        ),
        child: Column(children: [
          Text(
            'Newborn List',
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
                          'firstName',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      onSort: (columnIndex, ascending) {
                        setState(() {
                          _sortColumnIndex = columnIndex;
                          _sortAscending = ascending;
                          filteredNewborns.sort((a, b) {
                            if (a.firstName == b.firstName) {
                              return 0;
                            } else if (ascending) {
                              return a.firstName.compareTo(b.firstName);
                            } else {
                              return b.firstName.compareTo(a.firstName);
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
                          'lastName',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      onSort: (columnIndex, ascending) {
                        setState(() {
                          _sortColumnIndex = columnIndex;
                          _sortAscending = ascending;
                          if (columnIndex == 2) {
                            filteredNewborns.sort(
                                (a, b) => a.lastName.compareTo(b.lastName));
                          } else if (columnIndex == 3) {
                            filteredNewborns.sort(
                                (a, b) => a.lastName.compareTo(b.lastName));
                          }
                          if (!_sortAscending) {
                            filteredNewborns =
                                filteredNewborns.reversed.toList();
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
                          'dateOfBirth',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      onSort: (columnIndex, ascending) {
                        setState(() {
                          _sortColumnIndex = columnIndex;
                          _sortAscending = ascending;
                          if (columnIndex == 3) {
                            filteredNewborns.sort((a, b) =>
                                a.dateOfBirth.compareTo(b.dateOfBirth));
                          } else if (columnIndex == 2) {
                            filteredNewborns.sort((a, b) =>
                                a.dateOfBirth.compareTo(b.dateOfBirth));
                          }
                          if (!_sortAscending) {
                            filteredNewborns =
                                filteredNewborns.reversed.toList();
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
                          'identityNumber',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      onSort: (columnIndex, ascending) {
                        setState(() {
                          _sortColumnIndex = columnIndex;
                          _sortAscending = ascending;
                          if (columnIndex == 3) {
                            filteredNewborns.sort((a, b) =>
                                a.identityNumber.compareTo(b.identityNumber));
                          } else if (columnIndex == 2) {
                            filteredNewborns.sort((a, b) =>
                                a.identityNumber.compareTo(b.identityNumber));
                          }
                          if (!_sortAscending) {
                            filteredNewborns =
                                filteredNewborns.reversed.toList();
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
                          'mother name',
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
                          'doctor name',
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
                                filteredNewborns = newborns;
                              } else {
                                filteredNewborns = newborns
                                    .where((newborn) =>
                                        newborn.firstName.toLowerCase().contains(
                                            searchText.toLowerCase()) ||
                                        newborn.lastName.toLowerCase().contains(
                                            searchText.toLowerCase()) ||
                                        newborn.dateOfBirth
                                            .toString()
                                            .toLowerCase()
                                            .contains(
                                                searchText.toLowerCase()) ||
                                        newborn.deliveryMethod
                                            .toString()
                                            .toLowerCase()
                                            .contains(
                                                searchText.toLowerCase()) ||
                                        newborn.motherName
                                            .toLowerCase()
                                            .contains(
                                                searchText.toLowerCase()) ||
                                        newborn.identityNumber
                                            .toLowerCase()
                                            .contains(
                                                searchText.toLowerCase()) ||
                                        newborn.doctorName
                                            .toLowerCase()
                                            .contains(searchText.toLowerCase()))
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
                      DataCell(Text('')),
                    ]),
                    for (var newborn in getCurrentPageItems())
                      DataRow(cells: [
                        DataCell(Text(newborn.id.toString())),
                        DataCell(Text(newborn.firstName)),
                        DataCell(Text(newborn.lastName)),
                        DataCell(Text(newborn.identityNumber)),
                        DataCell(Text(newborn.motherName)),
                        DataCell(Text(newborn.doctorName)),
                        DataCell(Text(newborn.dateOfBirth.toString())),
                        DataCell(Text(newborn.deliveryMethod.toString())),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  // Perform the edit action
                                  performAction(context, newborn, 'edit');
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.visibility),
                                onPressed: () {
                                  // Perform the view action
                                  performAction(context, newborn, 'view');
                                },
                              ),
                              IconButton(
                                onPressed: () async {
                                  performAction(context, newborn, 'delete');
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
                      DataCell(Text('')),
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
    );
  }
}

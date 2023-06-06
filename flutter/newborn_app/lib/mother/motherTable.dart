import 'package:flutter/material.dart';
import 'package:newborn_app/constant/models/mother.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:newborn_app/methods/mother_api.dart';
import 'package:newborn_app/widgets/motherExaminationForm.dart';
import 'package:newborn_app/widgets/postnatalExamination.dart';

class MotherTablePage extends StatefulWidget {
  @override
  _MotherTableState createState() => _MotherTableState();
}

class _MotherTableState extends State<MotherTablePage> {
  List<Mother> mothers = [];
  List<Mother> filteredMothers = [];
  String searchText = '';
  int _currentPage = 1;
  int _itemsPerPage = 4;
  bool sort = true;
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    getMothers();
  }

  Future<void> getMothers() async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:8000/api/getColumnMother'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final List<dynamic> data = responseData['data'];
      List<Mother> mothers =
          data.map((json) => Mother.fromJsonTable(json)).toList();
      setState(() {
        this.mothers = mothers;
        this.filteredMothers = mothers;
      });
    } else {
      throw Exception('Failed to load mothers');
    }
  }

  List<Mother> getCurrentPageItems() {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    return filteredMothers.sublist(startIndex,
        endIndex > filteredMothers.length ? filteredMothers.length : endIndex);
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
    return (filteredMothers.length / _itemsPerPage).ceil();
  }

  void onsortColum(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
      if (columnIndex == 0) {
        if (ascending) {
          filteredMothers.sort((a, b) => a.firstName!.compareTo(b.firstName!));
        } else {
          filteredMothers.sort((a, b) => b.firstName!.compareTo(a.firstName!));
        }
      }
    });
  }

  void performAction(BuildContext context, Mother mother, String action) async {
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
            title: Text('Edit Mother'),
            content: Text('Are you sure you want to edit this mother record?'),
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
              //     bool success = await editMother(mother.id as int, context);
              //     Navigator.of(context).pop(success);
              //   },
              // ),
            ],
          );
        },
      ).then((value) {
        if (value != null && value == true) {
          // Navigator.of(context).push(MaterialPageRoute(
          //   builder: (context) => EditMotherPage(motherId: mother.id as int),
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
                Text('Are you sure you want to delete this mother record?'),
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
          // await deleteMother(mother.id as int, context);

          // Remove the deleted record from the list
          setState(() {
            mothers.remove(mother);
          });

          // Show alert dialog after deletion
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Success'),
                content: Text('The mother record has been deleted.'),
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
          print('Error deleting mother record: $e');
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
            'Mother List',
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
                              'Frst Name',
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
                          ' Last Name',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      onSort: (columnIndex, ascending) {
                        setState(() {
                          _sortColumnIndex = columnIndex;
                          _sortAscending = ascending;
                          filteredMothers.sort((a, b) {
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
                          'address',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      onSort: (columnIndex, ascending) {
                        setState(() {
                          _sortColumnIndex = columnIndex;
                          _sortAscending = ascending;
                          if (columnIndex == 2) {
                            filteredMothers
                                .sort((a, b) => a.address.compareTo(b.address));
                          } else if (columnIndex == 3) {
                            filteredMothers
                                .sort((a, b) => a.address.compareTo(b.address));
                          }
                          if (!_sortAscending) {
                            filteredMothers = filteredMothers.reversed.toList();
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
                          'age',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      onSort: (columnIndex, ascending) {
                        setState(() {
                          _sortColumnIndex = columnIndex;
                          _sortAscending = ascending;
                          if (columnIndex == 3) {
                            filteredMothers
                                .sort((a, b) => a.age.compareTo(b.age));
                          } else if (columnIndex == 2) {
                            filteredMothers
                                .sort((a, b) => a.age.compareTo(b.age));
                          }
                          if (!_sortAscending) {
                            filteredMothers = filteredMothers.reversed.toList();
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
                          filteredMothers.sort((a, b) {
                            if (a.email == b.email) {
                              return 0;
                            } else if (ascending) {
                              return a.dateOfBirth.compareTo(b.dateOfBirth);
                            } else {
                              return b.dateOfBirth.compareTo(a.dateOfBirth);
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
                          'husbandName',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    // adjust the width as needed
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
                            'Examinations',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
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
                                filteredMothers = mothers;
                              } else {
                                filteredMothers = mothers
                                    .where((mother) =>
                                        mother.firstName.toLowerCase().contains(
                                            searchText.toLowerCase()) ||
                                        mother.address.toLowerCase().contains(
                                            searchText.toLowerCase()) ||
                                        mother.age
                                            .toString()
                                            .toLowerCase()
                                            .contains(
                                                searchText.toLowerCase()) ||
                                        mother.dateOfBirth
                                            .toString()
                                            .toLowerCase()
                                            .contains(
                                                searchText.toLowerCase()) ||
                                        mother.phoneNumber
                                            .toLowerCase()
                                            .contains(
                                                searchText.toLowerCase()) ||
                                        mother.husbandName
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
                      DataCell(Text('')),
                    ]),
                    for (var mother in getCurrentPageItems())
                      DataRow(cells: [
                        DataCell(Text(mother.id.toString())),
                        DataCell(Text(mother.firstName)),
                        DataCell(Text(mother.lastName)),
                        DataCell(Text(mother.address)),
                        DataCell(Text(mother.age.toString())),
                        DataCell(Text(mother.dateOfBirth.toString())),
                        DataCell(Text(mother.phoneNumber)),
                        DataCell(Text(mother.husbandName)),
                        DataCell(
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  // Navigate to postnatal examination page
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          MotherPostnatalExaminationForm(
                                              motherId: mother.id),
                                    ),
                                  );
                                },
                                child: Text('Postnatal Examination'),
                              ),
                              SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () {
                                  // Navigate to mother examination page
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          MotherExaminationForm(
                                              motherId: mother.id),
                                    ),
                                  );
                                },
                                child: Text('Mother Examination'),
                              ),
                            ],
                          ),
                        ),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  // Perform the edit action
                                  performAction(context, mother, 'edit');
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.visibility),
                                onPressed: () {
                                  // Perform the view action
                                  performAction(context, mother, 'view');
                                },
                              ),
                              IconButton(
                                onPressed: () async {
                                  performAction(context, mother, 'delete');
                                },
                                icon: Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ),
                        // DataCell(Text('')),
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
                      DataCell(Text('')),
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

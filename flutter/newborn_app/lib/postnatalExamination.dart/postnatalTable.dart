import 'package:flutter/material.dart';
import 'package:newborn_app/constant/models/postnatalExaminations.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'dart:convert';

import 'package:newborn_app/methods/postnatalExamination_api.dart';
import 'package:newborn_app/postnatalExamination.dart/edit.dart';
import 'package:newborn_app/postnatalExamination.dart/view.dart';

class PostnatalExaminationPage extends StatefulWidget {
  @override
  _PostnatalExaminationTableState createState() =>
      _PostnatalExaminationTableState();
}

class _PostnatalExaminationTableState extends State<PostnatalExaminationPage> {
  List<PostnatalExaminations> postnatalExaminations = [];
  List<PostnatalExaminations> filteredPostnatalExamination = [];
  String searchText = '';
  int _currentPage = 1;
  int _itemsPerPage = 4;
  bool sort = true;
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    getPostnatalExamination();
  }

  Future<void> getPostnatalExamination() async {
    final response = await http
        .get(Uri.parse('http://127.0.0.1:8000/api/postnatalExamination'))
        .catchError((error) => print(error));
    print('$response');
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      print('$data');
      setState(() {
        postnatalExaminations =
            data.map((json) => PostnatalExaminations.fromJson(json)).toList();
        filteredPostnatalExamination = postnatalExaminations;
        print('$postnatalExaminations');
      });
    } else {
      throw Exception('Failed to load postnatalExamination');
    }
  }

  List<PostnatalExaminations> getCurrentPageItems() {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    return filteredPostnatalExamination.sublist(
        startIndex,
        endIndex > filteredPostnatalExamination.length
            ? filteredPostnatalExamination.length
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
    return (filteredPostnatalExamination.length / _itemsPerPage).ceil();
  }

  void onsortColum(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
      if (columnIndex == 0) {
        if (ascending) {
          filteredPostnatalExamination
              .sort((a, b) => a.nurseName!.compareTo(b.nurseName!));
        } else {
          filteredPostnatalExamination
              .sort((a, b) => b.doctorName!.compareTo(a.doctorName!));
        }
      }
    });
  }

  void performAction(BuildContext context,
      PostnatalExaminations postnatalExamination, String action) async {
    // Navigate to another page based on the action
    if (action == 'view') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PostnatalExaminationView(
            mother: postnatalExamination,
          ),
        ),
      );
    } else if (action == 'edit') {
      // Show edit confirmation dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Edit PostnatalExamination'),
            content: Text(
                'Are you sure you want to edit this postnatal Examination record?'),
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
                  bool success =
                      await editPostnatal(postnatalExamination.id, context);
                  Navigator.of(context).pop(success);
                },
              ),
            ],
          );
        },
      ).then((value) {
        if (value != null && value == true) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                EditPostnatalExamination(motherId: postnatalExamination.id),
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
            content: Text(
                'Are you sure you want to delete this postnatal examination record?'),
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
          await deletePostnatalExamination(postnatalExamination.id, context);

          // Remove the deleted record from the list
          setState(() {
            postnatalExaminations.remove(postnatalExamination);
          });

          // Show alert dialog after deletion
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Success'),
                content:
                    Text('The postnatal examination record has been deleted.'),
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
          print('Error deleting postnatal examination record: $e');
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
            'Postnatal Examination List',
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
                              'mother_name',
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
                          'temp',
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
                          'lochiaColor',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      onSort: (columnIndex, ascending) {
                        setState(() {
                          _sortColumnIndex = columnIndex;
                          _sortAscending = ascending;
                          if (columnIndex == 2) {
                            filteredPostnatalExamination.sort(
                                (a, b) => a.doctorName.compareTo(b.doctorName));
                          } else if (columnIndex == 3) {
                            filteredPostnatalExamination.sort(
                                (a, b) => a.doctorName.compareTo(b.doctorName));
                          }
                          if (!_sortAscending) {
                            filteredPostnatalExamination =
                                filteredPostnatalExamination.reversed.toList();
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
                          'pulse',
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
                          'hb',
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
                          'familyPlanningCounseling',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    // DataColumn(
                    //   label: Container(
                    //     decoration: BoxDecoration(
                    //       border: Border(
                    //         bottom: BorderSide(color: Colors.blue),
                    //       ),
                    //     ),
                    //     child: Text(
                    //       'Salary',
                    //       style: TextStyle(fontWeight: FontWeight.bold),
                    //     ),
                    //   ),
                    // ), // adjust the width as needed
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
                                filteredPostnatalExamination =
                                    postnatalExaminations;
                              } else {
                                filteredPostnatalExamination =
                                    postnatalExaminations
                                        .where((postnatalExamination) =>
                                            postnatalExamination
                                                .doctorName
                                                .toLowerCase()
                                                .contains(searchText
                                                    .toLowerCase()) ||
                                            postnatalExamination
                                                .doctorName
                                                .toLowerCase()
                                                .contains(
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
                    ]),
                    for (var postnatalExamination in getCurrentPageItems())
                      DataRow(cells: [
                        DataCell(Text(postnatalExamination.id.toString())),
                        DataCell(
                            Text(postnatalExamination.incision.toString())),
                        DataCell(Text(
                            postnatalExamination.familyPlanningCounseling)),
                        DataCell(
                            Text(postnatalExamination.lochiaColor.toString())),
                        DataCell(Text(postnatalExamination.bp)),
                        DataCell(Text(postnatalExamination.temp)),
                        DataCell(Text(postnatalExamination.pulse)),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  // Perform the edit action
                                  performAction(
                                      context, postnatalExamination, 'edit');
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.visibility),
                                onPressed: () {
                                  // Perform the view action
                                  performAction(
                                      context, postnatalExamination, 'view');
                                },
                              ),
                              IconButton(
                                onPressed: () async {
                                  performAction(
                                      context, postnatalExamination, 'delete');
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
                    ]),
                    DataRow(cells: [
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

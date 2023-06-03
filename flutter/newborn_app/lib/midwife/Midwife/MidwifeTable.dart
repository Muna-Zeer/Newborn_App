import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:newborn_app/constant/models/midwifem.dart';
import 'dart:convert';

import 'dart:convert';

import 'package:newborn_app/methods/Midwife_api.dart';
import 'package:newborn_app/midwife/Midwife/EditMidwifePage.dart';
import 'package:newborn_app/midwife/Midwife/ViewMidwifePage.dart';

class MidwifeTablePage extends StatefulWidget {
  @override
  _MidwifeTableState createState() => _MidwifeTableState();
}

class _MidwifeTableState extends State<MidwifeTablePage> {
  List<Midwife> midwives = [];
  List<Midwife> filteredMidwives = [];
  String searchText = '';
  int _currentPage = 1;
  int _itemsPerPage = 4;
  bool sort = true;
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    getMidwives();
  }

  Future<void> getMidwives() async {
    final response = await http
        .get(Uri.parse('http://127.0.0.1:8000/api/midwivesTable'))
        .catchError((error) => print(error));
    print('$response');
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      print('$data');
      setState(() {
        midwives = data.map((json) => Midwife.fromJson(json)).toList();
        filteredMidwives = midwives;
        print('$midwives');
      });
    } else {
      throw Exception('Failed to load midwives');
    }
  }

  List<Midwife> getCurrentPageItems() {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    return filteredMidwives.sublist(
        startIndex,
        endIndex > filteredMidwives.length
            ? filteredMidwives.length
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
    return (filteredMidwives.length / _itemsPerPage).ceil();
  }

  void onsortColum(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
      if (columnIndex == 0) {
        if (ascending) {
          filteredMidwives.sort((a, b) => a.name!.compareTo(b.name!));
        } else {
          filteredMidwives.sort((a, b) => b.name!.compareTo(a.name!));
        }
      }
    });
  }

  void performAction(
      BuildContext context, Midwife midwife, String action) async {
    // Navigate to another page based on the action
    if (action == 'view') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MidwifePage(midwife: midwife),
        ),
      );
    } else if (action == 'edit') {
      // Show edit confirmation dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Edit Midwife'),
            content: Text('Are you sure you want to edit this Midwife record?'),
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
                  bool success = await editMidwife(midwife.id, context);
                  Navigator.of(context).pop(success);
                },
              ),
            ],
          );
        },
      ).then((value) {
        if (value != null && value == true) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EditMidwifePage(midwifeId: midwife.id),
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
                Text('Are you sure you want to delete this midwife record?'),
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
          await deleteMidwifeAlert(midwife.id, context);

          // Remove the deleted record from the list
          setState(() {
            midwives.remove(midwife);
          });

          // Show alert dialog after deletion
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Success'),
                content: Text('The midwife record has been deleted.'),
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
          print('Error deleting midwife record: $e');
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
            'Midwife List',
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
                          'motherName',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      onSort: (columnIndex, ascending) {
                        setState(() {
                          _sortColumnIndex = columnIndex;
                          _sortAscending = ascending;
                          filteredMidwives.sort((a, b) {
                            if (a.motherName == b.motherName) {
                              return 0;
                            } else if (ascending) {
                              return a.motherName.compareTo(b.motherName);
                            } else {
                              return b.motherName.compareTo(a.motherName);
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
                          'newbornBraceletHand',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      onSort: (columnIndex, ascending) {
                        setState(() {
                          _sortColumnIndex = columnIndex;
                          _sortAscending = ascending;
                          if (columnIndex == 2) {
                            filteredMidwives.sort((a, b) => a
                                .newbornBraceletHand
                                .compareTo(b.newbornBraceletHand));
                          } else if (columnIndex == 3) {
                            filteredMidwives.sort((a, b) => a.newbornBraceletLeg
                                .compareTo(b.newbornBraceletLeg));
                          }
                          if (!_sortAscending) {
                            filteredMidwives =
                                filteredMidwives.reversed.toList();
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
                          'newbornBraceletLeg',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      onSort: (columnIndex, ascending) {
                        setState(() {
                          _sortColumnIndex = columnIndex;
                          _sortAscending = ascending;
                          if (columnIndex == 3) {
                            filteredMidwives.sort((a, b) => a.newbornBraceletLeg
                                .compareTo(b.newbornBraceletLeg));
                          } else if (columnIndex == 2) {
                            filteredMidwives.sort((a, b) => a
                                .newbornBraceletHand
                                .compareTo(b.newbornBraceletHand));
                          }
                          if (!_sortAscending) {
                            filteredMidwives =
                                filteredMidwives.reversed.toList();
                          }
                        });
                      },
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
                                filteredMidwives = midwives;
                              } else {
                                filteredMidwives = midwives
                                    .where((midwife) =>
                                        midwife.name.toLowerCase().contains(
                                            searchText.toLowerCase()) ||
                                        midwife.newbornBraceletHand
                                            .toLowerCase()
                                            .contains(
                                                searchText.toLowerCase()) ||
                                        midwife.newbornBraceletLeg
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
                      // DataCell(Text('')),
                      // DataCell(Text('')),
                      // DataCell(Text('')),
                    ]),
                    for (var midwife in getCurrentPageItems())
                      DataRow(cells: [
                        DataCell(Text(midwife.id.toString())),
                        DataCell(Text(midwife.name)),
                        DataCell(Text(midwife.newbornBraceletHand)),
                        DataCell(Text(midwife.newbornBraceletLeg)),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  // Perform the edit action
                                  performAction(context, midwife, 'edit');
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.visibility),
                                onPressed: () {
                                  // Perform the view action
                                  performAction(context, midwife, 'view');
                                },
                              ),
                              IconButton(
                                onPressed: () async {
                                  performAction(context, midwife, 'delete');
                                },
                                icon: Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ),
                        DataCell(Text('')),
                      ]),
                    DataRow(cells: [
                      DataCell(Text('')),
                      DataCell(Text('')),
                      DataCell(Text('')),
                      DataCell(Text('')),
                      DataCell(Text('')),
                      DataCell(Text('')),
                      // DataCell(Text('')),
                      // DataCell(Text('')),
                      // DataCell(Text('')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('')),
                      DataCell(Text('')),
                      DataCell(Text('')),
                      DataCell(Text('')),
                      DataCell(Text('')),
                      // DataCell(Text('')),
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
                      // DataCell(Text('')),
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

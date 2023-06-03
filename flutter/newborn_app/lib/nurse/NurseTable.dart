import 'package:flutter/material.dart';
import 'package:newborn_app/Nurse/EditNursePage.dart';
import 'package:newborn_app/constant/models/nurse.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'dart:convert';

import 'package:newborn_app/methods/nurse_api.dart';

class NursePage extends StatefulWidget {
  @override
  _NurseTableState createState() => _NurseTableState();
}

class _NurseTableState extends State<NursePage> {
  List<Nurse> nurses = [];
  List<Nurse> filteredNurses = [];
  String searchText = '';
  int _currentPage = 1;
  int _itemsPerPage = 4;
  bool sort = true;
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  List<Nurse> getCurrentPageItems() {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    return filteredNurses.sublist(startIndex,
        endIndex > filteredNurses.length ? filteredNurses.length : endIndex);
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
    return (filteredNurses.length / _itemsPerPage).ceil();
  }

  void onsortColum(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
      if (columnIndex == 0) {
        if (ascending) {
          filteredNurses.sort((a, b) => a.name!.compareTo(b.name!));
        } else {
          filteredNurses.sort((a, b) => b.name!.compareTo(a.name!));
        }
      }
    });
  }

  void performAction(BuildContext context, Nurse nurse, String action) async {
    // Navigate to another page based on the action
    if (action == 'view') {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => NursePage(nurseId: nurse.id),
      //   ),
      // );
    } else if (action == 'edit') {
      // Show edit confirmation dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Edit nurse'),
            content: Text('Are you sure you want to edit this nurse record?'),
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
                  bool success = await editNurse(nurse.id, context);
                  Navigator.of(context).pop(success);
                },
              ),
            ],
          );
        },
      ).then((value) {
        if (value != null && value == true) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EditNursePage(nurseId: nurse.id),
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
            content: Text('Are you sure you want to delete this nurse record?'),
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
          await deleteNurse(nurse.id, context);

          // Remove the deleted record from the list
          setState(() {
            nurses.remove(nurse);
          });

          // Show alert dialog after deletion
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Success'),
                content: Text('The nurse record has been deleted.'),
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
          print('Error deleting nurse record: $e');
        }
      }
    }
  }

  Future<void> getNurses() async {
    final response = await http
        .get(Uri.parse('http://127.0.0.1:8000/api/nurseTable'))
        .catchError((error) => print(error));
    print('$response');
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      print('$data');
      setState(() {
        nurses = data.map((json) => Nurse.fromJson(json)).toList();
        filteredNurses = nurses;
        print('$nurses');
      });
    } else {
      throw Exception('Failed to load nurses');
    }
  }

  @override
  void initState() {
    super.initState();
    getNurses();
  }

  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue),
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              'Nurse List',
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
                                  filteredNurses = nurses;
                                } else {
                                  filteredNurses = nurses
                                      .where((nurse) =>
                                          nurse.name.toLowerCase().contains(
                                              searchText.toLowerCase()) ||
                                          nurse.salary.toLowerCase().contains(
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
                      ]),
                      for (var nurse in getCurrentPageItems())
                        DataRow(cells: [
                          DataCell(Text(nurse.id.toString())),
                          DataCell(Text(nurse.name)),
                          DataCell(Text(nurse.salary)),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    // Perform the edit action
                                    performAction(context, nurse, 'edit');
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.visibility),
                                  onPressed: () {
                                    // Perform the view action
                                    performAction(context, nurse, 'view');
                                  },
                                ),
                                IconButton(
                                  onPressed: () async {
                                    performAction(context, nurse, 'delete');
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
                      ]),
                      DataRow(cells: [
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
      ),
    );
  }
}

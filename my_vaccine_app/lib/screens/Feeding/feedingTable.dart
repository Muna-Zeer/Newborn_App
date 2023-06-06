import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:my_vaccine_app/apiServer.dart';
import 'package:my_vaccine_app/screens/Feeding/feddingClass.dart';
import 'package:my_vaccine_app/screens/Feeding/feddingEdit.dart';
import 'package:my_vaccine_app/screens/Feeding/feddingForm.dart';
import 'package:my_vaccine_app/screens/Feeding/feeding_api.dart';

class FeedingTable extends StatefulWidget {
  @override
  _FeedingTableState createState() => _FeedingTableState();
}

class _FeedingTableState extends State<FeedingTable> {
  List<Feeding> Feedings = [];
  List<Feeding> filteredFeeding = [];
  String searchText = '';
  int _currentPage = 1;
  int _itemsPerPage = 4;
  int _sortColumnIndex = 0;
  bool _sortAscending = true;
  @override
  void initState() {
    super.initState();
    getFeeding();
  }

  Future<void> getFeeding() async {
     final baseUrl = ApiService.getBaseUrl();
    final response = await http
        .get(Uri.parse('$baseUrl/feedings'))
        .catchError((error) => print(error));

    print('$response');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      print('$data');

      setState(() {
        Feedings = parseFeedings(data);
        filteredFeeding = Feedings;
        print('$Feedings');
      });
    } else {
      throw Exception('Failed to load feeding');
    }
  }

  List<Feeding> parseFeedings(List<dynamic> data) {
    return data.map<Feeding>((json) => Feeding.fromJson(json)).toList();
  }

  List<Feeding> getCurrentPageItems() {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage > filteredFeeding.length
        ? filteredFeeding.length
        : startIndex + _itemsPerPage;
    return filteredFeeding.sublist(startIndex, endIndex);
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
    return (filteredFeeding.length / _itemsPerPage).ceil();
  }

  void onSortColumn(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;

      filteredFeeding.sort((a, b) {
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
        filteredFeeding = filteredFeeding.reversed.toList();
      }
    });
  }

  Comparable? getColumnValue(Feeding feeding, int columnIndex) {
    switch (columnIndex) {
      case 0:
        return feeding.id;
      case 1:
        return feeding.feedingType;
      case 2:
        return feeding.instructions;
      case 3:
        return feeding.quantity;

      default:
        return null;
    }
  }

  void performAction(
      BuildContext context, Feeding feeding, String action) async {
    // Navigate to another page based on the action
    if (action == 'insert') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FeedingForm()),
      );
    } else if (action == 'edit') {
      // Show edit confirmation dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Edit Feeding'),
            content: Text('Are you sure you want to edit this feeding record?'),
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
                  bool success = await editFeeding(feeding.id, context);
                  Navigator.of(context).pop(success);
                },
              ),
            ],
          );
        },
      ).then((value) {
        if (value != null && value == true) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => FeedingEdit(feedingId: feeding.id),
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
                Text('Are you sure you want to delete this feeding record?'),
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
          await deletefeeding(feeding.id, context);

          // Remove the deleted record from the list
          setState(() {
            Feedings.remove(feeding);
          });

          // Show alert dialog after deletion
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Success'),
                content: Text('The feeding record has been deleted.'),
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
          print('Error deleting feeding record: $e');
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
            'feeding List',
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
                              'quantity',
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
                      tooltip: 'Sort by quantity',
                    ),
                    DataColumn(
                      label: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.blue),
                          ),
                        ),
                        child: Text(
                          'feedingType',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      onSort: (columnIndex, ascending) =>
                          onSortColumn(columnIndex, ascending),
                      tooltip: 'Sort by feedingType',
                    ),
                    DataColumn(
                      label: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.blue),
                          ),
                        ),
                        child: Text(
                          'month',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      onSort: (columnIndex, ascending) =>
                          onSortColumn(columnIndex, ascending),
                      tooltip: 'Sort by month',
                    ),
                    DataColumn(
                      label: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.blue),
                          ),
                        ),
                        child: Text(
                          'instructions',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      onSort: (columnIndex, ascending) =>
                          onSortColumn(columnIndex, ascending),
                      tooltip: 'Sort by instructions',
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
                                filteredFeeding = Feedings;
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
                    ]),
                    for (var feeding in getCurrentPageItems())
                      DataRow(cells: [
                        DataCell(Text(feeding.id?.toString() ?? '')),
                        DataCell(Text(feeding.feedingType ?? '')),
                        DataCell(Text(feeding.quantity?.toString() ?? '')),
                        DataCell(Text(feeding.instructions ?? '')),
                        DataCell(Text(feeding.month ?? '')),

                        // DataCell(Text(
                        //     feeding.method?.toString().split('.').last ?? '')),
                        // DataCell(Text(feeding.date as String)),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  // Perform the edit action
                                  performAction(context, feeding, 'edit');
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  // Perform the view action
                                  performAction(context, feeding, 'insert');
                                },
                              ),
                              IconButton(
                                onPressed: () async {
                                  performAction(context, feeding, 'delete');
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
                    ]),
                    DataRow(cells: [
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

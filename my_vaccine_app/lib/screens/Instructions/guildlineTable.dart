import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:my_vaccine_app/apiServer.dart';

import 'package:my_vaccine_app/screens/Instructions/guildlineClass.dart';
import 'package:my_vaccine_app/screens/Instructions/guildlineEdit.dart';
import 'package:my_vaccine_app/screens/Instructions/guildlineForm.dart';
import 'package:my_vaccine_app/screens/Instructions/guiledline_api.dart';

class GuildlineTable extends StatefulWidget {
  @override
  _GuildlineTableState createState() => _GuildlineTableState();
}

class _GuildlineTableState extends State<GuildlineTable> {
  List<Guideline> Guildlines = [];
  List<Guideline> filteredGuildline = [];
  String searchText = '';
  int _currentPage = 1;
  int _itemsPerPage = 4;
  int _sortColumnIndex = 0;
  bool _sortAscending = true;
  @override
  void initState() {
    super.initState();
    getGuildline();
  }

  Future<void> getGuildline() async {
    final baseUrl = ApiService.getBaseUrl();

    final response = await http
        .get(Uri.parse('$baseUrl/guidelines'))
        .catchError((error) => print(error));

    print('$response');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      print('$data');

      setState(() {
        Guildlines = data.map((item) => Guideline.fromJson(item)).toList();
        filteredGuildline = Guildlines;
        print('guildline $Guildlines');
      });
    } else {
      throw Exception('Failed to load guildine');
    }
  }

  List<Guideline> getCurrentPageItems() {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage > filteredGuildline.length
        ? filteredGuildline.length
        : startIndex + _itemsPerPage;
    return filteredGuildline.sublist(startIndex, endIndex);
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
    return (filteredGuildline.length / _itemsPerPage).ceil();
  }

  void onSortColumn(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;

      filteredGuildline.sort((a, b) {
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
        filteredGuildline = filteredGuildline.reversed.toList();
      }
    });
  }

  Comparable? getColumnValue(Guideline guideline, int columnIndex) {
    switch (columnIndex) {
      case 0:
        return guideline.id;
      case 1:
        return guideline.vaccineName;
      case 2:
        return guideline.sideEffects;
      case 3:
        return guideline.careInstructions;
      case 4:
        return guideline.preventionMethod;
      case 5:
        return guideline.ministryId;

      default:
        return null;
    }
  }

  void performAction(
      BuildContext context, Guideline guidline, String action) async {
    // Navigate to another page based on the action
    if (action == 'insert') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GuildlineForm()),
      );
    } else if (action == 'edit') {
      // Show edit confirmation dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Edit guidline'),
            content: Text('هل انت متاكد النعديل هنا?'),
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
                  bool success = await editguildline(guidline.id, context);
                  Navigator.of(context).pop(success);
                },
              ),
            ],
          );
        },
      ).then((value) {
        if (value != null && value == true) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => GuidelineEdit(GuidelineId: guidline.id),
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
                Text('Are you sure you want to delete this guidline record?'),
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
          await deleteGuideline(guidline.id, context);

          // Remove the deleted record from the list
          setState(() {
            Guildlines.remove(guidline);
          });

          // Show alert dialog after deletion
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('تم بنجاج'),
                content: Text('لقد تم اضافة الارشاردات الصحية.'),
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
          print('للاسف هناك خطا في الاضافة: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0), // Add padding around the table
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Color.fromARGB(255, 103, 120, 134)),
            ),
            child: Column(children: [
              Text(
                'قائمة الارشادات الصحية',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Flexible(
                child: ListView(shrinkWrap: true, children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.0), // Add horizontal padding
                    child: SingleChildScrollView(
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
                                    'الرقم',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
                                    'اسم التطعيم',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
                            tooltip: 'Sort by vaccineName',
                          ),
                          DataColumn(
                            label: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.blue),
                                ),
                              ),
                              child: Text(
                                'الاثار الجانبية',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            onSort: (columnIndex, ascending) =>
                                onSortColumn(columnIndex, ascending),
                            tooltip: 'Sort by sideEffects',
                          ),
                          DataColumn(
                            label: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.blue),
                                ),
                              ),
                              child: Text(
                                'التعليمات الصحية',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            onSort: (columnIndex, ascending) =>
                                onSortColumn(columnIndex, ascending),
                            tooltip: 'Sort by careInstructions',
                          ),
                          DataColumn(
                            label: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.blue),
                                ),
                              ),
                              child: Text(
                                'طريقة الوفاية',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            onSort: (columnIndex, ascending) =>
                                onSortColumn(columnIndex, ascending),
                            tooltip: 'Sort by preventionMethod',
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
                                  'الوظيفة',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )
                        ],
                        rows: [
                          DataRow(cells: [
                            DataCell(
                              TextField(
                                decoration: InputDecoration(
                                  hintText: 'بحث',
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
                                      filteredGuildline = Guildlines;
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
                          for (var guidline in getCurrentPageItems())
                            DataRow(cells: [
                              DataCell(Text(guidline.id?.toString() ?? '')),
                              DataCell(Text(guidline.vaccineName ?? '')),
                              DataCell(Text(guidline.careInstructions ?? '')),
                              DataCell(Text(guidline.preventionMethod ?? '')),
                              DataCell(Text(guidline.sideEffects ?? '')),
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        // Perform the edit action
                                        performAction(
                                            context, guidline, 'edit');
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: () {
                                        // Perform the view action
                                        performAction(
                                            context, guidline, 'insert');
                                      },
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        performAction(
                                            context, guidline, 'delete');
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      'رقم الصفحة $_currentPage من ${getTotalPages()}'),
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
                  ),
                ]),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

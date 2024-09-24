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
  List<Guideline> guidelines = [];
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

  void filterGuidelines(query) {
    setState(() {
      if (searchText.isEmpty) {
        filteredGuildline = guidelines;
      } else {
        filteredGuildline = guidelines.where((guideline) {
          final numVaccine = guideline.id.toString().toLowerCase();
          final vaccineName = guideline.vaccineName.toString().toLowerCase();
          final sideEffect = guideline.sideEffects.toString().toLowerCase();
          final careInstructions =
              guideline.careInstructions.toString().toLowerCase();
          final preventiveMethod =
              guideline.preventionMethod.toString().toLowerCase();
          return vaccineName.contains(query.toLowerCase()) ||
              careInstructions.contains(query.toLowerCase()) ||
              sideEffect.contains(query.toString()) ||
              preventiveMethod.contains(query.toLowerCase()) ||
              numVaccine.contains(query.toLowerCase());
        }).toList();
      }
    });
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
        guidelines = data.map((item) => Guideline.fromJson(item)).toList();
        filteredGuildline = guidelines;
        print('guildline $guidelines');
      });
    } else {
      throw Exception('Failed to load guidelines');
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
    if (action == 'insert') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GuildlineForm()),
      );
    } else if (action == 'edit') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Edit guideline',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'هل أنت متأكد من تعديل هذا الدليل؟',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          bool success =
                              await editguildline(guidline.id, context);
                          Navigator.of(context).pop(success);
                        },
                        child: Text(
                          'Edit',
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              elevation: 0,
              backgroundColor: Colors.white,
              content: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: const Color.fromARGB(255, 2, 31, 54),
                      width: 2.0,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Image.asset(
                          'assets/delete.webp',
                          width: 150.0,
                          height: 150.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'هل تريد الحذف',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18.0),
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              child: Text('الغاء',
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold)),
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                            ),
                            TextButton(
                              child: Text('حذف',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold)),
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                            ),
                          ])
                    ],
                  )));
        },
      );
      if (confirmDelete) {
        try {
          await deleteGuideline(guidline.id, context);

          setState(() {
            guidelines.remove(guidline);
          });

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
          padding: EdgeInsets.all(20.0),
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
              Expanded(
                child: ListView(shrinkWrap: true, children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 2.0),
                      ),
                      columns: [
                        DataColumn(
                          label: Container(
                            child: Row(
                              children: [
                                Text(
                                  'الرقم',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
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
                            child: Row(
                              children: [
                                Text(
                                  'اسم التطعيم',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
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
                            width: 150.0,
                            child: Text(
                              'الاثار الجانبية',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          onSort: (columnIndex, ascending) =>
                              onSortColumn(columnIndex, ascending),
                          tooltip: 'Sort by sideEffects',
                        ),
                        DataColumn(
                          label: Container(
                            width: 100.0,
                            child: Text(
                              'التعليمات الصحية',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          onSort: (columnIndex, ascending) =>
                              onSortColumn(columnIndex, ascending),
                          tooltip: 'Sort by careInstructions',
                        ),
                        DataColumn(
                          label: Container(
                            width: 100.0,
                            child: Text(
                              'طريقة الوفاية',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          onSort: (columnIndex, ascending) =>
                              onSortColumn(columnIndex, ascending),
                          tooltip: 'Sort by preventionMethod',
                        ),
                        DataColumn(
                          label: Container(
                            width: 90.0,
                            child: Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: Text(
                                'الوظيفة',
                                style: TextStyle(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        )
                      ],
                      rows: [
                        DataRow(cells: [
                          DataCell(Text('')),
                          DataCell(Text('')),
                          DataCell(Text('')),
                          DataCell(Text('')),
                          DataCell(Text('')),
                          DataCell(Column(children: [
                            TextField(
                              decoration: InputDecoration(
                                hintText: 'بحث',
                                hintTextDirection: TextDirection.rtl,
                                border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.lightBlue),
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
                                  filterGuidelines(searchText);
                                  _currentPage = 1;
                                });
                              },
                            ),
                          ])),
                        ]),
                        for (var guidline in getCurrentPageItems())
                          DataRow(cells: [
                            DataCell(Container(
                                height: 60.0,
                                width: 150.0,
                                child: Text(
                                  guidline.id?.toString() ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                ))),
                            DataCell(Container(
                                height: 60.0,
                                width: 150.0,
                                child: Text(
                                  guidline.vaccineName ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  textDirection: TextDirection.ltr,
                                  maxLines: 2,
                                  textAlign: TextAlign.left,
                                ))),
                            DataCell(
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Container(
                                            width: 150,
                                            height: 250,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  guidline.sideEffects ?? '',
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  maxLines: 2,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    height: 60.0,
                                    width: 150.0,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          guidline.sideEffects ?? '',
                                          overflow: TextOverflow.ellipsis,
                                          textDirection: TextDirection.rtl,
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Container(
                                            height: 100.0,
                                            width: 60.0,
                                            child: Tooltip(
                                              message:
                                                  guidline.careInstructions,
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      guidline.careInstructions ??
                                                          '',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                      textDirection:
                                                          TextDirection.rtl,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    height: 60,
                                    width: 150,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          guidline.careInstructions ?? "",
                                          overflow: TextOverflow.ellipsis,
                                          textDirection: TextDirection.rtl,
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Tooltip(
                                            message:
                                                guidline.preventionMethod ?? '',
                                            child: SingleChildScrollView(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    guidline.preventionMethod ??
                                                        '',
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textDirection:
                                                        TextDirection.rtl,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    height: 60.0,
                                    width: 150.0,
                                    child: Tooltip(
                                      message: guidline.preventionMethod ?? '',
                                      child: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              guidline.preventionMethod ?? '',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              textDirection: TextDirection.rtl,
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon:
                                          Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () {
                                        performAction(
                                            context, guidline, 'edit');
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.add,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        performAction(
                                            context, guidline, 'insert');
                                      },
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        performAction(
                                            context, guidline, 'delete');
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
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
                          DataCell(
                            Container(
                              width: double.infinity,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      onPressed: goToPreviousPage,
                                      icon: Icon(
                                        Icons.arrow_back,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    Text(
                                      'رقم الصفحة $_currentPage من ${getTotalPages()}',
                                    ),
                                    IconButton(
                                      onPressed: goToNextPage,
                                      icon: Icon(
                                        Icons.arrow_forward,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          DataCell(Text('')),
                          DataCell(Text('')),
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
      ),
    );
  }
}

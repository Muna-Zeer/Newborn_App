import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:my_vaccine_app/apiServer.dart';
import 'package:my_vaccine_app/screens/preventiveExamination/preventiveEaminationClass.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:my_vaccine_app/screens/preventiveExamination/preventiveExamination.dart';
import 'package:my_vaccine_app/screens/preventiveExamination/preventiveExaminationEdit.dart';
import 'package:my_vaccine_app/screens/preventiveExamination/preventiveExamination_api.dart';

class PreventiveExaminationTable extends StatefulWidget {
  @override
  _PreventiveExaminationTable createState() => _PreventiveExaminationTable();
}

class _PreventiveExaminationTable extends State<PreventiveExaminationTable> {
  List<PreventiveExamination> Examinations = [];
  List<PreventiveExamination> filteredExaminations = [];
  String searchText = '';
  int _currentPage = 1;
  int _itemPerPage = 4;
  int _sortColumnIndex = 0;
  bool _sortAscending = true;
  @override
  void initState() {
    super.initState();
    getExamination();
  }

  Future<void> getExamination() async {
    final baseUrl = ApiService.getBaseUrl();

    try {
      final response =
          await http.get(Uri.parse('$baseUrl/preventiveExaminations'));
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['data'];
        print('$data');
        print('API Response: $json');

        setState(() {
          Examinations =
              data.map((item) => PreventiveExamination.fromJson(item)).toList();
          print('Examinations: $Examinations');
          print('Filtered Examinations: $filterExaminations');

          filteredExaminations = Examinations;
        });

        print('Data fetched successfully: $Examinations');
      } else {
        throw Exception('Failed to load preventive examinations');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  void filterExaminations(query) {
    setState(() {
      if (searchText.isEmpty) {
        filteredExaminations = Examinations;
      } else {
        filteredExaminations = Examinations.where((examination) {
          final vacccineId = examination.id.toString().toLowerCase();
          final vacciName = examination.examType.toString().toLowerCase();
          final result = examination.result.toString().toLowerCase();
          final VaccineDate = examination.toString().toLowerCase();
          return vacccineId.contains(query.toLowerCase()) ||
              vacciName.contains(query.toLowerCase()) ||
              result.contains(query.toLowerCase()) ||
              VaccineDate.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  List<PreventiveExamination> getCurrentPageItems() {
    final startIndex = (_currentPage - 1) * _itemPerPage;
    final endIndex = startIndex + _itemPerPage > filteredExaminations.length
        ? filteredExaminations.length
        : startIndex + _itemPerPage;
    return filteredExaminations.sublist(startIndex, endIndex);
  }

  void goToPrevPage() {
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
    return (filteredExaminations.length / _itemPerPage).ceil();
  }

  void onSortColumn(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
      filteredExaminations.sort((a, b) {
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
        filteredExaminations = filteredExaminations.reversed.toList();
      }
    });
  }

  Comparable? getColumnValue(
      PreventiveExamination examination, int ColumnIndex) {
    switch (ColumnIndex) {
      case 0:
        return examination.id;
      case 1:
        return examination.examType;
      case 2:
        return examination.date;
      case 3:
        return examination.result;
      default:
        return null;
    }
  }

  Future<void> performAction(BuildContext context,
      PreventiveExamination examination, String action) async {
    if (action == "insert") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PreventiveExaminationForm()),
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
                              await editPreventiveExam(examination.id, context);
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
            builder: (context) =>
                preventiveExamEdit(examinationId: examination.id),
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
          await deletePreventiveExamination(examination.id, context);

          setState(() {
            Examinations.remove(examination);
          });

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  'تم بنجاج',
                  textAlign: TextAlign.center,
                ),
                content: Text(
                  'لقد تم حذف الفحوصات الوقائية.',
                  textAlign: TextAlign.center,
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text(
                      'OK',
                      textAlign: TextAlign.center,
                    ),
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
          padding: EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Color.fromARGB(255, 103, 120, 134)),
            ),
            child: Column(
              children: [
                Text('قائمة الفحوصات الوقائية',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 16.0,
                ),
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                  if (_sortColumnIndex == 0)
                                    Icon(
                                      _sortAscending
                                          ? Icons.arrow_upward
                                          : Icons.arrow_downward,
                                    ),
                                ],
                              )),
                              numeric: true,
                              onSort: (columnIndex, ascending) =>
                                  onSortColumn(columnIndex, ascending),
                              tooltip: 'Sort by ID',
                            ),
                            DataColumn(
                              label: Container(
                                width: 150.0,
                                child: Text(
                                  'نوع الفحص',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              onSort: (columnIndex, ascnding) =>
                                  onSortColumn(columnIndex, ascnding),
                              tooltip: 'Sort by preventiveExaminationType',
                            ),
                            DataColumn(
                              label: Container(
                                width: 150.0,
                                child: Text(
                                  'تاريخ التطعيم',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              onSort: (columnIndex, ascnding) =>
                                  onSortColumn(columnIndex, ascnding),
                              tooltip: 'Sort by date',
                            ),
                            // DataColumn(
                            //   label: Container(
                            //     width: 150.0,
                            //     child: Text(
                            //       'وقت التطعيم',
                            //       style: TextStyle(fontWeight: FontWeight.bold),
                            //       textAlign: TextAlign.center,
                            //     ),
                            //   ),
                            //   onSort: (columnIndex, ascnding) =>
                            //       onSortColumn(columnIndex, ascnding),
                            //   tooltip: 'Sort by time',
                            // ),
                            DataColumn(
                              label: Container(
                                width: 150.0,
                                child: Text(
                                  'النتيجة',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              onSort: (columnIndex, ascnding) =>
                                  onSortColumn(columnIndex, ascnding),
                              tooltip: 'Sort by result',
                            ),
                            DataColumn(
                              label: Container(
                                width: 90.0,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    'الوظيفة',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ],
                          rows: [
                            DataRow(cells: [
                              DataCell(Text('')),
                              DataCell(Text('')),
                              DataCell(Text('')),
                              // DataCell(Text('')),
                              DataCell(Text('')),
                              // DataCell(Text('')),
                              DataCell(Column(children: [
                                TextField(
                                  decoration: InputDecoration(
                                    hintText: 'بحث',
                                    // hintTextDirection: TextDirection.rtl,
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
                                      filterExaminations(searchText);
                                      _currentPage = 1;
                                    });
                                  },
                                ),
                              ])),
                            ]),
                            for (var examination in getCurrentPageItems())
                              DataRow(cells: [
                                DataCell(Container(
                                    height: 60.0,
                                    width: 150.0,
                                    child: Text(
                                      examination.id?.toString() ?? '',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                    ))),
                                DataCell(Container(
                                    height: 60.0,
                                    width: 150.0,
                                    child: Text(
                                      examination.examType ?? '',
                                      overflow: TextOverflow.ellipsis,
                                      // textDirection: TextDirection.RTL,
                                      maxLines: 2,
                                      textAlign: TextAlign.left,
                                    ))),
                                DataCell(Column(
                                  children: [
                                    Text(
                                      examination.date != null
                                          ? DateFormat('yyyy-MM-dd')
                                              .format(examination.date!)
                                          : '',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      examination.time != null
                                          ? DateFormat('HH:mm:ss')
                                              .format(examination.time)
                                          : '',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                )),
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
                                                  message: examination.result,
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          examination.result ??
                                                              '',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 2,
                                                          // textDirection:
                                                          // TextDirection.rtl,
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
                                              examination.result ?? "",
                                              overflow: TextOverflow.ellipsis,
                                              // textDirection: TextDirection.rtl,
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
                                  Container(
                                    child: Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.edit,
                                              color: Colors.blue),
                                          onPressed: () {
                                            performAction(
                                                context, examination, 'edit');
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.add,
                                            color: Colors.red,
                                          ),
                                          onPressed: () {
                                            performAction(
                                                context, examination, 'insert');
                                          },
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            performAction(
                                                context, examination, 'delete');
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
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
                              // DataCell(Text('')),
                              // DataCell(Text('')),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('')),
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
                                          onPressed: goToPrevPage,
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
                              // DataCell(Text('')),
                              // DataCell(Text('')),
                            ]),
                          ]))
                ]))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

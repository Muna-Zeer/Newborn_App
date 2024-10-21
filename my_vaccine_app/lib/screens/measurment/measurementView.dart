import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_vaccine_app/apiServer.dart';
import 'package:my_vaccine_app/screens/measurment/measurementEdit.dart';
import 'package:my_vaccine_app/screens/measurment/measurementHome.dart';
import 'package:my_vaccine_app/screens/measurment/measurment.dart';
import 'package:http/http.dart' as http;
import 'package:my_vaccine_app/Alert_Dialog/mainDialog.dart';
import 'package:my_vaccine_app/screens/measurment/weightofBoys.dart';
import 'package:my_vaccine_app/screens/measurment/weighttogirls.dart';
import 'measurementDataSource.dart';

class MeasurementTable extends StatefulWidget {
  @override
  _MeasurementTableState createState() => _MeasurementTableState();
}

class _MeasurementTableState extends State<MeasurementTable> {
  List<Measurement> measurementData = [];
  List<Measurement> filterMeasurement = [];
  String searchText = '';
  bool isLoading = true;
  int rowsPerPage = 10;
  int sortColumnIndex = 0;
  bool isAscending = true;

  @override
  void initState() {
    super.initState();
    _getInitializeData();
  }

  Future<void> _getInitializeData() async {
    final baseUrl = ApiService.getBaseUrl();
    try {
      final response = await http.get(Uri.parse('$baseUrl/measurements'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['data'];
        print(data);
        setState(() {
          measurementData =
              data.map((item) => Measurement.fromJson(item)).toList();
          filterMeasurement = measurementData;
          isLoading = false;
        });
      }
    } catch (e) {
      throw Exception("Error fetching data $e");
    }
  }

  void _sort<T>(Comparable<T> Function(Measurement m) getField, int columnIndex,
      bool ascending) {
    filterMeasurement.sort((a, b) {
      if (!ascending) {
        final Measurement c = a;
        a = b;
        b = c;
      }
      return Comparable.compare(getField(a), getField(b));
    });
    setState(() {
      sortColumnIndex = columnIndex;
      isAscending = ascending;
    });
  }

  void _filterExaminations(String query) {
    setState(() {
      if (query.isEmpty) {
        filterMeasurement = measurementData;
      } else {
        filterMeasurement = measurementData.where((measurement) {
          return measurement.newbornId
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              measurement.nurseId
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              measurement.tonics
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              measurement.remarks
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  Future<void> performAction(Measurement measurement, String action) async {
    if (action == "insert") {
      String gender = measurement.newborn.gender.toLowerCase();
      if (gender == "male") {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => MeasurementWeight()));
      } else if (gender == "female") {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => MeasurementWeightGirls()));
      }
    } else if (action == "edit") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              MeasurementEdit(measurementId: measurement.newbornId),
        ),
      );
    }
    if (action == "delete") {
      bool confirmDelete = await showDeleteConfirmationDialog(context);
      if (confirmDelete) {
        try {
          setState(() {
            filterMeasurement.remove(measurement);
          });
          showDeleteSuccessDialog(context);
        } catch (e) {
          print("Error during deletion $e");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Measurement Data'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onChanged: _filterExaminations,
                      decoration: InputDecoration(
                        labelText: 'Search...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: PaginatedDataTable(
                        header: Center(child: Text("Measurement")),
                        columns: [
                          DataColumn(
                            label: Text('ID'),
                            onSort: (columnIndex, ascending) => _sort(
                                (m) => m.newbornId, columnIndex, ascending),
                          ),
                          DataColumn(
                            label: Text('Height'),
                            onSort: (columnIndex, ascending) =>
                                _sort((m) => m.height, columnIndex, ascending),
                          ),
                          DataColumn(
                            label: Text('Weight'),
                            onSort: (columnIndex, ascending) =>
                                _sort((m) => m.weight, columnIndex, ascending),
                          ),
                          DataColumn(
                            label: Text('Age'),
                            onSort: (columnIndex, ascending) =>
                                _sort((m) => m.age, columnIndex, ascending),
                          ),
                          DataColumn(
                            label: Text('Head Circumference'),
                            onSort: (columnIndex, ascending) => _sort(
                                (m) => m.headCircumference,
                                columnIndex,
                                ascending),
                          ),
                          DataColumn(
                            label: Text('Tonics'),
                            onSort: (columnIndex, ascending) =>
                                _sort((m) => m.tonics, columnIndex, ascending),
                          ),
                          DataColumn(
                            label: Text('Remarks'),
                            onSort: (columnIndex, ascending) =>
                                _sort((m) => m.remarks, columnIndex, ascending),
                          ),
                          DataColumn(
                            label: Text('Nurse Name'),
                            onSort: (columnIndex, ascending) => _sort(
                                (m) => m.nurseName, columnIndex, ascending),
                          ),
                          DataColumn(
                            label: Text('Gender'),
                          ),
                          DataColumn(
                            label: Text('Actions'),
                          ),
                        ],
                        source: MeasurementDataSource(
                            filterMeasurement, performAction),
                        rowsPerPage: rowsPerPage,
                        sortColumnIndex: sortColumnIndex,
                        sortAscending: isAscending,
                        availableRowsPerPage: [5, 10, 20],
                        onRowsPerPageChanged: (rows) {
                          setState(() {
                            rowsPerPage = rows ?? 10;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

import 'package:flutter/material.dart';
import '../screens/newborns_screen.dart';
import '../screens/newborn.dart';
import '../constant/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constant/paginate_table.dart';

class NewbornsTable extends StatefulWidget {
  @override
  _NewbornsTableState createState() => _NewbornsTableState();
}

class _NewbornsTableState extends State<NewbornsTable> {
  final PaginationService _paginationService = PaginationService(onChange:
      (isLoading, items, currentPage, totalPages, hasNextPage, hasPrevPage) {
    // Handle changes to pagination data here
  });
  List<Newborn> _newborns = [];
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isLoading = false;
  bool _hasNextPage = false;
  bool _hasPrevPage = false;
  @override
  void initState() {
    super.initState();
    _fetchNewborns();
  }

  Future<void> _fetchNewborns() async {
    final paginationService = PaginationService(
      onChange: (isLoading, items, currentPage, totalPages, hasNextPage,
          hasPrevPage) {
        setState(() {
          _isLoading = isLoading;
          _currentPage = currentPage;
          _totalPages = totalPages;
          _hasNextPage = hasNextPage;
          _hasPrevPage = hasPrevPage;

          if (items != null && items is List<dynamic>) {
            _newborns = items
                .map((item) => Newborn.fromJson(item as Map<String, dynamic>))
                .toList();
            print('pagination $_newborns');
            print('items $items');
          }
        });
      },
    );

    try {
      final url = 'http://127.0.0.1:8000/api/newbornWithMothers';
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body)['data'];
      print('$data');
      final items = data['data'] as List<dynamic>;
      setState(() {
        _newborns = items
            .map((item) => Newborn.fromJson(item as Map<String, dynamic>))
            .toList();
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching newborns: $e');
    }
  }

  List<Newborn> mapNewborns(dynamic data) {
    return (data as List<dynamic>)
        .map((item) => Newborn.fromJson({
              'mother_name': item['motherName'],
              'newborn_name': item['newbornName'],
              'gender': item['gender'],
              'date_of_birth': item['dateOfBirth'],
              'time_of_birth': item['timeOfBirth'],
              'weight': item['weight'],
              'status': item['status'],
              'identity_number': item['id']
            }))
        .toList();
  }

  String mapNewbornsToString(dynamic data) {
    return jsonEncode(mapNewborns(data));
  }

  void _getNextPage(String url, String Function(dynamic) mapper) {
    if (_paginationService.hasNextPage) {
      setState(() {
        // Update the current page number in the PaginationService object
        _paginationService.goToNextPage(url, mapper);
      });
      _fetchNewborns();
    }
  }

  void _getPreviousPage(String url, String Function(dynamic) mapper) {
    if (_paginationService.hasPrevPage) {
      setState(() {
        // Update the current page number in the PaginationService object
        _paginationService.goToPreviousPage(url, mapper);
      });
      _fetchNewborns();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DataTable(
              columns: [
                // DataColumn(
                //     label: Text('ID',
                //         style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Name',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Gender',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Date of Birth',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Time of Birth',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Weight',
                        style: TextStyle(fontWeight: FontWeight.bold))),
              ],
              rows: _newborns
                  .map(
                    (newborn) => DataRow(
                      cells: [
// DataCell(Text(newborn.id.toString())),
                        DataCell(Text(newborn.newbornName)),
                        DataCell(Text(newborn.gender)),
                        DataCell(Text(newborn.dateOfBirth)),
                        DataCell(Text(newborn.timeOfBirth)),
                        DataCell(Text(newborn.weight.toString())),
                      ],
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: Text('Prev'),
                  onPressed: () => this._getPreviousPage(
                      'http://127.0.0.1:8000/api/newbornWithMothers',
                      mapNewbornsToString),
                  style: ElevatedButton.styleFrom(
                    primary: AppColors.primary,
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Text('Page $_currentPage of $_totalPages'),
                SizedBox(width: 10),
                ElevatedButton(
                  child: Text('Next'),
                  onPressed: () => this._getNextPage(
                      'http://127.0.0.1:8000/api/newbornWithMothers',
                      mapNewbornsToString),
                  style: ElevatedButton.styleFrom(
                    primary: AppColors.primary,
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

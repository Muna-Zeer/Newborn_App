import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:my_vaccine_app/apiServer.dart';
import 'package:my_vaccine_app/screens/midwives/midwife.dart';
import 'package:my_vaccine_app/widget/ActionButtons.dart';
import 'package:my_vaccine_app/widget/HeaderCell.dart';
import 'package:my_vaccine_app/widget/Pagination.dart';

import 'dart:convert';

import 'package:my_vaccine_app/widget/TableCellWidget.dart';
import 'package:my_vaccine_app/widget/TableHeader.dart';
import 'package:my_vaccine_app/widget/roundedIcon.dart';

class MidwifeTablePage extends StatefulWidget {
  @override
  _MidwifeTableState createState() => _MidwifeTableState();
}

final baseUrl = ApiService.getBaseUrl();

class _MidwifeTableState extends State<MidwifeTablePage> {
  List<Midwife> midwives = [];
  List<Midwife> filteredMidwives = [];
  int _currentPage = 1;
  int _itemsPerPage = 4;
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    getMidwives();
  }

  Future<void> getMidwives() async {
    final res = await http.get(Uri.parse('$baseUrl/midwivesTable'));
    if (res.statusCode == 200) {
      final body = jsonDecode(res.body)['data'];
      setState(() {
        midwives = body.map<Midwife>((j) => Midwife.fromJson(j)).toList();
        filteredMidwives = List.from(midwives);
      });
    }
  }

  List<Midwife> get paginatedData {
    int start = (_currentPage - 1) * _itemsPerPage;
    int end = start + _itemsPerPage;
    end = end > filteredMidwives.length ? filteredMidwives.length : end;

    return filteredMidwives.sublist(start, end);
  }

  void sortBy(String field, int colIndex) {
    setState(() {
      _sortColumnIndex = colIndex;
      _sortAscending = !_sortAscending;

      filteredMidwives.sort((a, b) {
        final A = getField(a, field);
        final B = getField(b, field);

        return _sortAscending ? A.compareTo(B) : B.compareTo(A);
      });
    });
  }

  dynamic getField(Midwife m, String f) {
    switch (f) {
      case 'id':
        return m.id ?? 0;
      case 'motherName':
        return m.motherName ?? "";
      case 'midwifeName':
        return m.name ?? "";
      case 'hospitalName':
        return m.hospitalName ?? "";
      case 'hand':
        return m.newbornBraceletHand ?? "";
      case 'leg':
        return m.newbornBraceletLeg ?? "";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f0fb),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Midwife List",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: Colors.blue,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width,
              constraints: const BoxConstraints(minWidth: 1000),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(3),
                  2: FlexColumnWidth(3),
                  3: FlexColumnWidth(3),
                  4: FlexColumnWidth(2),
                  5: FlexColumnWidth(2),
                  6: FlexColumnWidth(2),
                },
                border: TableBorder(
                  horizontalInside: BorderSide(color: Colors.grey.shade200),
                ),
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade50, Colors.blue.shade100],
                      ),
                    ),
                    children: [
                      headerCell("ID", () => sortBy("id", 0)),
                      headerCell("Mother Name", () => sortBy("motherName", 1)),
                      headerCell(
                          "Midwife Name", () => sortBy("midwifeName", 1)),
                      headerCell(
                          "Hospital Name", () => sortBy("hospitalName", 1)),
                      headerCell("Bracelet Hand", () => sortBy("hand", 2)),
                      headerCell("Bracelet Leg", () => sortBy("leg", 3)),
                      headerText("Action"),
                    ],
                  ),
                  for (var m in paginatedData) enhancedTableRow(m),
                ],
              ),
            ),
            const SizedBox(height: 20),
            AppPagination(
              currentPage: _currentPage,
              totalItems: filteredMidwives.length,
              itemsPerPage: _itemsPerPage,
              onPageChanged: (page) {
                setState(() {
                  _currentPage = page;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  TableRow enhancedTableRow(Midwife m) {
    return TableRow(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      children: [
        styledCell(m.id?.toString() ?? "-"),
        styledCell(m.motherName ?? "-"),
        styledCell(m.name ?? "-"),
        styledCell(m.hospitalId.toString() ?? "-"),
        styledCell(m.newbornBraceletHand ?? "-"),
        styledCell(m.newbornBraceletLeg ?? "-"),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              roundedIcon(Icons.visibility, Colors.blue, () {}),
              const SizedBox(width: 8),
              roundedIcon(Icons.edit, Colors.orange, () {}),
              const SizedBox(width: 8),
              roundedIcon(Icons.delete, Colors.red, () {}),
            ],
          ),
        ),
      ],
    );
  }

  Widget styledCell(String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Text(
        value,
        style: TextStyle(
          fontSize: 15,
          color: Colors.grey.shade900,
        ),
      ),
    );
  }
}

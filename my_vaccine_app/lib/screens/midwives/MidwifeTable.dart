import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:my_vaccine_app/apiServer.dart';
import 'package:my_vaccine_app/screens/midwives/midwife.dart';
import 'package:my_vaccine_app/widget/ActionButtons.dart';
import 'package:my_vaccine_app/widget/HeaderCell.dart';

import 'dart:convert';

import 'package:my_vaccine_app/widget/TableCellWidget.dart';
import 'package:my_vaccine_app/widget/TableHeader.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Midwife List",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(2),
                  3: FlexColumnWidth(2),
                  4: FlexColumnWidth(2),
                  5: FlexColumnWidth(2),
                  6: FlexColumnWidth(2),
                },
                border: TableBorder.all(color: Colors.grey.shade300),
                children: [
                  TableRow(
                    decoration: const BoxDecoration(
                      color: Color(0xffe3f2fd),
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
                  for (var m in filteredMidwives) tableRow(m),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  

  TableRow tableRow(Midwife m) {
    return TableRow(
      decoration: BoxDecoration(color: Colors.grey.shade50),
      children: [
        tableCell(m.id?.toString() ?? "-"),
        tableCell(m.motherName ?? "-"),
        tableCell(m.name ?? "-"),
        tableCell(m.hospitalId.toString() ?? "-"),
        tableCell(m.newbornBraceletHand ?? "-"),
        tableCell(m.newbornBraceletLeg ?? "-"),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(icon: const Icon(Icons.visibility), onPressed: () {}),
              IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
              IconButton(icon: const Icon(Icons.delete), onPressed: () {}),
            ],
          ),
        ),
      ],
    );
  }
}

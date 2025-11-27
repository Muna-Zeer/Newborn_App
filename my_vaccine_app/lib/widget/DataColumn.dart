import 'package:flutter/material.dart';

DataColumn buildTableColumn({
  required String label,
  int? columnIndex,
  void Function(int columnIndex, bool ascending)? onSort,
}) {
  return DataColumn(
    label: Container(
      padding: const EdgeInsets.only(bottom: 4),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.blue, width: 2),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    onSort: onSort != null && columnIndex != null
        ? (index, asc) => onSort(index, asc)
        : null,
  );
}

import 'package:flutter/material.dart';
import 'package:my_vaccine_app/screens/measurment/measurment.dart';

class MeasurementDataSource extends DataTableSource {
  final List<Measurement> measurements;
  final Future<void> Function(Measurement, String) performAction;

  MeasurementDataSource(this.measurements, this.performAction);

  @override
  DataRow getRow(int index) {
    if (index >= measurements.length) return const DataRow(cells: []);

    final measurement = measurements[index];
    final newborn = measurement.newborn.gender;
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(measurement.newbornId.toString())),
        DataCell(Text(measurement.height.toString())),
        DataCell(Text(measurement.weight.toString())),
        DataCell(Text(measurement.age.toString())),
        DataCell(Text(measurement.headCircumference.toString())),
        DataCell(Text(measurement.tonics)),
        DataCell(Text(measurement.remarks)),
        DataCell(Text(measurement.nurseName)),
        DataCell(
          Text(newborn),
        ),
        DataCell(Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon:const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                performAction(measurement, "edit");
              },
            ),
            IconButton(
              icon:const Icon(Icons.add, color: Colors.red),
              onPressed: () {
                performAction(measurement, 'insert');
              },
            ),
            IconButton(
              icon:const Icon(Icons.delete, color: Colors.green),
              onPressed: () {
                performAction(measurement, 'delete');
              },
            ),
          ],
        )),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => measurements.length;

  @override
  int get selectedRowCount => 0;
}

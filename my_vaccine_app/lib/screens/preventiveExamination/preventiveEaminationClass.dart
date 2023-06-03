import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PreventiveExamination {
  int id;
  String examType;
  DateTime date;
  TimeOfDay time;
  String result;
  String newbornId;
  int healthCenterId;
  int ministryId;
  int nurseId;

  PreventiveExamination({
    required this.id,
    required this.examType,
    required this.date,
    required this.time,
    required this.result,
    required this.newbornId,
    required this.healthCenterId,
    required this.ministryId,
    required this.nurseId,
  });

  factory PreventiveExamination.fromJson(Map<String, dynamic> json) {
    return PreventiveExamination(
      id: json['id'],
      examType: json['exam_type'],
      date: DateTime.parse(json['date']),
      time: TimeOfDay.fromDateTime(DateTime.parse(json['time'])),
      result: json['result'],
      newbornId: json['newborn_id'],
      healthCenterId: json['health_center_id'],
      ministryId: json['ministry_id'],
      nurseId: json['nurse_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final formattedTime = DateFormat('HH:mm:ss')
        .format(time as DateTime); // Convert TimeOfDay to HH:mm:ss format

    return {
      'id': id,
      'exam_type': examType,
      'date': date.toIso8601String(),
      'time': formattedTime,
      'result': result,
      'newborn_id': newbornId,
      'health_center_id': healthCenterId,
      'ministry_id': ministryId,
      'nurse_id': nurseId,
    };
  }
}

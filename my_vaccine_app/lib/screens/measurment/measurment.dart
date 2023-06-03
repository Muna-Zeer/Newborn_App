import 'package:flutter/material.dart';

class Measurement {
  final double height;
  final double weight;
  final double headCircumference;
  final DateTime date;
  final TimeOfDay time;
  final String nurseName;
  final String remarks;
  final int age;
  final String tonics;
  final int newbornId;
  final int nurseId;
  final int midwifeId;
  final int healthCenterId;
  final int ministryId;
  final int hospitalId;

  Measurement({
    required this.height,
    required this.weight,
    required this.headCircumference,
    required this.date,
    required this.time,
    required this.nurseName,
    required this.remarks,
    required this.age,
    required this.tonics,
    required this.newbornId,
    required this.nurseId,
    required this.midwifeId,
    required this.healthCenterId,
    required this.ministryId,
    required this.hospitalId,
  });

  Map<String, dynamic> toJson() {
    return {
      'height': height,
      'weight': weight,
      'head_circumference': headCircumference,
      'date': date.toIso8601String(),
      'time': _formatTimeOfDay(time), // Convert TimeOfDay to a string format
      'nurse_name': nurseName,
      'remarks': remarks,
      'age': age,
      'tonics': tonics,
      'newborn_id': newbornId,
      'nurse_id': nurseId,
      'midwife_id': midwifeId,
      'health_center_id': healthCenterId,
      'ministry_id': ministryId,
      'hospital_id': hospitalId,
    };
  }

  factory Measurement.fromJson(Map<String, dynamic> json) {
    return Measurement(
      height: json['height'],
      weight: json['weight'],
      headCircumference: json['head_circumference'],
      date: DateTime.parse(json['date']),
      time: _parseTimeOfDay(json['time']), 
      nurseName: json['nurse_name'],
      remarks: json['remarks'],
      age: json['age'],
      tonics: json['tonics'],
      newbornId: json['newborn_id'],
      nurseId: json['nurse_id'],
      midwifeId: json['midwife_id'],
      healthCenterId: json['health_center_id'],
      ministryId: json['ministry_id'],
      hospitalId: json['hospital_id'],
    );
  }

  static String _formatTimeOfDay(TimeOfDay timeOfDay) {
    final String hour = timeOfDay.hour.toString().padLeft(2, '0');
    final String minute = timeOfDay.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  static TimeOfDay _parseTimeOfDay(String timeString) {
    final List<String> parts = timeString.split(':');
    final int hour = int.parse(parts[0]);
    final int minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }
}

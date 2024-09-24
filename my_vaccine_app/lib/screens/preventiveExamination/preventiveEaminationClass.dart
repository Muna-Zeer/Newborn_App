import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PreventiveExamination {
  int id;
  String examType;
  DateTime? date;
  DateTime time;
  String? result;
  String? newbornId;
  // int healthCenterId;
  int ministryId;
  int nurseId;

  PreventiveExamination({
    required this.id,
    required this.examType,
    required this.date,
    required this.time,
    required this.result,
    required this.newbornId,
    // required this.healthCenterId,
    required this.ministryId,
    required this.nurseId,
  });

  factory PreventiveExamination.fromJson(Map<String, dynamic> json) {
    return PreventiveExamination(
      id: json['id'] ?? 0,
      examType: json['exam_type'] ?? '',
      date: _parseDate(json['date']),
      time: _parseTime(json['time']),
      result: json['result'],
      newbornId: json['newborn_id'],
      // healthCenterId: json['health_center_id'] ?? 0,
      ministryId: json['ministry_id'] ?? 0,
      nurseId: json['nurse_id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exam_type': examType,
      'date': date?.toIso8601String(),
      'time': _formatTime(time),
      'result': result,
      'newborn_id': newbornId,
      // 'health_center_id': healthCenterId,
      'ministry_id': ministryId,
      'nurse_id': nurseId,
    };
  }

  Map<String, dynamic> NewToJson() {
    return {
      'id': id,
      'exam_type': examType,
      'date': date?.toIso8601String(),
      'time': _formatTime(time),
      'result': result,
      'ministry_id': ministryId,
    };
  }

  static DateTime? _parseDate(String? dateString) {
    if (dateString != null && dateString.isNotEmpty) {
      return DateTime.tryParse(dateString);
    }
    return null;
  }

  static DateTime _parseTime(String? timeString) {
    if (timeString != null && timeString.isNotEmpty) {
      try {
        final hasAm = timeString.toLowerCase().contains('am');
        final hasPm = timeString.toLowerCase().contains('pm');

        if (hasAm || hasPm) {
          final parsedTime = DateFormat('hh:mm a').parse(timeString);

          final hour = parsedTime.hour;
          final minute = parsedTime.minute;

          print("Parsed Time: $parsedTime");

          if (hasPm && hour < 12) {
            return DateTime(1970, 1, 1, hour + 12, minute);
          } else {
            return DateTime(1970, 1, 1, hour, minute);
          }
        } else {
          // If no 'am' or 'pm' suffix, assume it is in 24-hour format
          final parsedTime = DateFormat('HH:mm').parse(timeString);
          return DateTime(1970, 1, 1, parsedTime.hour, parsedTime.minute);
        }
      } catch (e) {
        // Print the error for debugging
        print("Error parsing time: $e");
      }
    }
    return DateTime.now();
  }

  static String _formatTime(DateTime dateTime) {
    return DateFormat('HH:mm:ss').format(dateTime);
  }
}

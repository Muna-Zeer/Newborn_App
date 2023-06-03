import 'dart:io';
import 'dart:math';

class Nurse {
  final int id;
  final String name;
  final String salary;
  final int ministryOfHealthId;
  final int hospitalId;
  final String hospitalName;
  final int doctorId;
  final String doctorName;
  final String ministryOfHealthName;
  final String specialization;

  final List<Map<String, String>> schedule;
  final String startTime;
  final String endTime;

  File? image;

  Nurse({
    required this.id,
    required this.name,
    required this.specialization,
    required this.ministryOfHealthId,
    required this.hospitalId,
    required this.hospitalName,
    required this.doctorId,
    required this.doctorName,
    required this.ministryOfHealthName,
    required this.salary,
    this.image,
    this.schedule = const [],
    required this.startTime,
    required this.endTime,
  });

  factory Nurse.fromJson(Map<String, dynamic> json) => Nurse(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        ministryOfHealthId: json['ministry_of_health_id'] ?? 0,
        hospitalId: json['hospital_id'] ?? 0,
        doctorId: json['doctor_id'] ?? 0,
        specialization: json['specialization'] ?? '',
        image: json['image'] != null ? File(json['image'] as String) : null,
        salary: json['salary'] != null ? json['salary'].toString() : '',
        schedule: List<Map<String, String>>.from(json['schedule'] ?? []),
        startTime: json['startTime'] ?? '',
        endTime: json['endTime'] ?? '',
        hospitalName: '',
        doctorName: '',
        ministryOfHealthName: '',
      );
}

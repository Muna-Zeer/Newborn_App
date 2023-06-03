import 'dart:io';
import 'dart:math';

class Midwife {
  final int id;
  final String name;
  final int hours;
  final int salary;
  final String communication;
  final String motherName;
  final String newbornBraceletHand;
  final String newbornBraceletLeg;

  final int ministryOfHealthId;
  final int hospitalId;
  final String hospitalName;
  final int doctorId;
  final String doctorName;
  final String ministryOfHealthName;
  final List<Map<String, String>> schedule;
  final String startTime;
  final String endTime;
  final String report;

  File? image;

  Midwife({
    required this.id,
    required this.name,
    required this.salary,
    required this.hours,
    required this.communication,
    required this.motherName,
    required this.newbornBraceletHand,
    required this.newbornBraceletLeg,
    required this.report,
    this.schedule = const [],
    required this.startTime,
    required this.endTime,
    required this.ministryOfHealthId,
    required this.hospitalId,
    required this.hospitalName,
    required this.doctorId,
    required this.doctorName,
    required this.ministryOfHealthName,
    this.image,
  });

  factory Midwife.fromJson(Map<String, dynamic> json) {
    return Midwife(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      salary: json['salary'] ?? 0,
      hours: json['hours'] ?? 0,
      report: json['report'] ?? '',
      newbornBraceletLeg: json['newborn_bracelet_leg'] ?? '',
      newbornBraceletHand: json['newborn_bracelet_hand'] ?? '',
      schedule: List<Map<String, String>>.from(json['schedule'] ?? []),
      startTime: json['startTime'] != null ? json['startTime'].toString() : '',
      endTime: json['endTime'] != null ? json['endTime'].toString() : '',
      communication: json['communication_skills'] ?? '',
      hospitalName: '',
      doctorName: '',
      ministryOfHealthName: '',
      ministryOfHealthId: json['ministry_of_health_id'] ?? 0,
      hospitalId: json['hospital_id'] ?? 1,
      doctorId: json['doctor_id'] ?? 0,
      motherName: json['mother_name'] ?? '',
      image: json['image'] != null ? File(json['image'] as String) : null,
    );
  }
}

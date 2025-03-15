import 'dart:io';

class Doctor {
  final int id;
  final String name;
  final String nurseName;
  final String midwifeName;
  final String specialization;
  final List<Map<String, String>> schedule;
  final String startTime;
  final String endTime;
  final String about;
  final int ministryOfHealthId;
  final int hospitalId;
  final String hospitalName;
  final String ministryOfHealthName;
  final String country;
  final String city;
  final String email;
  final String phone;
  File? image;
  final String salary;

  Doctor({
    required this.id,
    required this.name,
    required this.nurseName,
    required this.midwifeName,
    required this.specialization,
    this.schedule = const [],
    required this.startTime,
    required this.endTime,
    required this.about,
    required this.ministryOfHealthId,
    required this.hospitalId,
    required this.hospitalName,
    required this.ministryOfHealthName,
    required this.country,
    required this.city,
    required this.email,
    required this.phone,
    this.image,
    required this.salary,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      nurseName: json['nurseName'] ?? '',
      midwifeName: json['midwifeName'] ?? '',
      specialization: json['specialization'] ?? '',
      ministryOfHealthId: json['ministry_of_health_id'] ?? 0,
      hospitalId: json['hospital_id'] ?? 0,
      schedule: List<Map<String, String>>.from(json['schedule'] ?? []),
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      about: json['about'] ?? '',
      country: json['country'] ?? '',
      city: json['city'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      salary: json['salary'] ?? '',
      hospitalName: '',
      ministryOfHealthName: '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nurseName': nurseName,
      'midwifeName': midwifeName,
      'specialization': specialization,
      'ministry_of_health_id': ministryOfHealthId,
      'hospital_id': hospitalId,
      'schedule': schedule,
      'startTime': startTime,
      'endTime': endTime,
      'about': about,
      'country': country,
      'city': city,
      'email': email,
      'phone': phone,
      'salary': salary,
    };
  }
}

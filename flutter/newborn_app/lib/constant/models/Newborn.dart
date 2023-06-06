import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum Status { Normal, Abnormal }

enum Gender { Female, Male }

enum MethodOFDelivery { Normal, Vaccum, Forceps, C_S }

class Newborn {
  int id;
  String firstName;
  String lastName;
  DateTime dateOfBirth;
  TimeOfDay timeOfBirth;
  Gender gender;
  String identityNumber;
  double weight;
  double length;
  Status status;
  MethodOFDelivery deliveryMethod;
  String motherName;
  String hospitalCenterName;
  String ministryCenterName;
  String doctorName;
  String midwifeName;
  int motherid;
  int hospitalCenterid;
  int ministryCenterid;
  int doctorid;
  int midwifeid;

  Newborn({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.timeOfBirth,
    required this.gender,
    required this.identityNumber,
    required this.weight,
    required this.length,
    required this.status,
    required this.deliveryMethod,
    required this.motherName,
    required this.hospitalCenterName,
    required this.ministryCenterName,
    required this.doctorName,
    required this.midwifeName,
    required this.motherid,
    required this.hospitalCenterid,
    required this.ministryCenterid,
    required this.doctorid,
    required this.midwifeid,
  });

  factory Newborn.fromJson(Map<String, dynamic> json) => Newborn(
        id: json['id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        dateOfBirth: DateTime.parse(json['date_of_birth']),
        timeOfBirth:
            TimeOfDay.fromDateTime(DateTime.parse(json['time_of_birth'])),
        gender: Gender.values.firstWhere(
            (element) => element.toString() == 'gender.' + json['gender']),
        identityNumber: json['identity_number'],
        weight: json['weight'],
        length: json['length'],
        status: Status.values.firstWhere(
            (element) => element.toString() == 'status.' + json['status']),
        deliveryMethod: MethodOFDelivery.values.firstWhere((element) =>
            element.toString() == 'delivery_method.' + json['delivery_method']),
        doctorid: json['doctor_id'] ?? '',
        midwifeid: json['midwife_id'] ?? '',
        doctorName: '',
        hospitalCenterName: '',
        midwifeName: '',
        hospitalCenterid: json['hospital_center_id'] ?? 0,
        ministryCenterid: json['ministry_center_id'] ?? 0,
        ministryCenterName: '',
        motherName: '',
        motherid: json['mother_id'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'date_of_birth': dateOfBirth.toIso8601String(),
        'time_of_birth': DateFormat('h:mm a')
            .format(DateTime(0, 1, 1, timeOfBirth.hour, timeOfBirth.minute)),
        'gender': gender.toString().split('.').last,
        'identity_number': identityNumber,
        'weight': weight,
        'length': length,
        'status': status.toString().split('.').last,
        'delivery_method': deliveryMethod.toString().split('.').last,
        'mother_id': motherName,
        'hospital_center_id': hospitalCenterName,
        'ministry_center_id': ministryCenterName,
        'doctor_id': doctorName,
        'midwife_id': midwifeName,
      };
}

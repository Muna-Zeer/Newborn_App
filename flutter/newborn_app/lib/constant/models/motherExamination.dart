import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

enum MethodOfDelivery { Normal, Vaccum, Forceps, C_S }

enum PerinealTear { grade1, grade2, grade3, grade4 }

enum PlaceOfBirth { Home, Clinic, Hospital, Other }

class MotherExaminations {
  final String id;
  final String nameOfMother;
  final int age;
  final PlaceOfBirth placeOfBirth;
  final TimeOfDay timeOfDelivery;
  final DateTime dateOfDelivery;
  final String weeksOfPregnancy;
  final MethodOfDelivery methodOfDelivery;
  final bool episiotomy;
  final PerinealTear perinealTear;
  final bool bleedingAfterDelivery;
  final bool bloodTransfusion;
  final String temp;
  final String bp;
  final String complicationAfterDelivery;
  final String diagnosis;
  final String referred;
  String doctorName;
  String midwifeName;
  String nurseName;
  int doctorid;
  int midwifeid;
  int nurseid;
  final bool FirstBorn;
  final bool BP_Status;
  final int MotherWeight;
  final int StrengthOfBlood;
  MotherExaminations({
    required this.id,
    required this.nameOfMother,
    required this.age,
    required this.placeOfBirth,
    required this.timeOfDelivery,
    required this.dateOfDelivery,
    required this.weeksOfPregnancy,
    required this.methodOfDelivery,
    required this.episiotomy,
    required this.perinealTear,
    required this.bleedingAfterDelivery,
    required this.bloodTransfusion,
    required this.temp,
    required this.bp,
    required this.complicationAfterDelivery,
    required this.diagnosis,
    required this.referred,
    required this.doctorName,
    required this.midwifeName,
    required this.nurseName,
    required this.doctorid,
    required this.midwifeid,
    required this.nurseid,
    required this.FirstBorn,
    required this.BP_Status,
    required this.MotherWeight,
    required this.StrengthOfBlood,
  });
  Map<String, dynamic> toJson() => {
        'id': id,
        'name_of_mother': nameOfMother,
        'age': age,
        'place_of_birth': placeOfBirth.toString().split('.').last,
        'time_of_delivery': DateFormat('h:mm a').format(
            DateTime(0, 1, 1, timeOfDelivery.hour, timeOfDelivery.minute)),
        'date_of_delivery': dateOfDelivery.toIso8601String(),
        'weeks_of_pregnancy': weeksOfPregnancy,
        'method_of_delivery': methodOfDelivery.toString().split('.').last,
        'Episiotomy': episiotomy,
        'Perineal_Tear': perinealTear.toString().split('.').last,
        'Bleeding_after_delivery': bleedingAfterDelivery,
        'Blood_transfusion': bloodTransfusion,
        'Temp': temp,
        'B_P': bp,
        'Complication_after_delivery': complicationAfterDelivery,
        'Diagnosis': diagnosis,
        'Referred': referred,
        'doctor_id': doctorName,
        'midwife_id': midwifeName,
        'nurse_id': nurseName,
        'First_born': FirstBorn,
        'BP_Status': BP_Status,
        'Mother_weight': MotherWeight,
        'Strong_of_blood': StrengthOfBlood,
      };

  factory MotherExaminations.fromJson(Map<String, dynamic> json) {
    final timeOfDelivery =
        DateFormat('h:mm a').parse(json['time_of_delivery'], true);
    return MotherExaminations(
      id: json['id'],
      nameOfMother: json['name_of_mother'] ?? '',
      age: json['age'] ?? 0,
      placeOfBirth: PlaceOfBirth.values.firstWhere((element) =>
          element.toString() == 'place_of_birth.' + json['place_of_birth']),
      timeOfDelivery: TimeOfDay.fromDateTime(timeOfDelivery),
      dateOfDelivery: DateTime.parse(json['date_of_delivery']),
      weeksOfPregnancy: json['weeks_of_pregnancy'] ?? '',
      methodOfDelivery: MethodOfDelivery.values.firstWhere((element) =>
          element.toString() ==
          'methodOfDelivery.' + json['method_of_delivery']),
      episiotomy: json['Episiotomy'] ?? false,
      perinealTear: PerinealTear.values.firstWhere((element) =>
          element.toString() == 'Perineal_Tear.' + json['Perineal_Tear']),
      bleedingAfterDelivery: json['Bleeding_after_delivery'] ?? false,
      bloodTransfusion: json['Blood_transfusion'] ?? false,
      temp: json['Temp'] ?? '',
      bp: json['B_P'] ?? '',
      complicationAfterDelivery: json['Complication_after_delivery'] ?? '',
      diagnosis: json['Diagnosis'] ?? '',
      referred: json['Referred'] ?? '',
      doctorid: json['doctor_id'] ?? 0,
      midwifeid: json['midwife_id'] ?? 0,
      nurseid: json['nurse_id'] ?? 0,
      doctorName: '',
      midwifeName: '',
      nurseName: '',
      FirstBorn: json['First_born'] ?? false,
      BP_Status: json['BP_Status'] ?? false,
      MotherWeight: json['Mother_weight'] ?? 0,
      StrengthOfBlood: json['Strong_of_blood'] ?? 0,
    );
  }
}

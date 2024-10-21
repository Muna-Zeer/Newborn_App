import 'package:my_vaccine_app/screens/Newborns/NewbornClass.dart';

class Measurement {
  double height;
  double weight;
  double headCircumference;
  DateTime date;
  String time;
  String nurseName;
  String remarks;
  int age;
  String tonics;
  int newbornId;
  int nurseId;
  int midwifeId;
  int healthCenterId;
  int ministryId;
  int hospitalId;
  final Newborn newborn;

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
    required this.newborn,
  });

  Map<String, dynamic> toJson() {
    return {
      'height': height.toString(),
      'weight': weight.toString(),
      'head_circumference': headCircumference.toString(),
      'date': date.toIso8601String(),
      'time': time,
      'nurse_name': nurseName,
      'remarks': remarks,
      'age': age,
      'tonics': tonics,
      'newborn_id': newbornId.toString(),
      'nurse_id': nurseId.toString(),
      'midwife_id': midwifeId.toString(),
      'health_center_id': healthCenterId.toString(),
      'ministry_id': ministryId.toString(),
      'hospital_id': hospitalId.toString(),
    };
  }

  factory Measurement.fromJson(Map<String, dynamic> json) {
    return Measurement(
      height: _toDouble(json['height'] ?? 0.0),
      weight: _toDouble(json['weight'] ?? 0.0),
      headCircumference: _toDouble(json['head_circumference'] ?? 0.0),
      date:
          json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      time: json['time'] ?? '',
      nurseName: json['nurse_name'] ?? '',
      remarks: json['remarks'] ?? '',
      age: json['age'] ?? 0,
      tonics: json['tonics'] ?? '',
      newbornId: json['newborn_id'] != null
          ? (json['newborn_id'] is String
              ? int.tryParse(json['newborn_id']) ?? 0
              : json['newborn_id'])
          : 0,
      nurseId: json['nurse_id'] != null
          ? (json['nurse_id'] is String
              ? int.tryParse(json['nurse_id']) ?? 0
              : json['nurse_id'])
          : 0,
      midwifeId: json['midwife_id'] != null
          ? (json['midwife_id'] is String
              ? int.tryParse(json['midwife_id']) ?? 0
              : json['midwife_id'])
          : 0,
      healthCenterId: json['health_center_id'] != null
          ? (json['health_center_id'] is String
              ? int.tryParse(json['health_center_id']) ?? 0
              : json['health_center_id'])
          : 0,
      ministryId: json['ministry_id'] != null
          ? (json['ministry_id'] is String
              ? int.tryParse(json['ministry_id']) ?? 0
              : json['ministry_id'])
          : 0,
      hospitalId: json['hospital_id'] != null
          ? (json['hospital_id'] is String
              ? int.tryParse(json['hospital_id']) ?? 0
              : json['hospital_id'])
          : 0,
      newborn: json['newborn'] != null
          ? Newborn.fromJson(json['newborn'])
          : Newborn.empty(),
    );
  }

  static double _toDouble(dynamic value) {
    if (value is double) return value;
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}

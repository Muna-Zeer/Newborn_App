import 'package:collection/collection.dart';
import 'dart:core';

enum Method { Oral, Drops }

class Vaccine {
  int id;
  String name;
  int? doses;
  String place;
  String diseases;
  final Method? method;

  String monthVaccinations;
  int? newbornId;
  int? ministryId;
  bool? isSent;
  Vaccine({
    required this.id,
    required this.name,
    this.doses,
    required this.place,
    required this.diseases,
    required this.method,
    required this.monthVaccinations,
    this.isSent,
    this.newbornId,
    this.ministryId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'doses': doses,
      'place': place,
      'diseases': diseases,
      'method': method.toString().split('.').last,
      'month_vaccinations': monthVaccinations,
      'newborn_id': newbornId,
      'ministry_id': ministryId,
    };
  }

  factory Vaccine.fromJson(Map<String, dynamic> json) {
    return Vaccine(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      doses: json['doses'] ?? 0,
      place: json['place'] ?? '',
      diseases: json['diseases'] ?? '',
      method: json['method'] != null
          ? Method.values.firstWhereOrNull(
              (element) => element.toString() == 'Method.' + json['method'])
          : null,
      monthVaccinations: json['month_vaccinations'],
      newbornId: json['newborn_id'] ?? 1,
      ministryId: json['ministry_id'] ?? 1,
    );
  }
}

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  DateTime? vaccinationDate; // Added field for vaccination date

  Vaccine({
    required this.id,
    required this.name,
    this.doses,
    required this.place,
    required this.diseases,
    required this.method,
    required this.monthVaccinations,
    this.newbornId,
    this.ministryId,
    this.vaccinationDate, // Added field for vaccination date
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
      'vaccination_date': vaccinationDate != null
          ? vaccinationDate!
              .toIso8601String() // Convert date to ISO 8601 format for JSON serialization
          : null,
    };
  }

  factory Vaccine.fromJson(Map<String, dynamic> json) {
    return Vaccine(
      id: json['id'],
      name: json['name'],
      doses: json['doses'],
      place: json['place'],
      diseases: json['diseases'],
      method: Method.values.firstWhereOrNull(
          (element) => element.toString() == 'Method.' + json['method']),
      monthVaccinations: json['month_vaccinations'],
      newbornId: json['newborn_id'],
      ministryId: json['ministry_id'],
      vaccinationDate: DateTime.tryParse(json[
          'vaccination_date']), // Parse ISO 8601 date string back to DateTime
    );
  }
}

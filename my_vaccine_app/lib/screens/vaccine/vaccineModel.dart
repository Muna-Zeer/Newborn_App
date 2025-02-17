class VaccineData {
  final DateTime? dueDate;
  final bool taken;
  final bool notified;
  final String identityNumber;
  final int overdueDays;
  final String vaccineName;
  final DateTime vaccinateDate;

  final String doctorName;
  VaccineData({
    required this.vaccineName,
    required this.dueDate,
    required this.overdueDays,
    required this.notified,
    required this.taken,
    required this.vaccinateDate,
    required this.identityNumber,
    required this.doctorName,
  });

  factory VaccineData.fromJson(Map<String, dynamic> json) {
    return VaccineData(
      identityNumber: json["identity_number"],
      vaccineName: json["vaccineName"],
      dueDate:
          json["due_date"] != null ? DateTime.tryParse(json["due_date"]) : null,
      overdueDays: json["overdue_days"] ?? 0,
      notified: json["notified"] ?? false,
      taken: json["taken"] ?? false,
      vaccinateDate: json["vaccination_date"] != null
          ? DateTime.tryParse(json["vaccination_date"]) ?? DateTime(2000, 1, 1)
          : DateTime(2000, 1, 1),
      doctorName: json["doctor_name"] ?? "Unknown",
    );
  }
}

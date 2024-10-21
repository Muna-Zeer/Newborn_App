class Newborn {
  final String identityNumber;
  final int id;
  final String firstName;
  final String lastName;
  final String dateOfBirth;
  final String timeOfBirth;
  final String gender;
  final String weight;
  final String length;
  final String status;
  final String deliveryMethod;
  final int motherId;
  final dynamic locationId;
  final dynamic healthCenterId;
  final dynamic hospitalCenterId;
  final dynamic measurementId;
  final dynamic ministryCenterId;
  final dynamic doctorId;
  final dynamic nurseId;
  final dynamic midwifeId;
  final dynamic newbornHospitalNurseryId;
  bool vaccineReceived;
  Newborn({
    required this.identityNumber,
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.timeOfBirth,
    required this.gender,
    required this.weight,
    required this.length,
    required this.status,
    required this.deliveryMethod,
    required this.motherId,
    required this.locationId,
    required this.healthCenterId,
    required this.hospitalCenterId,
    required this.measurementId,
    required this.ministryCenterId,
    required this.doctorId,
    required this.nurseId,
    required this.midwifeId,
    required this.newbornHospitalNurseryId,
    this.vaccineReceived = false,
  });

  factory Newborn.fromJson(Map<String, dynamic> json) {
    return Newborn(
      identityNumber: json['identity_number'] ?? "",
      id: json['id'],
      firstName: json['firstName'] ?? "",
      lastName: json['lastName'] ?? "",
      dateOfBirth: json['date_of_birth'] ?? "",
      timeOfBirth: json['time_of_birth'] ?? "",
      gender: json['gender'] ?? "",
      weight: json['weight'] ?? "",
      length: json['length'] ?? "",
      status: json['status'] ?? "",
      deliveryMethod: json['delivery_method'] ?? "",
      motherId: json['mother_id'] != null
          ? (json['mother_id'] is String
              ? int.tryParse(json['mother_id']) ?? 0
              : json['mother_id'])
          : 0,
      locationId: json['location_id'] ?? 0,
      healthCenterId: json['health_center_id'],
      hospitalCenterId: json['hospital_center_id'],
      measurementId: json['measurement_id'],
      ministryCenterId: json['ministry_center_id'],
      doctorId: json['doctor_id'],
      nurseId: json['nurse_id'],
      midwifeId: json['midwife_id'],
      newbornHospitalNurseryId: json['newborn_hospital_nursery_id'],
      vaccineReceived: json['vaccine_received'] is bool
          ? json['vaccine_received']
          : (json['vaccine_received'] == 1),
    );
  }
  factory Newborn.empty() {
    return Newborn(
        identityNumber: "",
        id: 0,
        firstName: "",
        lastName: "",
        dateOfBirth: "",
        timeOfBirth: "",
        gender: "",
        weight: "",
        length: "",
        status: "",
        deliveryMethod: "",
        motherId: 0,
        locationId: 0,
        healthCenterId: 0,
        hospitalCenterId: 0,
        measurementId: 0,
        ministryCenterId: 0,
        doctorId: 0,
        nurseId: 0,
        midwifeId: 0,
        newbornHospitalNurseryId: 0);
  }
}

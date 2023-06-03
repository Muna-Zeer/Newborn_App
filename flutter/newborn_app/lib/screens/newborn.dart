class Newborn {
  final String motherName;
  final String newbornName;
  final String gender;
  final String dateOfBirth;
  final String timeOfBirth;
  final String weight;
  final String status;
  final String identityNumber;

  Newborn({
    required this.motherName,
    required this.newbornName,
    required this.gender,
    required this.dateOfBirth,
    required this.timeOfBirth,
    required this.weight,
    required this.status,
    required this.identityNumber,
  });

  factory Newborn.fromJson(Map<String, dynamic> json) {
    return Newborn(
      motherName: json['mother_name'],
      newbornName: json['newborn_name'],
      gender: json['gender'],
      dateOfBirth: json['date_of_birth'],
      timeOfBirth: json['time_of_birth'],
      weight: json['weight'],
      status: json['status'],
      identityNumber: json['identity_number'],
    );
  }

  num getWeightAsNum() {
    return num.parse(weight);
  }
}

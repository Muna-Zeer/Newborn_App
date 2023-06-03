enum BloodType { A, B, AB, O }

enum RhesusFactor { Positive, Negative }

class Mother {
  // final int id;
  final String firstName;
  final String lastName;
  final String address;
  final String phoneNumber;
  final String email;
  final DateTime dateOfBirth;
  final String husbandName;
  final String identityNumber;
  final String husbandPhoneNumber;
  final int numberOfNewborns;
  final String city;
  final String country;
  final BloodType bloodType;
  final RhesusFactor rhesusFactor;
  final int age;
  final String ministryName;
  final String hospitalCenterName;
  final String doctorName;
  final String nurseName;
  final String newbornName;
  Mother({
    // required this.id,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.phoneNumber,
    required this.email,
    required this.dateOfBirth,
    required this.husbandName,
    required this.identityNumber,
    required this.husbandPhoneNumber,
    required this.numberOfNewborns,
    required this.city,
    required this.country,
    required this.bloodType,
    required this.rhesusFactor,
    required this.age,
    required this.ministryName,
    required this.hospitalCenterName,
    required this.doctorName,
    required this.nurseName,
    required this.newbornName,
  });
  Map<String, dynamic> toJson() => {
        // 'id': id,
        'first_name': firstName,
        'last_name': lastName,
        'address': address,
        'phone_number': phoneNumber,
        'email': email,
        'date_of_birth': dateOfBirth.toIso8601String(),
        'husband_name': husbandName,
        'identity_number': identityNumber,
        'husband_phone_number': husbandPhoneNumber,
        'number_of_newborns': numberOfNewborns,
        'city': city,
        'country': country,
        'blood_type': bloodType.toString().split('.').last,
        'rhesusFactor': rhesusFactor.toString().split('.').last,
        'age': age,
        'ministry_name': ministryName,
        'hospital_center_name': hospitalCenterName,
        'doctor_name': doctorName,
        'nurse_name': nurseName,
        'newborn_name': nurseName,
      };

  factory Mother.fromJson(Map<String, dynamic> json) {
    return Mother(
      // id: json['id'],
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      address: json['address'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      email: json['email'] ?? '',
      dateOfBirth: DateTime.parse(json['date_of_birth']),
      husbandName: json['husband_name'] ?? '',
      identityNumber: json['identity_number'] ?? '',
      husbandPhoneNumber: json['husband_phone_number'] ?? '',
      numberOfNewborns: json['number_of_newborns'] ?? 0,
      city: json['city'] ?? '',
      country: json['country'] ?? '',
      bloodType: BloodType.values.firstWhere(
          (element) => element.toString() == 'blood_type' + json['blood_type']),
      rhesusFactor: RhesusFactor.values.firstWhere((element) =>
          element.toString() == 'rhesusFactor' + json['rhesusFactor']),
      age: json['age'] ?? 0,
      ministryName: json['ministry_name'] ?? '',
      hospitalCenterName: json['hospital_center_name'] ?? '',
      doctorName: json['doctor_name'] ?? '',
      nurseName: json['nurse_name'] ?? '',
      newbornName: json['newborn_name'] ?? '',
    );
  }
}

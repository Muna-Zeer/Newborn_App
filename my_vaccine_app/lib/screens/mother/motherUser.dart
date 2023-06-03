class MotherUser {
  String password;
  String phone;
  String username;
  String identityNumber;

  MotherUser({
    required this.password,
    required this.phone,
    required this.username,
    required this.identityNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'password': password,
      'phone': phone,
      'username': username,
      'identity_number': identityNumber,
    };
  }
}

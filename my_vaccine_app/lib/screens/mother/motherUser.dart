class MotherUser {
  String password;
  String phone;
  String username;
  String identityNumber;
  String device_token;
  MotherUser({
    required this.password,
    required this.phone,
    required this.username,
    required this.identityNumber,
    required this.device_token,
  });

  Map<String, dynamic> toJson() {
    return {
      'password': password,
      'phone': phone,
      'username': username,
      'identity_number': identityNumber,
      'device_token': device_token,
    };
  }
}

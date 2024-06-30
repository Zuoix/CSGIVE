class RegisterRequest {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String phone;
  final String churchId;
  final String roleType;
  final String fcmToken;

  final String countryCode;

  RegisterRequest({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.churchId,
    this.roleType = 'normal',
    required this.fcmToken, required this.countryCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'churchId': churchId,
      'roleType': roleType,
      'fcm_token': fcmToken,
      'countryCode': countryCode,
    };
  }
}

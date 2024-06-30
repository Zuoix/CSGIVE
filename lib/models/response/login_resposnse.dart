class LoginResponse {
  final String token;
  final String statusCode;
  final String message;

  LoginResponse({
    required this.token,
    required this.statusCode,
    required this.message,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'],
      statusCode: json['status_code'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'status_code': statusCode,
      'message': message,
    };
  }
}

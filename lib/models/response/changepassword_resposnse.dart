class ChangepasswordResponse {
  final String statusCode;
  final String message;
  final String reason;

  ChangepasswordResponse({
    required this.statusCode,
    required this.message,
    required this.reason,
  });

  factory ChangepasswordResponse.fromJson(Map<String, dynamic> json) {
    return ChangepasswordResponse(
      statusCode: json['status_code'],
      message: json['message'],
      reason: json['reason'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status_code': statusCode,
      'message': message,
      'reason': reason,
    };
  }
}

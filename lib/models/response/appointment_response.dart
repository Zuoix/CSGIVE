class AppointmentResponse {
  final String statusCode;
  final String message;
  final String reason;

  AppointmentResponse({
    required this.statusCode,
    required this.message,
    required this.reason,
  });

  factory AppointmentResponse.fromJson(Map<String, dynamic> json) {
    return AppointmentResponse(
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

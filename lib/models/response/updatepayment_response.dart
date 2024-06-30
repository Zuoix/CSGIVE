import 'package:intl/intl.dart';

class UpdatePaymentResponse {
  final String message;
  final String status;



  UpdatePaymentResponse({
    required this.message,
    required this.status,
  });

  factory UpdatePaymentResponse.fromJson(Map<String, dynamic> json) {
    return UpdatePaymentResponse(
      message: json['message'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'status': status,
    };
  }
}

import 'package:intl/intl.dart';

class CheckPaymentStatusResponse {
  final String message;
  final String status;



  CheckPaymentStatusResponse({
    required this.message,
    required this.status,
  });

  factory CheckPaymentStatusResponse.fromJson(Map<String, dynamic> json) {
    return CheckPaymentStatusResponse(
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

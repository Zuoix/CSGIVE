import 'package:intl/intl.dart';

class InitPaymentResponse {
  final String paymentUrl;
  final String reference;
  final String status;



  InitPaymentResponse({
    required this.paymentUrl,
    required this.reference,
    required this.status,
  });

  factory InitPaymentResponse.fromJson(Map<String, dynamic> json) {
    DateFormat dateFormat = DateFormat('MMMM d, yyyy');
    return InitPaymentResponse(
      paymentUrl: json['paymentUrl'],
      reference: json['reference'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    DateFormat dateFormat = DateFormat('MMMM d, yyyy');
    return {
      'paymentUrl': paymentUrl,
      'reference': reference,
      'status': status,
    };
  }
}

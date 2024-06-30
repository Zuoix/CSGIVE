import 'package:intl/intl.dart';

class DonationhistoryResponse {
  final String paymentMode;
  final String amount;
  final String statusMessage;
  final String pageId;
  final String? paymentReference;
  final String donationType;
  final DateTime createdAt;



  DonationhistoryResponse({
    required this.paymentMode,
    required this.amount,
    required this.statusMessage,
    required this.pageId,
    required this.paymentReference,
    required this.donationType,
    required this.createdAt,
  });

  factory DonationhistoryResponse.fromJson(Map<String, dynamic> json) {
    DateFormat dateFormat = DateFormat('MMMM d, yyyy');
    return DonationhistoryResponse(
      paymentMode: json['paymentMode'],
      amount: json['amount'],
      statusMessage: json['statusMessage'],
      pageId: json['pageId'],
      paymentReference: json['paymentReference'],
      donationType: json['donationType'],
      createdAt: dateFormat.parse(json['createdAt']), // Parse DateTime
    );
  }

  Map<String, dynamic> toJson() {
    DateFormat dateFormat = DateFormat('MMMM d, yyyy');
    return {
      'paymentMode': paymentMode,
      'amount': amount,
      'statusMessage': statusMessage,
      'pageId': pageId,
      'paymentReference': paymentReference,
      'donationType': donationType,
      'createdAt': dateFormat.format(createdAt), // Format DateTime
    };
  }
}

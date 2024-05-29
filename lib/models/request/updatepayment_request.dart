class UpdatePaymentRequest {
  final String status;
  final String data;
  final String statusMessage;

  UpdatePaymentRequest({
    required this.status,
    required this.data,
    required this.statusMessage,
  });

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data,
      'statusMessage': statusMessage,
    };
  }
}

class InitPaymentRequest {
  final String amount;
  final String donationType;
  final String paymentMode;

  InitPaymentRequest({
    required this.amount,
    required this.donationType,
    required this.paymentMode,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'donationType': donationType,
      'paymentMode': paymentMode,
    };
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MobileMoneyRequest {
  final String depositId;
  final String returnUrl;
  final String? statementDescription;
  final String? amount;
  final String? msisdn;
  final String? reason;

  MobileMoneyRequest({
    required this.depositId,
    required this.returnUrl,
    this.statementDescription,
    this.amount,
    this.msisdn,
    this.reason,
  });

  MobileMoneyRequest copyWith({
    String? depositId,
    String? returnUrl,
    String? statementDescription,
    String? amount,
    String? msisdn,
    String? reason,
  }) {
    return MobileMoneyRequest(
      depositId: depositId ?? this.depositId,
      returnUrl: returnUrl ?? this.returnUrl,
      statementDescription: statementDescription ?? this.statementDescription,
      amount: amount ?? this.amount,
      msisdn: msisdn ?? this.msisdn,
      reason: reason ?? this.reason,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'depositId': depositId,
      'returnUrl': returnUrl,
      if (statementDescription != null)
        'statementDescription': statementDescription,
      if (amount != null) 'amount': amount,
      if (msisdn != null) 'msisdn': msisdn,
      if (reason != null) 'reason': reason,
    };
  }

  factory MobileMoneyRequest.fromMap(Map<String, dynamic> map) {
    return MobileMoneyRequest(
      depositId: map['depositId'] as String,
      returnUrl: map['returnUrl'] as String,
      statementDescription: map['statementDescription'] != null
          ? map['statementDescription'] as String
          : null,
      amount: map['amount'] != null ? map['amount'] as String : null,
      msisdn: map['msisdn'] != null ? map['msisdn'] as String : null,
      reason: map['reason'] != null ? map['reason'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MobileMoneyRequest.fromJson(String source) =>
      MobileMoneyRequest.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StockRequest(depositId: $depositId, returnUrl: $returnUrl, statementDescription: $statementDescription, amount: $amount, msisdn: $msisdn, reason: $reason)';
  }

  @override
  bool operator ==(covariant MobileMoneyRequest other) {
    if (identical(this, other)) return true;

    return other.depositId == depositId &&
        other.returnUrl == returnUrl &&
        other.statementDescription == statementDescription &&
        other.amount == amount &&
        other.msisdn == msisdn &&
        other.reason == reason;
  }

  @override
  int get hashCode {
    return depositId.hashCode ^
        returnUrl.hashCode ^
        statementDescription.hashCode ^
        amount.hashCode ^
        msisdn.hashCode ^
        reason.hashCode;
  }
}

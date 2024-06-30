class DepositStatus {
  String depositId;
  String status;
  String requestedAmount;
  String depositedAmount;
  String currency;
  String country;
  Payer payer;
  String correspondent;
  String statementDescription;
  String customerTimestamp;
  String created;
  String? respondedByPayer;
  Map<String, String> correspondentIds;

  DepositStatus({
    required this.depositId,
    required this.status,
    required this.requestedAmount,
    required this.depositedAmount,
    required this.currency,
    required this.country,
    required this.payer,
    required this.correspondent,
    required this.statementDescription,
    required this.customerTimestamp,
    required this.created,
    this.respondedByPayer,
    required this.correspondentIds,
  });

  factory DepositStatus.fromJson(Map<String, dynamic> json) {
    return DepositStatus(
      depositId: json['depositId'],
      status: json['status'],
      requestedAmount: json['requestedAmount'],
      depositedAmount: json['depositedAmount'],
      currency: json['currency'],
      country: json['country'],
      payer: Payer.fromJson(json['payer']),
      correspondent: json['correspondent'],
      statementDescription: json['statementDescription'],
      customerTimestamp: json['customerTimestamp'],
      created: json['created'],
      respondedByPayer: json['respondedByPayer'],
      correspondentIds: Map<String, String>.from(json['correspondentIds']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'depositId': depositId,
      'status': status,
      'requestedAmount': requestedAmount,
      'depositedAmount': depositedAmount,
      'currency': currency,
      'country': country,
      'payer': payer.toJson(),
      'correspondent': correspondent,
      'statementDescription': statementDescription,
      'customerTimestamp': customerTimestamp,
      'created': created,
      'respondedByPayer': respondedByPayer,
      'correspondentIds': correspondentIds,
    };
  }
}

class Payer {
  String type;
  Address address;

  Payer({
    required this.type,
    required this.address,
  });

  factory Payer.fromJson(Map<String, dynamic> json) {
    return Payer(
      type: json['type'],
      address: Address.fromJson(json['address']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'address': address.toJson(),
    };
  }
}

class Address {
  String value;

  Address({
    required this.value,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
    };
  }
}

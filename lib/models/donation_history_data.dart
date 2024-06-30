import 'dart:convert';

class DonationHistory {
  int id;
  int churchId;
  String donationType;
  DateTime createdAt;

  static List<DonationHistory> getLocalData() {
    return [
      DonationHistory(
        id: 1,
        churchId: 1,
        donationType: 'Disabled',
        createdAt: DateTime.now(),
      )
    ];
  }

  DonationHistory({
    required this.id,
    required this.churchId,
    required this.donationType,
    required this.createdAt,
  });

  factory DonationHistory.fromJson(Map<String, dynamic> json) {
    return DonationHistory(
      id: json['id'] as int,
      churchId: json['churchId'] as int,
      donationType: json['donationType'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'churchId': churchId,
      'donationType': donationType,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }

  factory DonationHistory.fromJsonString(String jsonString) {
    return DonationHistory.fromJson(jsonDecode(jsonString));
  }
}

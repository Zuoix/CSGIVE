import 'dart:convert';

class DonationType {
  int id;
  int churchId;
  String donationType;
  DateTime createdAt;

  static List<DonationType> getLocalData() {
    return [
      DonationType(
        id: 1,
        churchId: 1,
        donationType: 'Disabled',
        createdAt: DateTime.now(),
      )
    ];
  }

  DonationType({
    required this.id,
    required this.churchId,
    required this.donationType,
    required this.createdAt,
  });

  factory DonationType.fromJson(Map<String, dynamic> json) {
    return DonationType(
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

  factory DonationType.fromJsonString(String jsonString) {
    return DonationType.fromJson(jsonDecode(jsonString));
  }
}

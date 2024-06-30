import 'dart:convert';

class NotificationType {
  int id;
  int churchId;
  String title;
  String body;
  String createdAt;
  String updatedAt;


  NotificationType({
    required this.id,
    required this.churchId,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationType.fromJson(Map<String, dynamic> json) {
    return NotificationType(
      id: json['id'] as int,
      churchId: json['churchId'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'churchId': churchId,
      'title': title,
      'body': body,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }

  factory NotificationType.fromJsonString(String jsonString) {
    return NotificationType.fromJson(jsonDecode(jsonString));
  }
}

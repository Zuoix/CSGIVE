import 'dart:convert';

class EventData {
  int id;
  String churchId;
  String title;
  String description;
  String eventVenue;
  String eventDate;
  String eventTime;
  String imageBanner;
  String createdAt;
  String updatedAt;

  EventData({
    required this.id,
    required this.churchId,
    required this.title,
    required this.description,
    required this.eventVenue,
    required this.eventDate,
    required this.eventTime,
    required this.imageBanner,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EventData.fromJson(Map<String, dynamic> json) {
    String banner = json['imageBanner'];

    if (!banner.startsWith('http')) {
      banner = 'http://$banner';
    }

    return EventData(
      id: json['id'],
      churchId: json['churchId'],
      title: json['title'],
      description: json['description'],
      eventVenue: json['eventVenue'],
      eventDate: json['eventDate'],
      eventTime: json['eventTime'],
      imageBanner: banner,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'churchId': churchId,
      'title': title,
      'description': description,
      'eventVenue': eventVenue,
      'eventDate': eventDate,
      'eventTime': eventTime,
      'imageBanner': imageBanner,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }

  factory EventData.fromJsonString(String jsonString) {
    return EventData.fromJson(jsonDecode(jsonString));
  }
}

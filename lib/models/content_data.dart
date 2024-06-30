import 'dart:convert';

class ContentData {
  int id;
  int churchId;
  String title;
  String contentType;
  String contentData;
  String audioThumbnail;
  String createdAt;
  String updatedAt;

  ContentData({
    required this.id,
    required this.churchId,
    required this.title,
    required this.contentType,
    required this.contentData,
    required this.audioThumbnail,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ContentData.fromJson(Map<String, dynamic> json) {
    return ContentData(
      id: json['id'],
      churchId: json['churchId'],
      title: json['title'],
      contentType: json['contentType'],
      contentData: json['contentData'],
      audioThumbnail: json['audioThumbnail'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'churchId': churchId,
      'title': title,
      'contentType': contentType,
      'contentData': contentData,
      'audioThumbnail': audioThumbnail,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }

  factory ContentData.fromJsonString(String jsonString) {
    return ContentData.fromJson(jsonDecode(jsonString));
  }
}

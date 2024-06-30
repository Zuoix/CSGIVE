
class LiveStreamModel {
  final int id;
  final int churchId;
  final String title;
  final String contentType;
  final String contentData;
  final String audioThumbnail;
  final DateTime createdAt;
  final DateTime updatedAt;

  LiveStreamModel({
    required this.id,
    required this.churchId,
    required this.title,
    required this.contentType,
    required this.contentData,
    required this.audioThumbnail,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LiveStreamModel.fromJson(Map<String, dynamic> json) {
    return LiveStreamModel(
      id: json['id'],
      churchId: json['churchId'],
      title: json['title'],
      contentType: json['contentType'],
      contentData: json['contentData'],
      audioThumbnail: json['audioThumbnail'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

import 'package:http/http.dart' as http;
import 'dart:convert';

class LiveStreamService {
  final String _baseUrl = 'https://yourapi.com'; // Replace with your actual base URL

  Future<List<LiveStream>> getLiveStreams() async {
    final response = await http.get(Uri.parse('$_baseUrl/livestreams'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<LiveStream> liveStreams = (data['data'] as List)
          .map((e) => LiveStream.fromJson(e))
          .toList();
      return liveStreams;
    } else {
      throw Exception('Failed to load live streams');
    }
  }
}

class LiveStream {
  final int id;
  final int churchId;
  final String title;
  final String contentType;
  final String contentData;
  final String audioThumbnail;
  final DateTime createdAt;
  final DateTime updatedAt;

  LiveStream({
    required this.id,
    required this.churchId,
    required this.title,
    required this.contentType,
    required this.contentData,
    required this.audioThumbnail,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LiveStream.fromJson(Map<String, dynamic> json) {
    return LiveStream(
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

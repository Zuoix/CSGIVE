import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../models/live_sream.dart';
import 'account/live_stream_screen.dart';

class LiveStreamYoutubeDetailScreen extends StatefulWidget {
  final LiveStreamModel liveStream;

  const LiveStreamYoutubeDetailScreen({Key? key, required this.liveStream})
      : super(key: key);

  @override
  _LiveStreamDetailScreenState createState() =>
      _LiveStreamDetailScreenState();
}

class _LiveStreamDetailScreenState extends State<LiveStreamYoutubeDetailScreen> {
  late VideoPlayerController _controller;
  late Timer _timer;
  bool _showYouTubeVideo = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }


  void _playLiveStream() {
    // Navigate to the live stream screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LiveStreamDetailScreen(liveStream: widget.liveStream), // Replace with your live stream screen
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final LiveStreamModel liveStream;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.liveStream.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_showYouTubeVideo)
            Expanded(
              child: YoutubePlayer(
                controller: YoutubePlayerController(
                  initialVideoId: YoutubePlayer.convertUrlToId(
                    "https://www.youtube.com/watch?v=kDYAoxl-t4g",
                  )!,
                ),
                showVideoProgressIndicator: true,
              ),
            ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _showYouTubeVideo = false;
              });
              _playLiveStream();
            },
            child: Text('Watch Live Stream'),
          ),
        ],
      ),
    );
  }
}

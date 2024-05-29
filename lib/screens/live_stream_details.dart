import 'dart:async';

import 'package:cs_give/core/utils/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../models/live_sream.dart';

class LiveStreamDetailScreen extends StatefulWidget {
  final LiveStreamModel liveStream;

  const LiveStreamDetailScreen({Key? key, required this.liveStream})
      : super(key: key);

  @override
  _LiveStreamDetailScreenState createState() => _LiveStreamDetailScreenState();
}

class _LiveStreamDetailScreenState extends State<LiveStreamDetailScreen> {
  late VideoPlayerController _controller;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
    _startTimer();
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _initializeVideoPlayer() {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.liveStream.contentData))
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  void _startTimer() {
    const duration = Duration(seconds: 10); // Adjust the duration as needed
    _timer = Timer(duration, () {
      if (!_controller.value.isInitialized) {
        // Navigate to YouTube video
        // For demonstration purposes, we're just printing a message here
        print('Stream not loaded, navigating to YouTube video');
        showError('Stream not loaded, navigating to YouTube video');
        // Navigate to the YouTube video page
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => YouTubeVideoScreen(),
        //   ),
        // );
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.liveStream.title),
      ),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        )
            : CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}

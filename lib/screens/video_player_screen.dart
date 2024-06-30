// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chewie/chewie.dart';
import 'package:cs_give/models/content_data.dart';
import 'package:cs_give/widgets/app_scaffold.dart';
import 'package:cs_give/widgets/loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final ContentData video;
  const VideoPlayerScreen({
    Key? key,
    required this.video,
  }) : super(key: key);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  ChewieController? chewieController;
  late VideoPlayerController videoPlayerController;

  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.video.contentData));

    await videoPlayerController.initialize();

    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      looping: true,
    );
    setState(() {});
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        appBar: AppBar(),
        body: chewieController != null
            ? SafeArea(child: Chewie(controller: chewieController!))
            : const LoaderWidget());
  }
}

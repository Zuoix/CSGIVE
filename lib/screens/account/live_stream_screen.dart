import 'package:cs_give/screens/live_stream_tube_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cs_give/core/theme/colors.dart';
import 'package:cs_give/core/utils/common.dart';
import 'package:cs_give/widgets/app_scaffold.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../controller/live_stream_controller.dart';
import '../../models/live_sream.dart';
import '../../widgets/app_texts.dart';
import 'package:video_player/video_player.dart';

class LiveStreamScreen extends StatefulWidget {
  const LiveStreamScreen({super.key});

  @override
  State<LiveStreamScreen> createState() => _LiveStreamScreenState();
}

class _LiveStreamScreenState extends State<LiveStreamScreen> {
  @override
  void initState() {
    super.initState();
    Get.put(LiveStreamController());
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LiveStreamController>(
      builder: (controller) {
        return AppScaffold(
          appBar: AppBar(
            toolbarHeight: getHeaderSize(context),
            centerTitle: true,
            leading: const SizedBox(),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                color: kSecondaryColor,
                borderRadius: radiusOnly(bottomLeft: 20, bottomRight: 20),
              ),
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (Navigator.canPop(context))
                    Row(
                      children: [
                        Container(
                          decoration: boxDecorationWithRoundedCorners(
                            boxShape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () => pop(context),
                            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                          ),
                        ).paddingRight(20),
                        Text(
                          'Live Stream',
                          style: boldText(
                              weight: FontWeight.w600, size: 22, color: white),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                  else
                    Text(
                      'Live Stream',
                      style: boldText(
                          weight: FontWeight.w600, size: 22, color: white),
                      textAlign: TextAlign.center,
                    ),
                  10.height,
                ],
              ),
            ),
          ),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: controller.refreshLiveStreams,
              child: Obx(
                    () => controller.isLoading.value
                    ? Center(child: CircularProgressIndicator())
                    : controller.liveStreams.isEmpty
                    ? Center(
                  child: Text(
                    'No live streams available',
                    style: boldText(
                        weight: FontWeight.w400, size: 18, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                )
                    : ListView.builder(
                  itemCount: controller.liveStreams.length,
                  itemBuilder: (context, index) {
                    return LiveStreamTile(
                      liveStream: controller.liveStreams[index],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class LiveStreamTile extends StatelessWidget {
  final LiveStreamModel liveStream;

  const LiveStreamTile({Key? key, required this.liveStream}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => LiveStreamYoutubeDetailScreen(liveStream: liveStream));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Image.network(
              liveStream.audioThumbnail,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    liveStream.title,
                    style: boldText(
                        weight: FontWeight.w600, size: 18, color: black),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Live Stream',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LiveStreamDetailScreen extends StatefulWidget {
  final LiveStreamModel liveStream;

  const LiveStreamDetailScreen({Key? key, required this.liveStream}) : super(key: key);

  @override
  _LiveStreamDetailScreenState createState() => _LiveStreamDetailScreenState();
}

class _LiveStreamDetailScreenState extends State<LiveStreamDetailScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.liveStream.contentData))
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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

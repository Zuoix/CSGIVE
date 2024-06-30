// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cs_give/app.dart';
import 'package:cs_give/core/theme/colors.dart';
import 'package:cs_give/core/utils/common.dart';
import 'package:cs_give/models/content_data.dart';
import 'package:cs_give/screens/video_player_screen.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:timeago/src/timeago.dart' as timeago;

import '../widgets/app_scaffold.dart';
import '../widgets/app_texts.dart';

class VideoAll extends StatefulWidget {
  const VideoAll({super.key});

  @override
  State<VideoAll> createState() => _VideoAll();
}

class _VideoAll extends State<VideoAll> {

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

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
                        icon:
                        const Icon(Icons.arrow_back_ios_new, size: 20),
                      ),
                    ).paddingRight(20),
                    Text(
                      'Videos',
                      style: boldText(
                          weight: FontWeight.w600, size: 22, color: white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
              else
                Text(
                  'Donation',
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
          child: AnimatedScrollView(
            children: [

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Videos',
                          style: boldText(size: 18),
                        ),
                      ],
                    ),
                    SnapHelperWidget(
                      future: dashboardServices.getVideos(),
                      onSuccess: (data) {
                        return SizedBox(
                          child: AnimatedListView(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: data.length,
                            itemBuilder: (p0, p1) {
                              return VideoTile(video: data[p1]);
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ).paddingSymmetric(horizontal: 15),
      ),
    );
  }

}

class VideoTile extends StatelessWidget {
  final ContentData video;
  const VideoTile({Key? key, required this.video,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        VideoPlayerScreen(video: video).launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 15),
        height: 80,
        child: Row(
          children: [
            Image.asset(
              'assets/images/demo_event.png',
              height: 80,
              width: 80,
              fit: BoxFit.cover,
            ).cornerRadiusWithClipRRect(10),
            15.width,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  video.title,
                  style: boldText(size: 16),
                ),
                Row(
                  children: [
                    // Text(
                    //   'HoG Sermons',
                    //   style: primaryText(size: 14, weight: FontWeight.w600),
                    // ),
                    // 5.width,
                    Text(
                      '• ${timeago.format(DateTime.parse(video.createdAt))}',
                      style: secondaryText(size: 14),
                    ),
                  ],
                )
              ],
            ).expand()
          ],
        ),
      ),
    );
  }
}

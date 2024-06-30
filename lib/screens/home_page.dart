// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cs_give/app.dart';
import 'package:cs_give/core/constants/app_constants.dart';
import 'package:cs_give/core/theme/colors.dart';
import 'package:cs_give/core/utils/common.dart';
import 'package:cs_give/models/content_data.dart';
import 'package:cs_give/screens/account/live_stream_screen.dart';
import 'package:cs_give/screens/dashboard/donation_screen.dart';
import 'package:cs_give/screens/video_all_screen.dart';
import 'package:cs_give/screens/video_player_screen.dart';
import 'package:cs_give/widgets/app_scroll_view.dart';
import 'package:cs_give/widgets/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:timeago/src/timeago.dart' as timeago;
import 'dashboard/notification_screen.dart';

class HomePage extends StatelessWidget {
   HomePage({super.key});




  @override
  Widget build(BuildContext context) {
    return AppScrollView(
      children: [
        const _EventHeader(),

        /// Video Section
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
                  InkWell(
                    onTap: () {
                      VideoAll().launch(context);
                    },
                    child: Row(
                      children: [
                        Text(
                          'See All',
                          style: primaryText(size: 16),
                        ),
                        5.width,
                        const Icon(Icons.arrow_forward_ios_outlined)
                      ],
                    ),
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

        // Live Stream
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Live Stream',
                    style: boldText(size: 18),
                  ),
                  InkWell(
                    onTap: () {
                      LiveStreamScreen().launch(context);
                    },
                    child: Text(
                      'Join Now',
                      style: primaryText(size: 16),
                    ),
                  ),
                ],
              ),
              const LiveStreamWidget()
            ],
          ),
        ),
      ],
    );
  }
}

class LiveStreamWidget extends StatelessWidget {
  const LiveStreamWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset('assets/images/demo_livestream.png')
            .cornerRadiusWithClipRRect(10)
            .paddingSymmetric(vertical: 10),
        Row(
          children: [
            Image.asset('assets/icons/ic_livestream.png'),
            10.width,
            Text(
              'Live Event: The Sermon',
              style: primaryText(size: 16),
            ),
          ],
        )
      ],
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

class _EventHeader extends StatelessWidget {
  const _EventHeader();

  @override
  Widget build(BuildContext context) {
    return SnapHelperWidget(
      initialData: cachedEvents,
      future: eventServices.getUpcomingEvents(),
      onSuccess: (events) {
        return Stack(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 472,
                viewportFraction: 1,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 10),
              ),
              items: events.map((e) {
                return Builder(
                  builder: (BuildContext context) {
                    return SizedBox(
                      height: 472,
                      width: context.width(),
                      child: Stack(
                        children: [
                          Image.network(
                            e.imageBanner,
                            fit: BoxFit.fitWidth,
                            width: context.width(),
                          ),
                          Opacity(
                            opacity: 0.7,
                            child: Image.asset(
                              'assets/images/mask.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            bottom: 130,
                            left: 20,
                            child: Chip(
                              label: Text(e.eventVenue),
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                          Positioned(
                            bottom: 60,
                            left: 20,
                            right: 20,
                            child: Text(
                              e.title,
                              style: boldText(
                                  weight: FontWeight.w700,
                                  size: 20,
                                  color: whiteColor),
                            ),
                          ),
                          Positioned(
                            bottom: 20,
                            left: 20,
                            right: 20,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${e.eventDate} / ${e.eventTime}',
                                  style: primaryText(color: whiteColor),
                                ),
                                InkWell(
                                  onTap: () {
                                    setValue(LocalKeys.kDonateTo,
                                        e.churchId.toInt());
                                    const DonationScreen().launch(context,
                                        pageRouteAnimation:
                                            PageRouteAnimation.Fade);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: whiteColor,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      'Give',
                                      style: primaryText(color: blackColor),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            Positioned(
              top: kToolbarHeight,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    getGreeting(),
                    style: boldText(
                        weight: FontWeight.w700, size: 20, color: whiteColor),
                  ),

                  InkWell(
                    onTap: () {
                      // Navigate to the notification page
                      // Replace 'NotificationPage()' with the desired page
                      NotificationScreen().launch(context);
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        color: whiteColor,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(10),
                      child: const Icon(
                        Icons.notifications,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                  /*Container(
                    decoration: const BoxDecoration(
                      color: whiteColor,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(10),
                    child: const Icon(
                      Icons.notifications,
                      color: kPrimaryColor,
                    ),
                  ),*/
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

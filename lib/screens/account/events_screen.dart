import 'package:cs_give/controller/event_controller.dart';
import 'package:cs_give/core/theme/colors.dart';
import 'package:cs_give/core/utils/common.dart';
import 'package:cs_give/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../widgets/app_texts.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  @override
  void initState() {
    super.initState();
    Get.put(EventController());
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EventController>(
      builder: (c) {
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
                          'Events',
                          style: boldText(
                              weight: FontWeight.w600, size: 22, color: white),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                  else
                    Text(
                      'Events',
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
                if (c.events.isNotEmpty)
                  Container(
                      child: Column(
                            children: [
                              ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: c.events.length,
                                itemBuilder: (context, index) {
                                  var event = c.events[index];
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(15)),
                                          child: Image.network(
                                            event.imageBanner,
                                            height: 150,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                event.title,
                                                style: boldText(
                                                    weight: FontWeight.w600,
                                                    size: 20,
                                                    color: black),
                                              ),
                                              5.height,
                                              Text(
                                                '${event.eventDate} - ${event.eventTime}',
                                                style: boldText(
                                                    weight: FontWeight.w400,
                                                    size: 14,
                                                    color: grey),
                                              ),
                                              10.height,
                                              Text(
                                                event.description,
                                                style: boldText(
                                                    weight: FontWeight.w400,
                                                    size: 16,
                                                    color: black),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ]
                      )),
                if (c.events.isEmpty)
                  Container(
                    child: Column(
                      children: [
                        Center(
                          child:
                              Image.asset('assets/images/empty_events_area.png')
                                  .paddingSymmetric(horizontal: 15)
                                  .paddingSymmetric(vertical: 20),
                        ),
                        10.height,
                        Center(
                          child: Text(
                            'Events',
                            style: boldText(
                                weight: FontWeight.w600,
                                size: 22,
                                color: black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        2.height,
                        Center(
                          child: Text(
                            'All of House of Glory Ministries -  MN\’s events will appear here',
                            style: boldText(
                                weight: FontWeight.w400,
                                size: 16,
                                color: black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  )
              ],
            ).paddingSymmetric(horizontal: 15),
          ),
        );
      },
    );
  }
}


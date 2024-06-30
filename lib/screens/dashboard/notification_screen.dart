import 'package:cs_give/controller/notification_controller.dart';
import 'package:cs_give/core/theme/colors.dart';
import 'package:cs_give/core/utils/common.dart';
import 'package:cs_give/widgets/app_scaffold.dart';
import 'package:cs_give/widgets/app_scroll_view.dart';
import 'package:cs_give/widgets/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:timeago/src/timeago.dart' as timeago;

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {


  @override
  void initState() {
    super.initState();
    Get.put(NotificationController());
  }


  Future<void> _refreshNotifications() async {
    try {
      await Get.find<NotificationController>().getNotifications();
      await Get.find<NotificationController>().getMessages();
    } catch (e) {
      // Handle error
      print("Error refreshing notifications: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
    length: 2,
    child: GetBuilder<NotificationController>(
      builder: (c) {
        return AppScaffold(
          appBar: AppBar(
            toolbarHeight: getHeaderSize(context),
            centerTitle: true,
            leading: const SizedBox(),
            elevation: 0,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(0),
              child: Container(),
            ),
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
                          'Notifications',
                          style: boldText(
                              weight: FontWeight.w600, size: 22, color: white),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                  else
                    Text(
                      'Notifications',
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
            child:  TabBarView(
              children: [
                _buildTabContent(c.notifications, 'notifications'),
                _buildTabContent(c.messages, 'messages'),
              ],
          ),
          ),
        );
      },
    )
    );
  }

  Widget _buildTabContent(List<dynamic> data, String type) {
    return RefreshIndicator(
      onRefresh: _refreshNotifications,
      child: AppScrollView(
        children: [
          // Tab for messages
          AnimatedScrollView(
            children: [
              20.height,
              Container(
                width: double.infinity, // Full width
                height: 57, // Adjust height as needed
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5), // Adjust padding as needed
                decoration: BoxDecoration(
                  color: Color(0xFFF4F4F4), // Background color
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TabBar(
                  tabs: [
                    Tab(text: 'Notifications'), // Tab for messages
                    Tab(text: 'Messages'), // Tab for notifications
                  ],
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorWeight: 0,
                  indicator:
                  BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Color(0xFF73B1EE),
                  ),
                  labelColor: Colors.white, // Text color for active tab
                  unselectedLabelColor: Colors.black, // Text color for inactive tabs
                  labelStyle: TextStyle(fontWeight: FontWeight.bold), // Font for active tab
                  unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal), // Font for inactive tabs
                  dividerHeight: 0,
                ),
              ),
              20.height,
              AppScrollView(
                children: [
                  if (data.isNotEmpty)
                    for (var i = 0; i < data.length; i++)
                      Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [Color(0xFFF5A42F), Color(0xFFF6129E)],
                                      stops: [0, 1],
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.notification_important,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            data[i].title,
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              color: Color(0xFF373743),
                                            ),
                                          ),
                                          Text(
                                            '• ${timeago.format(DateTime.parse(data[i].createdAt))}',
                                            style: TextStyle(
                                              fontFamily: 'Sofia Pro',
                                              fontWeight: FontWeight.w600,
                                              fontSize: 10,
                                              color: Color(0xFF898996),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        data[i].body,
                                        maxLines: 5,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: Color(0xFF373743),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (i != data.length - 1) Divider(), // Add Divider except for the last item
                        ],
                      ),
                  if (data.isEmpty)
                    Column(
                      children: [
                        Center(
                          child: Image.asset('assets/images/empty_notif_area.png')
                              .paddingSymmetric(horizontal: 15)
                              .paddingSymmetric(vertical: 20),
                        ),
                        10.height,
                        Center(
                          child: Text(
                            type == 'notifications' ? 'Notifications' : 'Messages',
                            style: boldText(
                                weight: FontWeight.w600, size: 22, color: black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        2.height,
                        Center(
                          child: Text(
                            type == 'notifications'
                                ? 'No notifications, refresh page or come back later to check'
                                : 'No messages, refresh page or come back later to check',
                            style: boldText(
                                weight: FontWeight.w400, size: 16, color: black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: Container(
                            width: 125,
                            height: 48,
                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Color(0xFF73B1EE),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Text(
                                'Refresh',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                ],
              ),


            ],
          ).paddingSymmetric(horizontal: 15),
          // Tab for notifications

        ],
      ),
    );
  }
}


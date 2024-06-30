import 'package:cs_give/core/theme/colors.dart';
import 'package:cs_give/core/utils/common.dart';
import 'package:cs_give/widgets/app_scaffold.dart';
import 'package:cs_give/widgets/app_scroll_view.dart';
import 'package:cs_give/widgets/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../core/constants/images.dart';

class ContactusScreen extends StatefulWidget {
  const ContactusScreen({super.key});

  @override
  State<ContactusScreen> createState() => _DonationScreenState();
}

class _DonationScreenState extends State<ContactusScreen> with SingleTickerProviderStateMixin{

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _refreshContent() async {
    try {
     // await Get.find<NotificationController>().getNotifications();

    } catch (e) {
      // Handle error
      print("Error refreshing notifications: $e");
    }
  }
  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final rectangleWidthPercentage = 0.9; // 80% of screen width
    return DefaultTabController(
        length: 3,
        child:  AppScaffold(
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
                          'Contact Us',
                          style: boldText(
                              weight: FontWeight.w600, size: 22, color: white),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                  else
                    Text(
                      'Contact Us',
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
                Center(
                  child:
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: (screenWidth - (screenWidth * rectangleWidthPercentage)) / 8, top: 10),
                        width: screenWidth * rectangleWidthPercentage * 0.9,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: kPrimaryColor, // Change color as needed
                        ),
                        child: Container(
                            width: 295,
                            height: 68,
                            child:   Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(width: 10), // Adjust the spacing between the text and containers
                                Stack(
                                  children: [
                                    Container(
                                      width: 68,
                                      height: 68,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFECF8ED), // Cream container
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Container(
                                        width: 68,
                                        height: 68,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage('assets/icons/badge_contactus.png'), // Replace 'assets/icon.png' with your actual image path
                                            fit: BoxFit.scaleDown,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 20),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'hgministry@gmail.com',
                                      style: TextStyle(fontSize: 16, color: white, fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Phone number',
                                      style: TextStyle(fontSize: 12, color: white, fontWeight: FontWeight.w300),
                                    ),
                                    Text(
                                      '(651) 208 - 0162',
                                      style: TextStyle(fontSize: 12, color: white, fontWeight: FontWeight.w300),
                                    ),
                                  ],
                                ),
                              ],
                            )// You can replace Placeholder with your actual content
                        ),
                      ),
                      SizedBox(width: 20),
                      Container(
                        height: screenHeight,
                        margin: EdgeInsets.only(left: (screenWidth - (screenWidth * rectangleWidthPercentage)) / 8, top: 20),
                        width: screenWidth * rectangleWidthPercentage,
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity, // Full width
                              height: 100, // Adjust height as needed
                              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5), // Adjust padding as needed
                              decoration: BoxDecoration(
                                color: Color(0xFFF4F4F4), // Background color
                                borderRadius: BorderRadius.circular(30),
                              ),
                              constraints: BoxConstraints.expand(height: 60),
                              child: TabBar(
                                tabs: [
                                  Tab(text: 'Website'),
                                  Tab(text: 'Find Us'),
                                  Tab(text: 'Social Media'),
                                ],
                                indicatorSize: TabBarIndicatorSize.tab,
                                indicatorWeight: 0,
                                indicator:
                                BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: kPrimaryColor,
                                ),
                                labelColor: Colors.white, // Text color for active tab
                                unselectedLabelColor: Colors.black, // Text color for inactive tabs
                                labelStyle: TextStyle(fontWeight: FontWeight.bold), // Font for active tab
                                unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal), // Font for inactive tabs
                                dividerHeight: 0,
                              ),
                            ),
                            30.height,
                            Expanded(
                              child: TabBarView(
                                children: [
                                  _buildTabContent('website'),
                                  _buildTabContent('findus'),
                                  _buildTabContent('socialmedia'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                )
              ],
            ).paddingSymmetric(horizontal: 5),
          ),
        )

    );
  }


  Widget _buildTabContent(String type) {

    final screenWidth = MediaQuery.of(context).size.width;
    final rectangleWidthPercentage = 0.9; // 80% of screen width
    return RefreshIndicator(
      onRefresh: _refreshContent,
      child: AppScrollView(
        children: [
          if (type == 'website')
            Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 100,
                    width: screenWidth * rectangleWidthPercentage * 0.9,
                    margin: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: kSecondaryColor, width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: ListTile(
                              title: Text(
                                'Check our website out',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  letterSpacing: 0.03,
                                  height: 1.75,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            )
                          ),
                          Positioned(
                            bottom: 5,
                            left: 0,
                            right: 0,
                            child: ListTile(
                              onTap: () {},
                              title: Text(
                                'https://houseofgloryministries.org/',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16.0,
                                  letterSpacing: 0.03,
                                  color: kSecondaryColor,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              trailing: Image.asset(ic_chevron_right),
                            ),
                          ),
                        ]
                      ),
                    ),
                  )
                ],
              ),
            ),
          if (type == 'findus')
          // Find Us Tab
            Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: screenWidth * rectangleWidthPercentage * 0.9,
                    margin: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                      child: Row(
                        children: [
                          Container(
                            width: 40.0,
                            height: 40.0,
                            child: Stack(
                              children: [
                                Positioned(
                                  left:0,
                                  top: 0,
                                  child: Container(
                                    width: 40.0,
                                    height: 40.0,
                                    decoration: BoxDecoration(
                                      color: kSecondaryColor,
                                      borderRadius: BorderRadius.circular(180),
                                    ),// Assuming a blue color for the placeholder
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage('assets/icons/ic_marker.png'), // Replace 'assets/icon.png' with your actual image path
                                        fit: BoxFit.scaleDown,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8.0), // To replicate the marginLeft of TextView
                          Expanded(
                            child: Text(
                              '1685 HWY 96 E, White Bare Lake MN \n55110',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                letterSpacing: 0.03,
                                height: 1.75, // equivalent to lineSpacingExtra of 4sp with text size 16sp
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                  )
                ],
              ),
            ),

          if (type == 'socialmedia')
          // Social Media Tab
            Container(
              width: screenWidth * rectangleWidthPercentage * 0.9,
              margin: const EdgeInsets.fromLTRB(25, 0, 0, 0),
              child: Text(''),
            ),
        ],
      ),
    );
  }
}


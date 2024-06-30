import 'package:cs_give/core/constants/images.dart';
import 'package:cs_give/core/theme/colors.dart';
import 'package:cs_give/package/cuberto_bottom_bar/cuberto_bottom_bar.dart';
import 'package:cs_give/package/cuberto_bottom_bar/tab_data.dart';
import 'package:cs_give/screens/dashboard/donation_screen.dart';
import 'package:cs_give/screens/dashboard/more_screen.dart';
import 'package:cs_give/screens/dashboard/search_screen.dart';
import 'package:cs_give/screens/home_page.dart';
import 'package:cs_give/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:nb_utils/nb_utils.dart';

import '../controller/donation_controller.dart';

final tabs = [
  TabData(iconData: ic_home, title: 'Home'),
  TabData(iconData: ic_search, title: 'Search'),
  TabData(iconData: ic_donation, title: 'Donation'),
  TabData(iconData: ic_more, title: 'More'),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTab = 0;

  final _framgents = [
    HomePage(),
    const SearchScreen(),
    const DonationScreen(),
    const MoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      bottomNavigationBar: CubertoBottomBar(
        key: const Key("BottomBar"),
        inactiveIconColor: white,
        tabStyle: CubertoTabStyle.styleFadedBackground,
        tabColor: kPrimaryColor,
        selectedTab: _currentTab,
        textColor: kPrimaryColor,
        barBackgroundColor: kSecondaryColor,
        tabs: tabs
            .map(
              (value) => TabData(
                key: Key(value.title),
                iconData: value.iconData,
                title: value.title,
                tabColor: value.tabColor,
              ),
            )
            .toList(),
        onTabChangedListener: (position, title, color) {
          setState(() {
            _currentTab = position;
            if (position == 2) { // Check if the DonationScreen tab is selected
              Get.find<DonationController>().resetSelection();
            }
          });
        },
      ),
      body: IndexedStack(
        index: _currentTab,
        children: _framgents,
      ),
    );
  }
}

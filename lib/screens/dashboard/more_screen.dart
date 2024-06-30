import 'package:cs_give/controller/app_state.dart';
import 'package:cs_give/core/constants/app_constants.dart';
import 'package:cs_give/core/constants/images.dart';
import 'package:cs_give/core/theme/colors.dart';
import 'package:cs_give/core/utils/common.dart';
import 'package:cs_give/core/utils/extensions.dart';
import 'package:cs_give/screens/account/accountsettings_screen.dart';
import 'package:cs_give/screens/account/bookappointments_screen.dart';
import 'package:cs_give/screens/account/contactus_screen.dart';
import 'package:cs_give/screens/account/donationhistory_screen.dart';
import 'package:cs_give/screens/account/events_screen.dart';
import 'package:cs_give/screens/splash_screen.dart';
import 'package:cs_give/services/profilepicture_services.dart';
import 'package:cs_give/widgets/app_scaffold.dart';
import 'package:cs_give/widgets/app_scroll_view.dart';
import 'package:cs_give/widgets/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';




class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});


  @override
  Widget build(BuildContext context) {

    final ProfilePictureService _profilePictureService = ProfilePictureService();
    return AppScaffold(
      appBar: AppBar(
        toolbarHeight: getHeaderSize(context),
        centerTitle: true,
        flexibleSpace: Container(
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
          decoration: BoxDecoration(
            color: kSecondaryColor,
            borderRadius: radiusOnly(bottomLeft: 20, bottomRight: 20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'My Account',
                style:
                    boldText(weight: FontWeight.w600, size: 22, color: white),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              FutureBuilder<String?>(
                future: _profilePictureService.getProfilePictureUrl(), // Fetch profile picture URL
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // Show loading indicator while fetching
                  } else if (snapshot.hasError) {
                    return const Text(
                      'Error loading image',
                      style: TextStyle(color: Colors.red),
                    ); // Show error message if fetching fails
                  } else if (snapshot.hasData) {
                    return CircleAvatar(
                      radius: 25, // Adjust size as needed
                      backgroundImage: NetworkImage(snapshot.data!), // Load profile picture from URL
                    ); // Show profile picture if available
                  } else {
                    return SizedBox(); // Show nothing if no data available
                  }
                },
              ),
              SizedBox(height: 20),
              if (isLoggedIn())
                Text(
                  getStringAsync(LocalKeys.kUserEmail),
                  style:
                      boldText(weight: FontWeight.w500, size: 16, color: white),
                  textAlign: TextAlign.center,
                ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView (
        child: AppScrollView(
          children: [
            SizedBox(height: 20),
            ListTile(
              onTap: () {
                Get.to(() => EventsScreen());
              },
              leading: events.iconImage(color: black),
              title: Text(
                'Events',
                style: primaryText(
                  size: 18,
                  weight: FontWeight.w400,
                ),
              ),
            ).paddingBottom(10),
            ListTile(
              onTap: () {
                Get.to(() => AccountsettingsScreen());
              },
              leading: account_settings.iconImage(color: black),
              title: Text(
                'Account Settings',
                style: primaryText(
                  size: 18,
                  weight: FontWeight.w400,
                ),
              ),
            ).paddingBottom(10).visible(isLoggedIn()),
            ListTile(
              onTap: () {
                Get.to(() => ContactusScreen());
              },
              leading: contact_us.iconImage(color: black),
              title: Text(
                'Contact Us',
                style: primaryText(
                  size: 18,
                  weight: FontWeight.w400,
                ),
              ),
            ).paddingBottom(10),
            ListTile(
              onTap: () {
              },
              leading: the_bible.iconImage(color: black),
              title: Text(
                'The Bible',
                style: primaryText(
                  size: 18,
                  weight: FontWeight.w400,
                ),
              ),
            ).paddingBottom(10),
            ListTile(
              onTap: () {
                Get.to(() => DonationhistoryScreen());
              },
              leading: donation_history.iconImage(color: black),
              title: Text(
                'Donation History',
                style: primaryText(
                  size: 18,
                  weight: FontWeight.w400,
                ),
              ),
            ).paddingBottom(10).visible(isLoggedIn()),
            ListTile(
              onTap: () {
                //Get.to(() => BookappointmentsScreen_R());
                Get.to(() => BookappointmentsScreen());
              },
              leading: book_appointment.iconImage(color: black),
              title: Text(
                'Book Appointment',
                style: primaryText(
                  size: 18,
                  weight: FontWeight.w400,
                ),
              ),
            ).paddingBottom(10).visible(isLoggedIn()),
            ListTile(
              onTap: () {
                showError('in development, api endpoint needed');
              },
              leading: ic_delete.iconImage(
                  color: !isLoggedIn() ? kPrimaryColor : logoutColor),
              title: Text(
                'Delete Account',
                style: primaryText(
                  size: 18,
                  weight: FontWeight.w400,
                  color: !isLoggedIn() ? kPrimaryColor : logoutColor,
                ),
              ),
            ).paddingBottom(10).visible(isLoggedIn()),
            ListTile(
              onTap: () {
                Get.find<AppState>().removeData();
                Get.offAll(() => const SplashScreen());
              },
              leading: sign_out.iconImage(
                  color: !isLoggedIn() ? kPrimaryColor : logoutColor),
              title: Text(
                isLoggedIn() ? 'Sign Out' : "Sign In",
                style: primaryText(
                  size: 18,
                  weight: FontWeight.w400,
                  color: !isLoggedIn() ? kPrimaryColor : logoutColor,
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ).paddingLeft(40),
      )
    );
  }
}

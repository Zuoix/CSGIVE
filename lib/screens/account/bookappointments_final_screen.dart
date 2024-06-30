import 'package:cs_give/core/theme/colors.dart';
import 'package:cs_give/core/utils/common.dart';
import 'package:cs_give/screens/home_screen.dart';
import 'package:cs_give/widgets/app_scaffold.dart';
import 'package:cs_give/widgets/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../config/colors.dart';
import '../../../config/size_config.dart';

class BookappointmentsSuccessScreen extends StatefulWidget {
  const BookappointmentsSuccessScreen({super.key});

  @override
  State<BookappointmentsSuccessScreen> createState() => _BookappointmentsSuccessScreen();
}

class _BookappointmentsSuccessScreen extends State<BookappointmentsSuccessScreen> {


  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
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
                        'Book Appointment',
                        style: boldText(weight: FontWeight.w600, size: 22, color: white),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
                else
                  Text(
                    'Book Appointment',
                    style: boldText(weight: FontWeight.w600, size: 22, color: white),
                    textAlign: TextAlign.center,
                  ),
                10.height,
              ],
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeFile.height20.w),
              child: AnimatedScrollView(
                children: [
                  SizedBox(height: SizeFile.height30.h),
                  SingleChildScrollView(
                      child: Column(
                    children: [
                      Center(
                        child: Column(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                CustomPaint(
                                  size: Size(200, 200), // Specify the size of the CustomPaint widget
                                  painter: CirclePainter(color: kSecondaryLightColor),
                                ),
                                Positioned(
                                  child: Container(
                                    width: 200,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage('assets/icons/cirrcular_img.png'), // Replace 'assets/icon.png' with your actual image path
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage('assets/icons/tick_mark.png'), // Replace 'assets/icon.png' with your actual image path
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                            SizedBox(height: SizeFile.height25.h),
                            Text(
                              'Booking Successful',
                              style: GoogleFonts.urbanist(
                                fontSize: 20,
                                color: black,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: SizeFile.height10.h),
                            Text(
                              'Your appointment has been requested',
                              style: GoogleFonts.urbanist(
                                fontSize: 16,
                                color: black,
                                fontWeight: FontWeight.w300,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: SizeFile.height15.h),
                            Container(
                              alignment: Alignment.center,
                              width: screenWidth * 0.7,
                              height: 100,
                              margin: EdgeInsets.only(top: 5),
                              decoration: BoxDecoration(
                                color: ColorFile.musterColrLight,

                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: ColorFile.musterColor),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('If you have any problem or any issue \n and you need change your visit, \nplease call 021 9012301',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ))
                ],
              ),
            ),
            Positioned(
                bottom: screenHeight - (screenHeight * 0.5), // Position it at 10% from the bottom of the screen
                child: AppButton(
                  text: 'Back to Home',
                  textStyle: boldText(
                    color: white,
                    weight: FontWeight.w600,
                    size: 16,
                  ),
                  color: true ? kSecondaryColor : appTextSecondaryColor,
                  // Change color based on time selection
                  textColor: kPrimaryColor,
                  width: MediaQuery.of(context).size.width * 0.8,
                  onTap: () {
                    HomeScreen().launch(context);
                  },

                )),
            SizedBox(height: SizeFile.height5.h),
          ],
        ));
  }
}

class CirclePainter extends CustomPainter {
  Color color = Colors.blue;

  CirclePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    // Define the paint object
    final paint = Paint()
      ..color = color // Circle color
      ..style = PaintingStyle.fill; // Fill the circle

    // Define the center and radius
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw the circle
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // Return true if the oldDelegate is different from this instance
    return false;
  }
}

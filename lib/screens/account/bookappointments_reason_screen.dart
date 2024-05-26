import 'package:cs_give/core/theme/colors.dart';
import 'package:cs_give/core/utils/common.dart';
import 'package:cs_give/widgets/app_scaffold.dart';
import 'package:cs_give/widgets/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../config/colors.dart';
import '../../../config/size_config.dart';
import '../../controller/book_appointment_controller.dart';
import 'bookappointments_final_screen.dart';

class BookappointmentsReasonScreen extends StatelessWidget {
  final int appointmentTimeId;
  final String date;
  final String appointmentReason = '';

  // Constructor
  BookappointmentsReasonScreen({
    required this.appointmentTimeId,
    required this.date,
  });
  final TextEditingController reasonController = TextEditingController();

  final BookAppointmentController c = BookAppointmentController();
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
                                Text(
                                  'Add Reason For Appointment',
                                  style: GoogleFonts.urbanist(
                                    fontSize: 20,
                                    color: black,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: SizeFile.height5.h),
                                Container(
                                  width: maxScreenWidth,
                                  height: 200,
                                  margin: EdgeInsets.only(top: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: ColorFile.appColor),
                                  ),
                                  child:  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: TextField(
                                      maxLines: 5,
                                      onChanged: (value) {
                                        c.appointmentReason = value;
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'Enter reason here...',
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              // Set reason to "No reason specified"
                              String reason = 'No reason specified';
                              // Call the submitAppointmentRequest function
                              c.submitApointmentRequest(appointmentTimeId.toString(), date,reason);
                              if (c.appointMentCompleted) {
                                  BookappointmentsSuccessScreen().launch(context);
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Skip',
                                  style: GoogleFonts.urbanist(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w200,
                                  ),
                                  textAlign: TextAlign.end,
                                )
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
                text: 'Book appointment',
                textStyle: boldText(
                  color: white,
                  weight: FontWeight.w600,
                  size: 16,
                ),
                color: true ? kSecondaryColor : appTextSecondaryColor, // Change color based on time selection
                textColor: kPrimaryColor,
                width: MediaQuery.of(context).size.width * 0.8,
                onTap: () async {
                  String reason = reasonController.text.trim();
                  // Get the text from the TextField
                  if (c.appointmentReason.isNotEmpty) {
                    reason = c.appointmentReason;
                  } else {
                    showError('Please enter a reason for the appointment');
                    return;
                  }
                  // Call the submitAppointmentRequest function
                 c.submitApointmentRequest(appointmentTimeId.toString(), date, reason, );
                  if(c.appointMentCompleted){
                      BookappointmentsSuccessScreen().launch(context);
                      c.appointMentCompleted= false;
                  }
                },
              )
            ),
            SizedBox(height: SizeFile.height5.h),
          ],
        ));
  }
}

import 'package:cs_give/core/constants/app_constants.dart';
import 'package:cs_give/core/theme/colors.dart';
import 'package:cs_give/core/utils/common.dart';
import 'package:cs_give/screens/account/bookappointments_reason_screen.dart';
import 'package:cs_give/widgets/app_scaffold.dart';
import 'package:cs_give/widgets/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../config/colors.dart';
import '../../../config/font_family.dart';
import '../../../config/size_config.dart';
import '../../../controller/book_appointment_controller.dart';
import '../../../models/appointment_timelist.dart';

class BookappointmentsScreen extends StatefulWidget {
  const BookappointmentsScreen({super.key});

  @override
  State<BookappointmentsScreen> createState() => _BookappointmentScreenState();
}

class _BookappointmentScreenState extends State<BookappointmentsScreen> {

  final ScrollController _scrollController = ScrollController();

  final BookAppointmentController c = BookAppointmentController();
  @override
  void initState() {
    super.initState();
    Get.put(BookAppointmentController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final today = DateTime.now();
      if (today.month == currentDate.month && today.year == currentDate.year) {
        double offset = (today.day - 3) * 90; // 80.0 is width + margin (60.0 + 20.0)
        _scrollController.jumpTo(offset);
      }
      DateTime dateToTap = DateTime(currentDate.year, currentDate.month, today.day);

      _autoSelectDate(dateToTap);
    });
  }

  bool isTimeSelected = false;
  List<int> selectedIndices = [-1, -1, -1];
  late int selectedAppointmentTimeId;
  late String selectedAppointmentDate;

  var selectedDate = DateTime.now();
  var currentDate = DateTime.now();

  DateTime startDate = DateTime(AppConstants.startYear, AppConstants.startMonth, AppConstants.startDay);
  void _autoSelectDate(DateTime date) {
    setState(() {
      selectedDate = date;
    });
    c.fetchAppointmentsForSelectedDate(date);
  }
  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(currentDate.year, currentDate.month + 1, 0).day;
    final dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final today = DateTime.now().toLocal();
    final currentMonth = DateTime(currentDate.year, currentDate.month);

    return GetBuilder<BookAppointmentController>(
      builder: (k) {
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
                            'Book Appointment',
                            style: boldText(
                                weight: FontWeight.w600, size: 22, color: white),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )
                    else
                      Text(
                        'Book Appointment',
                        style: boldText(
                            weight: FontWeight.w600, size: 22, color: white),
                        textAlign: TextAlign.center,
                      ),
                    10.height,
                  ],
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(

                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: SizeFile.height10.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: SizeFile.height20.w),
                    child: AnimatedScrollView(
                      children: [
                        20.height,
                        Text(
                          'Message',
                          style: GoogleFonts.urbanist(
                            fontSize: 20,
                            color: black,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.start,
                        ), 5.height,
                        Text(
                          'Welcome  to House of God Ministries. Book an appointment with us.',
                          style: GoogleFonts.urbanist(
                              fontWeight: FontWeight.w300, fontSize: 16, color: black),
                          textAlign: TextAlign.start,
                        ),
                        20.height,
                        Text(
                          'Select Schedule',
                          style: GoogleFonts.urbanist(
                              fontWeight: FontWeight.w700, fontSize: 16, color: black),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: SizeFile.height20.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: SizeFile.height20.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${_getMonthName(currentDate.month)} ${currentDate.year}",
                          style: GoogleFonts.urbanist(
                              fontWeight: FontWeight.w700, fontSize: SizeFile.height10.sp, color: Colors.black),
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  currentDate = DateTime(currentDate.year, currentDate.month - 1);
                                  //selectedDate = currentDate;
                                });
                                c.fetchAppointmentsForSelectedDate(currentDate);
                                double offset = (selectedDate.day - 3) * 80.0;
                                _scrollController.jumpTo(offset);
                              },
                              child: const Icon(
                                Icons.arrow_left,
                                size: 30,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  currentDate = DateTime(currentDate.year, currentDate.month + 1);
                                  //selectedDate = currentDate;
                                });
                                c.fetchAppointmentsForSelectedDate(currentDate);
                                double offset = (selectedDate.day - 3) * 80.0;
                                _scrollController.jumpTo(offset);
                              },
                              child: const Icon(
                                Icons.arrow_right,
                                size: 30,
                                color: ColorFile.appColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 120.0,
                    padding: const EdgeInsets.only(left: 20),
                    child: ListView.builder(
                      controller: _scrollController,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: daysInMonth,
                      itemBuilder: (context, index) {
                        final date = DateTime(currentDate.year, currentDate.month, index + 1);
                        String dayLabel = dayLabels[date.weekday - 1];
                        String formattedDate = date.day.toString().padLeft(2, '0');
                        bool isToday = date.day == today.day && currentMonth.month == today.month && date.year == today.year;
                        bool isSelected = date.day == selectedDate.day && currentMonth.month == selectedDate.month && date.year == selectedDate.year;
                        Color textColor = isSelected ? Colors.white : isToday ? Colors.black : Colors.black;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedDate = date;
                            });
                            c.fetchAppointmentsForSelectedDate(date);
                          },
                          child: Container(
                            width: 70.0,
                            margin: const EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(35),
                              color: isSelected ? ColorFile.appColor : ColorFile.unSelectedDateColor,
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    formattedDate,
                                    style: TextStyle(
                                      fontFamily: lexendRegular,
                                      fontWeight: FontWeight.w400,
                                      fontSize: SizeFile.height17.sp,
                                      color: textColor,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    dayLabel,
                                    style: TextStyle(
                                      fontFamily: lexendRegular,
                                      fontWeight: FontWeight.w400,
                                      fontSize: SizeFile.height16.sp,
                                      color: textColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: SizeFile.height32.h),
                  SizedBox(height: SizeFile.height16.h), Padding(
                    padding: EdgeInsets.symmetric(horizontal: SizeFile.height20.w),
                    child: Text(
                      'Available slots',
                      style: GoogleFonts.urbanist(
                        fontWeight: FontWeight.w700,
                        fontSize: SizeFile.height14.sp,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  SizedBox(height: SizeFile.height10.h),
                  Obx(() {
                    if (c.isDateWithAppointments.value) {
                      return  _buildTimeGrid(c.timeDistList);
                    } else {
                      return const Center(
                        child: Text('No available times for the selected date.'),
                      );
                    }
                  }),
                  SizedBox(height: SizeFile.height16.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: SizeFile.height20.w),
                    child: AppButton(
                      text: c.isDateWithAppointments.value ? 'Next' : 'Choose Time',
                      textStyle: boldText(
                        color: white,
                        weight: FontWeight.w600,
                        size: 16,
                      ),
                      color: isTimeSelected ? kSecondaryColor : appTextSecondaryColor, // Change color based on time selection
                      textColor: kPrimaryColor,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width -
                          context.navigationBarHeight,
                      onTap: () {
                        // Navigate to the next screen
                        if (isTimeSelected) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookappointmentsReasonScreen(
                                appointmentTimeId: selectedAppointmentTimeId,
                                date: selectedAppointmentDate,
                              ),
                            ),
                          );

                        }else{
                          showError('You need to choose a time.');
                        }
                      },

                    ),
                  ),
                  SizedBox(height: SizeFile.height35.h),
                ],
              ).paddingSymmetric(vertical: 20),
            )
        );
      },
    );
  }




  Widget _buildTimeGrid(List<List<ItemModelAppointmentTime>> timeDistList) {
    List<ItemModelAppointmentTime> morningTimes = timeDistList.length > 0 ? timeDistList[0] : [];
    List<ItemModelAppointmentTime> afternoonTimes = timeDistList.length > 1 ? timeDistList[1] : [];
    List<ItemModelAppointmentTime> eveningTimes = timeDistList.length > 2 ? timeDistList[2] : [];

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (morningTimes.isNotEmpty) ..._buildTimeGridWidget(morningTimes, 'Morning', 0),
          if (afternoonTimes.isNotEmpty) ..._buildTimeGridWidget(afternoonTimes, 'Afternoon', 1),
          if (eveningTimes.isNotEmpty) ..._buildTimeGridWidget(eveningTimes, 'Evening', 2),
        ],
      ),
    );
  }



  List<Widget> _buildTimeGridWidget(List<ItemModelAppointmentTime> times, String title,  int gridIndex) {
    return [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: SizeFile.height20.w),
        child: Text(
          title,
          style: GoogleFonts.urbanist(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.black),
        ),
      ),
      SizedBox(height: SizeFile.height10.h),
      Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeFile.height20.w),
          child:
          GridView.builder(
            itemCount: times.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: SizeFile.height12.h,
              mainAxisExtent: SizeFile.height31.h,
              crossAxisSpacing: SizeFile.height15.h,
            ),
            itemBuilder: (BuildContext context, int index) {
              final time = times[index];

              bool isSelected = index == selectedIndices[gridIndex];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    DateTime selectedDateTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, time.realTime!.hour, time.realTime!.minute);

                    // Determine if the selected date is in the past
                    if (selectedDateTime.isBefore(currentDate)) {
                      // Show error message to the user
                      showError('Please select a date in the future');
                      return; // Exit the function without updating the state
                    }


                    // Reset selected indices of other grids
                    for (int i = 0; i < selectedIndices.length; i++) {
                      if (i != gridIndex) {
                        selectedIndices[i] = -1;
                      }
                    }
                    // Set selected index for the current grid
                    selectedIndices[gridIndex] = isSelected ? -1 : index;
                    isTimeSelected = true;

                    // Set selected index for the current grid
                    selectedIndices[gridIndex] = isSelected ? -1 : index;

                    selectedAppointmentTimeId = time.appointmentId!;
                    selectedAppointmentDate = DateFormat('MMM dd yyyy').format(selectedDate);
                  });
                },
                child: Container(
                  width: SizeFile.height10.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? ColorFile.appColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(SizeFile.height28.r),
                    border: isSelected ? Border.all(color: Colors.transparent) : Border.all(color: ColorFile.greyBorderColor),
                  ),
                  child: Text(
                    time.appointmentTime.toString(),
                    style: TextStyle(
                      color: isSelected ? Colors.white : ColorFile.appbarTitleColor,
                      fontFamily: lexendRegular,
                      fontWeight: FontWeight.w300,
                      fontSize: SizeFile.height10.sp,
                    ),
                  ),
                ),
              );
            },
          )),

      SizedBox(height: SizeFile.height25.h),
    ];
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return "January";
      case 2:
        return "February";
      case 3:
        return "March";
      case 4:
        return "April";
      case 5:
        return "May";
      case 6:
        return "June";
      case 7:
        return "July";
      case 8:
        return "August";
      case 9:
        return "September";
      case 10:
        return "October";
      case 11:
        return "November";
      case 12:
        return "December";
      default:
        return "";
    }
  }

}



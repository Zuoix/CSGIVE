import 'package:cs_give/core/config/app_config.dart';
import 'package:cs_give/core/theme/theme.dart';
import 'package:cs_give/models/church_data.dart';
import 'package:cs_give/models/event_data.dart';
import 'package:cs_give/screens/splash_screen.dart';
import 'package:cs_give/services/appointment_services.dart';
import 'package:cs_give/services/auth_services.dart';
import 'package:cs_give/services/church_services.dart';
import 'package:cs_give/services/dashboard_services.dart';
import 'package:cs_give/services/donation_services.dart';
import 'package:cs_give/services/event_services.dart';
import 'package:cs_give/services/live_stream_service.dart';
import 'package:cs_give/services/message_services.dart';
import 'package:cs_give/services/notification_services.dart';
import 'package:cs_give/services/pawa_pay_service.dart';
import 'package:cs_give/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:nb_utils/nb_utils.dart';

ChurchServices churchServices = ChurchServices();
AuthServices authServices = AuthServices();
UserServices userServices = UserServices();
DashboardServices dashboardServices = DashboardServices();
DonationServices donationServices = DonationServices();
NotificationsService notificationServices = NotificationsService();
EventService eventServices = EventService();
MessageService messageService = MessageService();
AppointmentServices appointmentServices = AppointmentServices();
PawaPay pawaPayServices = PawaPay();
LiveStreamService liveStreamService = LiveStreamService();

List<Church>? cachedChurches;
List<EventData>? cachedEvents;

class CSGiveApp extends StatelessWidget {
  const CSGiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 741),
        builder: (context, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: kAppName,
            theme: AppTheme.lightTheme(),
            navigatorKey: navigatorKey,
            home: const SplashScreen(),
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: const TextScaler.linear(1.0),
                ),
                child: child!,
              );
            },
          );
        });
  }
}

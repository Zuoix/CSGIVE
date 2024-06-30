import 'package:cs_give/app.dart';
import 'package:cs_give/models/event_data.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';





class EventController extends GetxController {

  WebViewController? controller;

  List<EventData> events = [];
  List<EventData> upcomingevents = [];

  @override
  void onInit() {
    getEvents();
    super.onInit();
  }


  Future<void> getEvents() async {
    events = await eventServices.getEvents();
    update();
  }

  Future<void> getUpcomingEvents() async {
    upcomingevents = await eventServices.getUpcomingEvents();
    update();
  }


}

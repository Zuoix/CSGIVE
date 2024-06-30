import 'package:cs_give/app.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:cs_give/models/notification_type_data.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../models/message_type_data.dart';




class NotificationController extends GetxController {

  WebViewController? controller;

  List<NotificationType> notifications = [];
  List<MessageType> messages = [];

  @override
  void onInit() {
    getNotifications();
    getMessages();
    super.onInit();
  }

  Future<void> getNotifications() async {
    notifications = await notificationServices.getNotifications();
    update();
  }

  Future<void> getMessages() async {
    messages = await messageService.getMessages();
    update();
  }

}

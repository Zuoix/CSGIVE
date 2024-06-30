import 'package:cs_give/models/notification_type_data.dart';
import 'package:cs_give/services/network_utils.dart';

import '../core/constants/api_routes.dart';

class NotificationsService {
  Future<List<NotificationType>> getNotifications() async {
    String apiPath = ApiRoutes.notification;

    final data = await handleResponse(await buildHttpResponse(apiPath));
    return (data['data'] as List).map((e) => NotificationType.fromJson(e)).toList();
  }
}

import 'package:cs_give/services/network_utils.dart';

import '../app.dart';
import '../core/constants/api_routes.dart';
import '../models/event_data.dart';

class EventService {

  Future<List<EventData>> getEvents() async {
    String apiPath = ApiRoutes.events;

    final data = await handleResponse(await buildHttpResponse(apiPath));
    final returnList =
    (data['data'] as List).map((e) => EventData.fromJson(e)).toList();
    cachedEvents = returnList;
    return returnList;
  }


  Future<List<EventData>> getUpcomingEvents() async {
    String apiPath = ApiRoutes.getupcomingevents;

    final data = await handleResponse(await buildHttpResponse(apiPath));
    return (data['data'] as List).map((e) => EventData.fromJson(e)).toList();
  }
}

import 'package:cs_give/core/constants/api_routes.dart';
import 'package:cs_give/models/content_data.dart';
import 'package:cs_give/services/network_utils.dart';

class DashboardServices {

  Future<List<ContentData>> getVideos() async {
    String apiPath = ApiRoutes.videos;
    final data = await handleResponse(await buildHttpResponse(apiPath));
    final returnList =
        (data['data'] as List).map((e) => ContentData.fromJson(e)).toList();
    return returnList;
  }
}

import 'dart:io';

import 'package:cs_give/app.dart';
import 'package:cs_give/controller/app_state.dart';
import 'package:cs_give/models/church_data.dart';
import 'package:cs_give/services/network_utils.dart';
import 'package:get/get.dart';

import '../core/constants/api_routes.dart';

class ChurchServices {
  Future<List<Church>> getChurches() async {
    String apiPath = ApiRoutes.churches;

    final data = await handleResponse(await buildHttpResponse(apiPath));
    final returnList = (data as List).map((e) => Church.fromJson(e)).toList();
    cachedChurches = returnList;
    return returnList;
  }

  Future<Church> getCurrentChurch(String token) async {
    String apiPath = ApiRoutes.church;

    final data = await handleResponse(await buildHttpResponse(apiPath,
        extraKeys: {HttpHeaders.authorizationHeader: 'Bearer $token'}));
    final church = Church.fromJson(data as Map);
    Get.find<AppState>().setChurch(church);
    return church;
  }
}

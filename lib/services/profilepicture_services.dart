import 'dart:io';

import 'package:cs_give/services/network_utils.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../core/constants/api_routes.dart';
import '../core/constants/app_constants.dart';

class ProfilePictureService {


  Future<String?> getProfilePictureUrl() async {

    try {
      String apiPath = ApiRoutes.profilepicture;
      final token = getStringAsync(LocalKeys.kUserToken);
      final data = await handleResponse(await buildHttpResponse(apiPath, extraKeys: {HttpHeaders.authorizationHeader: 'Bearer $token'}));

      return data['status_code'] == '00' ? data['data'] : null;
    } catch (e) {
      print('Error fetching profile picture URL: $e');
      return null;
    }
  }
}

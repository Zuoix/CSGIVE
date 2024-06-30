import 'package:cs_give/core/constants/api_routes.dart';
import 'package:cs_give/services/network_utils.dart';
import 'package:nb_utils/nb_utils.dart';

class UserServices {
  Future<bool?> sendPasswordVerificationLink(String email) async {
    String apiPath = ApiRoutes.forgotPassword;

    final resp = await handleResponse(
      await buildHttpResponse(
        apiPath,
        method: HttpMethodType.POST,
        request: {'email': email},
      ),
    );

    return resp['status_code'] == '00';
  }
}

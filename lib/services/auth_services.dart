import 'package:cs_give/core/constants/api_routes.dart';
import 'package:cs_give/models/request/register_request.dart';
import 'package:cs_give/models/response/login_resposnse.dart';
import 'package:cs_give/services/network_utils.dart';
import 'package:nb_utils/nb_utils.dart';

import '../core/utils/common.dart';
import '../models/response/changepassword_resposnse.dart';

class AuthServices {
  Future<LoginResponse?> login(String email, String pass) async {
    String apiPath = ApiRoutes.login;

    final resp = await handleResponse(
      await buildHttpResponse(
        apiPath,
        method: HttpMethodType.POST,
        request: {'email': email, 'password': pass},
      ),
    );

    if (resp['status_code'] == '00') {
      return LoginResponse.fromJson(resp);
    }

    return null;
  }

  Future<String?> register(RegisterRequest registerRequest) async {
    String apiPath = ApiRoutes.register;

    final resp = await handleResponse(
      await buildHttpResponse(
        apiPath,
        method: HttpMethodType.POST,
        request: registerRequest.toJson(),
      ),
    );

    if (resp['status_code'] == '00') {
      return resp['token'];
    }

    return null;
  }


  Future<ChangepasswordResponse?> changepassword(String oldPassword, String password, String confirmPassword) async {
    String apiPath = ApiRoutes.changePassword;

    final resp = await handleResponse(
      await buildHttpResponse(
        apiPath,
        method: HttpMethodType.POST,
        request: {'oldPassword': oldPassword, 'password': password, 'confirmPassword': confirmPassword},
      ),
    );

      if (resp['status_code'] == '00'){
        return ChangepasswordResponse.fromJson(resp);
      }else if (resp['status_code'] == '03'){
        showSuccess(resp.message + ' : '+ resp.reason);
      }

    return null;
  }

}

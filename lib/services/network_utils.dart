import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:cs_give/controller/app_state.dart';
import 'package:cs_give/core/constants/api_routes.dart';
import 'package:cs_give/core/utils/common.dart';
import 'package:get/get.dart' as g;
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';

Map<String, String> buildHeaderTokens({Map? extraKeys}) {
  Map<String, String> header = {...?extraKeys};
  final appToken = g.Get.find<AppState>().appToken;

  if (appToken.value.validate().isNotEmpty) {
    header.putIfAbsent(
        HttpHeaders.authorizationHeader, () => 'Bearer ${appToken.value}');
    header.putIfAbsent('X-Api-Key', () => 'Bearer ${appToken.value}');
  }

  header.putIfAbsent(HttpHeaders.contentTypeHeader,
      () => 'application/x-www-form-urlencoded; charset=utf-8');
  header.putIfAbsent(HttpHeaders.acceptHeader,
      () => 'application/x-www-form-urlencoded; charset=utf-8');
  header.putIfAbsent(HttpHeaders.cacheControlHeader, () => 'no-cache');
  header.putIfAbsent('Access-Control-Allow-Headers', () => '*');
  header.putIfAbsent('Access-Control-Allow-Origin', () => '*');

  return header;
}

Uri buildBaseUrl(String endPoint) {
  Uri url = Uri.parse(endPoint);
  if (!endPoint.startsWith('http')) {
    url = Uri.parse('${ApiRoutes.baseUrl}$endPoint');
  }

  return url;
}

Future<Response> buildHttpResponse(
  String endPoint, {
  HttpMethodType method = HttpMethodType.GET,
  Map? request,
  Map? extraKeys,
}) async {
  var headers = buildHeaderTokens(extraKeys: extraKeys);
  Uri url = buildBaseUrl(endPoint);

  Response response;

  try {
    if (method == HttpMethodType.POST) {
      response = await http.post(url, body: request, headers: headers);
    } else if (method == HttpMethodType.DELETE) {
      response = await delete(url, headers: headers);
    } else if (method == HttpMethodType.PUT) {
      response = await put(url, body: jsonEncode(request), headers: headers);
    } else {
      response = await get(url, headers: headers);
    }

    apiPrint(
      url: url.toString(),
      endPoint: endPoint,
      headers: jsonEncode(headers),
      hasRequest: method == HttpMethodType.POST || method == HttpMethodType.PUT,
      request: jsonEncode(request),
      statusCode: response.statusCode,
      responseBody: response.body,
      methodtype: method.name,
    );

    if (response.statusCode == 401 && !endPoint.startsWith('http')) {
      throw errorSomethingWentWrong;
    } else {
      return response;
    }
  } on Exception catch (e) {
    log('${url.toString()}: $e');
    if (!await isNetworkAvailable()) {
      throw errorInternetNotAvailable;
    } else {
      throw errorSomethingWentWrong;
    }
  }
}

Future handleResponse(
  Response response, {
  HttpResponseType httpResponseType = HttpResponseType.JSON,
}) async {
  if (!await isNetworkAvailable()) {
    throw errorInternetNotAvailable;
  }

  if (!response.statusCode.isSuccessful()) {
    /*showError(
      jsonDecode(response.body)['reason'],
      title: jsonDecode(response.body)['message'].toString().capitalizeFirstLetter(),
    );*/
  } else {
    try {
      showSuccess(jsonDecode(response.body)['message']);
    } catch (_) {}
  }

  return jsonDecode(response.body);
}

Future<MultipartRequest> getMultiPartRequest(String endPoint,
    {String? baseUrl}) async {
  String url = baseUrl ?? buildBaseUrl(endPoint).toString();
  return MultipartRequest('POST', Uri.parse(url));
}

void apiPrint({
  String url = "",
  String endPoint = "",
  String headers = "",
  String request = "",
  int statusCode = 0,
  String responseBody = "",
  String methodtype = "",
  bool hasRequest = false,
}) {
  dev.log(
      "┌───────────────────────────────────────────────────────────────────────────────────────────────────────");
  dev.log("\u001b[93m Url: \u001B[39m $url");
  dev.log("\u001b[93m Header: \u001B[39m \u001b[96m$headers\u001B[39m");
  if (request.isNotEmpty) {
    dev.log("\u001b[93m Request: \u001B[39m \u001b[96m$request\u001B[39m");
  }
  dev.log(statusCode.isSuccessful() ? "\u001b[32m" : "\u001b[31m");
  dev.log('Response ($methodtype) $statusCode: $responseBody');
  dev.log("\u001B[0m");
  dev.log(
      "└───────────────────────────────────────────────────────────────────────────────────────────────────────");
}

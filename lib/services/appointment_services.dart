
import 'package:cs_give/models/appointment_type_data.dart';
import 'package:cs_give/models/response/appointment_response.dart';
import 'package:cs_give/services/network_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../core/constants/api_routes.dart';
import '../core/utils/common.dart';
import '../models/request/appointment_request.dart';


class AppointmentServices {
  Future<List<AppointmentType>> getAppointmentsByDate(String date) async {
    String apiPath = '${ApiRoutes.getappointmentbydate}/$date';
    final data = await handleResponse(await buildHttpResponse(apiPath));

    // Ensure data is not null and is a list
    if (data == null || data['data'] == null) {
      return [];
    }
    if (data['data'] is! List) {
      throw Exception('Data is not a list');
    }

    return (data['data'] as List).map((e) => AppointmentType.fromJson(e)).toList();
  }


  Future<AppointmentResponse?> submitAppointmentRequest(AppointmentRequest request) async {

    String apiPath = ApiRoutes.submitappointment;
    final response = await handleResponse(
      await buildHttpResponse(
        apiPath,
        method: HttpMethodType.POST,
        request: {'appointmentTimeId': request.appointmentTimeId, 'date': request.date, 'appointmentReason': request.appointmentReason},
      ),
    );
    // Handle response
    try {
      if (response['status_code'] == '00'){
        return AppointmentResponse.fromJson(response);
      }else if (response['status_code'] == '03'){
        showError(response.message + ' : '+ response.reason);
      } else {
        String errorMessage = response['message'] ?? 'An unknown error occurred';
        showError(errorMessage);
      }

    } catch (e) {
      if (kDebugMode) {
        showError('Service area: '+e.toString());
      }
    }

    return null;
  }
}

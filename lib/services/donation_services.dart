import 'package:cs_give/core/constants/api_routes.dart';
import 'package:cs_give/models/donation_type_data.dart';
import 'package:cs_give/models/request/initpayment_request.dart';
import 'package:cs_give/models/response/updatepayment_response.dart';
import 'package:cs_give/services/network_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:nb_utils/nb_utils.dart';

import '../models/request/updatepayment_request.dart';
import '../models/response/checkpaymentstatus_response.dart';
import '../models/response/donationhistory_response.dart';
import '../models/response/initpayment_response.dart';

class DonationServices {
  Future<List<DonationType>> getDonationTypes() async {

    String apiPath = ApiRoutes.donationTypes;

    final data = await handleResponse(await buildHttpResponse(apiPath));
    return (data['data'] as List).map((e) => DonationType.fromJson(e)).toList();
  }

  Future<List<DonationhistoryResponse>> getDonationHistory() async {

    String apiPath = ApiRoutes.donationHistory;
    final data = await handleResponse(await buildHttpResponse(apiPath));
    return (data['data'] as List).map((e) => DonationhistoryResponse.fromJson(e)).toList();
  }


  Future<InitPaymentResponse> initiatePaymentIntent(InitPaymentRequest request) async {

    String apiPath = ApiRoutes.initiatePaymentIntent;
    final resp = await handleResponse(await buildHttpResponse(apiPath, method: HttpMethodType.POST, request: request.toJson()));
    return InitPaymentResponse.fromJson(resp);
  }


  Future<UpdatePaymentResponse> updatePaymentIntent(UpdatePaymentRequest request, {required reference}) async {

    String apiPath = ApiRoutes.setPaymentStatus+'/'+reference;
    final resp = await handleResponse(await buildHttpResponse(apiPath, method: HttpMethodType.POST, request: request.toJson()));
    return UpdatePaymentResponse.fromJson(resp);
  }


  Future<CheckPaymentStatusResponse> checkPaymentStatus({required reference}) async {

    String apiPath = ApiRoutes.paymentStatus+'/'+reference;
    final resp = await handleResponse(await buildHttpResponse(apiPath, method: HttpMethodType.GET));
    return CheckPaymentStatusResponse.fromJson(resp);
  }

}

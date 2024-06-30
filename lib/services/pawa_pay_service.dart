import 'dart:convert';
import 'dart:developer';

import 'package:cs_give/core/constants/api_routes.dart';
import 'package:cs_give/core/constants/pawa_token.dart';
import 'package:cs_give/models/deposit_status.dart';
import 'package:cs_give/models/stock_request.dart';
import 'package:cs_give/models/stock_request_user.dart';
import 'package:cs_give/repository/mobile_money.dart';
import 'package:cs_give/services/network_utils.dart';
import 'package:http/http.dart';

class PawaPay implements MobileMobileFascade {
  @override
  Future<String?> createRequest(MobileMoneyRequest request) async {
    final res = await post(
      Uri.parse(MoneyMoneyApiRoutes.baseUrl + MoneyMoneyApiRoutes.paymentPage),
      body: json.encode(request.toMap()),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $PAWA_TOKEN',
      },
    );

    log('createRequest() -> ${request.toMap()}');
    log('createRequest() -> ${res.body}');

    final data = jsonDecode(res.body) as Map;
    if (data.containsKey('redirectUrl')) {
      await saveDataToFirebase(request.depositId);
      return jsonDecode(res.body)['redirectUrl'];
    }

    return null;
  }

  @override
  Future<DepositStatus?> checkDepositStatus(String id) async {
    final data = await handleResponse(await buildHttpResponse(
        '${MoneyMoneyApiRoutes.baseUrl}${MoneyMoneyApiRoutes.deposit}/$id'));
    if ((data as List).isEmpty) return null;

    final status = DepositStatus.fromJson((data).firstOrNull);
    saveDataToFirebase(id, status: status);
    return status;
  }

  @override
  Future<void> saveDataToFirebase(String depositId, {DepositStatus? status}) async {
    // final data =
    //     await stockReqRef.where('depositId', isEqualTo: depositId).get();
    // if (data.docs.isNotEmpty) {
    //   final oldData = data.docs.first;

    //   await stockReqRef.doc(oldData.id).update(
    //         oldData
    //             .data()
    //             .copyWith(updatedOn: DateTime.now(), status: status)
    //             .toMap(),
    //       );
    // } else {
    //   await stockReqRef.add(
    //     UserStockRequest(
    //       userId: userServices.id,
    //       depositId: depositId,
    //       updatedOn: DateTime.now(),
    //       createdOn: DateTime.now(),
    //     ),
    //   );
    // }
  }

  Future<List<UserStockRequest>> getAllRequests() async {
    return List.empty();
    // final data =
    //     await stockReqRef.where('userId', isEqualTo: userServices.id).get();

    // if (data.docs.isEmpty) return List.empty();
    // final returnData = data.docs.map((e) => e.data()).toList();
    // returnData.sort((a, b) => b.updatedOn.compareTo(a.updatedOn));
    // for (var data in returnData) {
    //   if (data.status?.status != 'COMPLETED' &&
    //       DateTime.now().difference(data.createdOn).inMinutes < 5) {
    //     pawaPay.checkDepositStatus(data.depositId);
    //   }
    // }

    // return returnData;
  }
}

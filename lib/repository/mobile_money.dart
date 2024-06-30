import 'package:cs_give/models/deposit_status.dart';
import 'package:cs_give/models/stock_request.dart';

abstract class MobileMobileFascade {
  Future<String?> createRequest(MobileMoneyRequest request);
  Future<DepositStatus?> checkDepositStatus(String id);
  Future<void> saveDataToFirebase(String depositId, {DepositStatus? status});
}

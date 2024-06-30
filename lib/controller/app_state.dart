import 'dart:convert';

import 'package:cs_give/core/constants/app_constants.dart';
import 'package:cs_give/models/church_data.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

class AppState extends GetxController {
  RxBool isLoading = false.obs;
  RxString appToken = ''.obs;
  Church? church;

  AppState() {
    _setData();
  }

  _setData() {
    appToken.value = getStringAsync(LocalKeys.kUserToken);
    if (getStringAsync(LocalKeys.kUserChurch).validate().isNotEmpty) {
      church =
          Church.fromJson(jsonDecode(getStringAsync(LocalKeys.kUserChurch)));
      log('Setting Church: $church');
    }
  }

  void setLoading(bool val) {
    isLoading.value = val;
    update();
  }

  void setAppToken(String val) {
    appToken.value = val;
    setValue(LocalKeys.kUserToken, val);
    update();
  }

  void setChurch(Church ch) {
    church = ch;
    setValue(LocalKeys.kUserChurch, jsonEncode(ch));
  }

  void removeData() {
    appToken.value = '';
    clearSharedPref();
  }
}

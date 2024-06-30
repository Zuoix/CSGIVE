import 'package:cs_give/app.dart';
import 'package:cs_give/core/utils/common.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

class ChangepasswordContoller extends GetxController {

  final changepasswordKey = GlobalKey<FormState>();



  final oldPasswordTexC = TextEditingController();
  final passwordTexC = TextEditingController();
  final confirmPasswordTexC = TextEditingController();

  final oldPasswordFocus = FocusNode();
  final passwordFocus = FocusNode();
  final confirmPasswordFocus = FocusNode();

  Future<void> changepassword() async {
    if (changepasswordKey.currentState!.validate()) {
      setLoading(true);
      try {
        final resp = await authServices.changepassword(
          oldPasswordTexC.text.validate(),
          passwordTexC.text.validate(),
          confirmPasswordTexC.text.validate(),
        );

        if (resp != null) {
          showSuccess(resp.message);
        }
      } catch (e) {
       // showError(e.toString());
      } finally {
        setLoading(false);
      }
    }
  }



}

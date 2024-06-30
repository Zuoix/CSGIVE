import 'package:cs_give/app.dart';
import 'package:cs_give/controller/app_state.dart';
import 'package:cs_give/core/constants/app_constants.dart';
import 'package:cs_give/core/utils/common.dart';
import 'package:cs_give/models/request/register_request.dart';
import 'package:cs_give/screens/auth/phone_screen.dart';
import 'package:cs_give/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

class AuthContoller extends GetxController {
  final _auth = FirebaseAuth.instance;

  final loginKey = GlobalKey<FormState>();
  final registerKey = GlobalKey<FormState>();

  final pinInputTec = TextEditingController();
  String otpNumber = '';
  String? _verificationId;
  bool phoneVerificationFail = false;

  bool otpSent = false;

  final fNameTec = TextEditingController();
  final lNameTec = TextEditingController();
  final phoneTec = TextEditingController();
  final emailTec =
      TextEditingController(text: kDebugMode ? kDefaultLoginEmail : '');
  final passTec =
      TextEditingController(text: kDebugMode ? kDefaultLoginPassword : '');
  final confirmPassTec = TextEditingController();

  final fNameFocus = FocusNode();
  final lNameFocus = FocusNode();
  final emailFocus = FocusNode();
  final passFocus = FocusNode();
  final confirmPassFocus = FocusNode();

  int? selectedChurch;

  String dialCode = kDefaultCountry;

  void changeDialCode(String val) {
    dialCode = val;
  }

  Future<void> login() async {
    if (loginKey.currentState!.validate()) {
      setLoading(true);

      final resp = await authServices.login(
          emailTec.text.validate(), passTec.text.validate());

      setLoading(false);

      if (resp != null) {
        setValue(LocalKeys.kUserEmail, emailTec.text.trim());

        Get.find<AppState>().setAppToken(resp.token);
        churchServices.getCurrentChurch(resp.token);
        Get.offAll(() => const HomeScreen());
      }
    }
  }

  void switchToOtp(bool val) {
    otpSent = val;
    update();
  }

  void selectChurch(int? val) {
    selectedChurch = val;
    update();
  }

  void phoneVerification() {
    if (registerKey.currentState!.validate()) {
      Get.to(() => const PhoneScreen());
    }
  }

  Future<void> register() async {
    setLoading(true);

    final request = RegisterRequest(
      email: emailTec.text.trim(),
      password: passTec.text.trim(),
      firstName: fNameTec.text.trim(),
      lastName: lNameTec.text.trim(),
      countryCode: dialCode,
      phone: '$dialCode${phoneTec.text}',
      churchId: selectedChurch!.toString(),
      fcmToken: (await FirebaseMessaging.instance.getToken())!,
    );

    final String? appToken = await authServices.register(request);

    setLoading(false);

    if (appToken != null) {
      setValue(LocalKeys.kUserEmail, emailTec.text.trim());

      Get.find<AppState>().setAppToken(appToken);
      churchServices.getCurrentChurch(appToken);
      Get.offAll(() => const HomeScreen());
    }
  }

  Future loginWithOTP() async {
    log("loginWithOTP() $dialCode${phoneTec.text}");

    return await _auth.verifyPhoneNumber(
      phoneNumber: '$dialCode${phoneTec.text}',
      verificationCompleted: (PhoneAuthCredential credential) {
        showSuccess('Verified');
      },
      verificationFailed: (FirebaseAuthException e) {
        setLoading(false);

        phoneVerificationFail = true;

        if (e.code == 'invalid-phone-number') {
          showError('The entered code is invalid, please try again');
        } else {
          toast(e.toString(), print: true);
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        showSuccess('OTP Code is sent to your mobile number');

        setLoading(false);

        phoneVerificationFail = false;
        _verificationId = verificationId;

        otpNumber = '';
        pinInputTec.clear();

        switchToOtp(true);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        //
      },
    );
  }

  Future<void> verifyOTP() async {
    AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!, smsCode: otpNumber);

    setLoading(true);
    _auth.signInWithCredential(credential).then((credentials) async {
      await register();
    }).catchError((e) {
      phoneVerificationFail = true;

      if (e.code.toString() == 'invalid-verification-code') {
        showError('The entered code iss invalid, please try again');
      } else {
        showError(e.message.toString());
      }
      setLoading(false);
    });
  }
}

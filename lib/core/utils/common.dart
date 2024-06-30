import 'package:cs_give/controller/app_state.dart';
import 'package:cs_give/core/constants/app_constants.dart';
import 'package:cs_give/core/theme/colors.dart';
import 'package:cs_give/screens/auth/sign_in_screen.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart' as g;
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/app_texts.dart';

String getGreeting() {
  var hour = DateTime.now().hour;

  if (hour < 12) {
    return 'Good Morning!';
  } else if (hour < 17) {
    return 'Good Afternoon!';
  } else {
    return 'Good Evening!';
  }
}

void checkLogin(Function afterThat) {
  if (isLoggedIn()) {
    afterThat.call();
  } else {
    showError('You must be logged in');
    g.Get.to(() => const SignInScreen());
  }
}

bool isLoggedIn() {
  return Get.find<AppState>().appToken.value.isNotEmpty;
}

void setLoading(bool val) {
  Get.find<AppState>().setLoading(val);
}

Future<void> showSuccess(String message, {String? title}) async {
  await Get.closeCurrentSnackbar();
  Get.showSnackbar(
    GetSnackBar(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
      backgroundColor: const Color(0xFF50C878),
      title: title ?? 'Success',
      message: message.capitalizeFirst,
    ),
  );
}

Future<void> showError(String message, {String? title}) async {
  await Get.closeCurrentSnackbar();
  Get.showSnackbar(
    GetSnackBar(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.red,
      title: title ?? 'Error',
      message: message.capitalizeFirst,
    ),
  );
}

Future<DateTime> pickDate(BuildContext context, {DateTime? initialDate}) async {
  final date = await showDatePicker(
    context: context,
    firstDate: DateTime(2010),
    lastDate: DateTime(2030),
    initialDate: initialDate ?? DateTime.now(),
  );
  return date ?? initialDate ?? DateTime.now();
}

InputDecoration inputDecoration(BuildContext context,
    {Widget? prefixIcon,
    String? labelText,
    double? borderRadius,
    Color? fillColor,
    String? helperText,
    bool showBorder = true,
    bool isSearch = false}) {
  return InputDecoration(
    contentPadding:
        const EdgeInsets.only(left: 12, bottom: 10, top: 10, right: 10),
    hintText: labelText,
    hintStyle: secondaryText(
      color: kTextFieldHintColor,
      weight: isSearch ? FontWeight.w200 : FontWeight.w400,
      size: 15,
    ),
    alignLabelWithHint: true,
    prefixIcon: prefixIcon,
    enabledBorder: showBorder
        ? OutlineInputBorder(
            borderRadius: radius(borderRadius ?? defaultRadius),
            borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
          )
        : null,
    focusedErrorBorder: showBorder
        ? OutlineInputBorder(
            borderRadius: radius(borderRadius ?? defaultRadius),
            borderSide: const BorderSide(color: Colors.red, width: 0.0),
          )
        : null,
    errorBorder: showBorder
        ? OutlineInputBorder(
            borderRadius: radius(borderRadius ?? defaultRadius),
            borderSide: const BorderSide(color: Colors.red, width: 1.0),
          )
        : null,
    errorMaxLines: 2,
    border: showBorder
        ? OutlineInputBorder(
            borderRadius: radius(borderRadius ?? defaultRadius),
            borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
          )
        : null,
    disabledBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
    ),
    errorStyle: primaryText(color: Colors.red, size: showBorder ? 12 : 14),
    helperStyle: secondaryText(size: 14),
    focusedBorder: showBorder
        ? OutlineInputBorder(
            borderRadius: radius(borderRadius ?? defaultRadius),
            borderSide: const BorderSide(color: kPrimaryColor, width: 0.0),
          )
        : null,
    filled: true,
    floatingLabelBehavior:
        showBorder ? FloatingLabelBehavior.auto : FloatingLabelBehavior.never,
    fillColor: fillColor ?? context.cardColor,
    helperText: helperText,
  );
}

List<LanguageDataModel> languageList() {
  return [
    LanguageDataModel(
      id: 1,
      name: 'English',
      languageCode: 'en',
      fullLanguageCode: 'en-US',
      flag: 'assets/flags/ic_us.png',
    ),
  ];
}

Future<void> commonLaunchUrl(String address,
    {LaunchMode launchMode = LaunchMode.inAppWebView}) async {
  await launchUrl(Uri.parse(address), mode: launchMode).catchError((e) {
    toast('Invalid URL: $address');
  });
}

void launchCall(String? url) {
  if (url.validate().isNotEmpty) {
    if (isIOS) {
      commonLaunchUrl('tel://${url!}',
          launchMode: LaunchMode.externalApplication);
    } else {
      commonLaunchUrl('tel:${url!}',
          launchMode: LaunchMode.externalApplication);
    }
  }
}

void launchMap(String? url) {
  if (url.validate().isNotEmpty) {
    commonLaunchUrl(GOOGLE_MAP_PREFIX + url!,
        launchMode: LaunchMode.externalApplication);
  }
}

void launchMail(String url) {
  if (url.validate().isNotEmpty) {
    commonLaunchUrl('$MAIL_TO$url', launchMode: LaunchMode.externalApplication);
  }
}

void checkIfLink(String value, {String? title}) {
  if (value.validate().isEmpty) return;

  if (value.startsWith("https") || value.startsWith("http")) {
    launchUrl(Uri.parse(value));
  } else if (value.validateEmail()) {
    launchMail(value);
  } else if (value.validatePhone() || value.startsWith('+')) {
    launchCall(value);
  }
}

CurrencyTextInputFormatter currencyFormater() {
  return CurrencyTextInputFormatter(
    decimalDigits: 0,
    name: 'USD',
    symbol: '\$',
    locale: 'en_US',
  );
}
int parseCurrency(String value) {
  // Remove any non-numeric characters (except for the decimal point)
  final numericString = value.replaceAll(RegExp(r'[^\d.]'), '');
  return int.tryParse(numericString) ?? 0;
}
String parseCurrencyString(String value) {
  // Remove any non-numeric characters (except for the decimal point)
  final numericString = value.replaceAll(RegExp(r'[^\d.]'), '');
  return numericString ?? "0";
}

double parseCurrencyVal(String val) {
  try {
    String onlyDigits = val.replaceAll(RegExp('[^0-9]'), "");

    return double.parse(onlyDigits);
  } catch (e) {
    return 0;
  }
}

double getHeaderSize(BuildContext context) {
  return MediaQuery.of(context).size.height * 0.18;
}

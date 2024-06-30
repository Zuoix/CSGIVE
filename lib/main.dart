import 'dart:io';

import 'package:cs_give/app.dart';
import 'package:cs_give/controller/app_state.dart';
import 'package:cs_give/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'env.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Stripe.publishableKey = "pk_live_51Imq0HKSkIRE2FaD4P8yhQipFZVdn8qM3YishoP8sJUWl20qR0wr5srhBUp2LevOXtVJG3eqP2oXVsquX5CiwZxN00eYwGLJ9g";
 // Stripe.publishableKey = "pk_test_U0J5xXlOOdXWHzPLCwhAke9P";
  await dotenv.load(fileName: "assets/.env");
  Stripe.publishableKey = getPublishableKey();
  await Stripe.instance.applySettings();

  // Firebase Services
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // nb_utils
  await initialize();


  Get.put(AppState());

  HttpOverrides.global = MyHttpOverrides();

  runApp(const CSGiveApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

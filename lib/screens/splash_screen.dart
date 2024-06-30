import 'package:cs_give/app.dart';
import 'package:cs_give/core/constants/images.dart';
import 'package:cs_give/core/theme/colors.dart';
import 'package:cs_give/core/utils/common.dart';
import 'package:cs_give/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:nb_utils/nb_utils.dart';

import 'auth/sign_in_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    afterBuildCreated(() => _checkRoute());
  }

  void _checkRoute() {
    churchServices.getChurches().then((_) {
      if (isLoggedIn()) {
        const HomeScreen().launch(context,
            pageRouteAnimation: PageRouteAnimation.Fade, isNewTask: true);
      } else {
        const SignInScreen().launch(context,
            pageRouteAnimation: PageRouteAnimation.Fade, isNewTask: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [kPrimaryColor, kSecondaryColor],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Hero(
          tag: 'appLogo',
          child: Image.asset(
            appLogo,
            width: 200,
            height: 200,
          ).animate().fadeIn(duration: 600.ms).then(delay: 200.ms).slide(),
        ),
      ),
    );
  }
}

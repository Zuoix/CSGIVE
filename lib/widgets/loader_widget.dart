import 'package:cs_give/core/constants/app_constants.dart';
import 'package:cs_give/core/constants/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(appLogo, width: kLoaderSize, height: kLoaderSize)
          .animate(
            onPlay: (controller) => controller.repeat(reverse: true),
          )
          .fade(duration: 400.ms)
          .then(delay: 200.ms)
          .fadeOut(),
    );
  }
}

import 'package:cs_give/core/theme/colors.dart';
import 'package:flutter/material.dart';

import '../../widgets/app_texts.dart';


class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      appBarTheme: AppBarTheme(
        centerTitle: true,
        titleTextStyle: boldText(size: 20, weight: FontWeight.w600),
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: kPrimaryColor,
      ),
    );
  }
}

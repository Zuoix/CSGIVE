import 'package:cs_give/core/theme/colors.dart';
import 'package:flutter/material.dart';

extension StrExt on String {
  Widget iconImage({double? size, Color? color, BoxFit? fit}) {
    return Image.asset(
      this,
      height: size ?? 24,
      width: size ?? 24,
      fit: fit ?? BoxFit.cover,
      color: color ?? kPrimaryColor,
    );
  }

  String agrs(dynamic val1) {
    String returnVal = this;

    returnVal = returnVal.replaceFirst('{0}', val1.toString());
    return returnVal;
  }
}

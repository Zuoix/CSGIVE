
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../config/colors.dart';
import '../config/font_family.dart';
import '../config/size_config.dart';

// ignore: must_be_immutable
class ButtonCommon extends StatelessWidget {
  String? text;
  VoidCallback? onTap;
  Color? textColor;
  Color? buttonColor;
  ButtonCommon(
      {super.key, this.text, this.buttonColor, this.textColor, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeFile.height54,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SizeFile.height47),
        color: buttonColor ?? ColorFile.appColor,

      ),
      child: Text(text!,
        style: TextStyle(
          color: textColor ?? ColorFile.whiteColor,
          fontFamily: lexendMedium,
          fontWeight: FontWeight.w500,
          fontSize: SizeFile.height18,
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ShortButton extends StatelessWidget {
  String? text;
  Color? textColor;
  Color? buttonColor;
   ShortButton({super.key, this.text, this.textColor,this.buttonColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeFile.height48,
      width: MediaQuery.of(context).size.width/2.4,
      alignment: Alignment.center,
      // margin: const EdgeInsets.only(left: SizeFile.height12,bottom: SizeFile.height12),
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(SizeFile.height47.h),
      ),
      child:  Text(text ?? "",
          style: TextStyle(
              color: textColor ?? ColorFile.whiteColor,
              fontFamily: lexendMedium,
              fontWeight: FontWeight.w500,
              fontSize: SizeFile.height18)),);
  }
}

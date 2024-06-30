// import 'package:doc_time/util/size_config.dart';
// import 'package:flutter/material.dart';
//
// import 'colors.dart';
//
// // ignore: must_be_immutable
// class CommonAppbar extends StatelessWidget {
//   String? text;
//    CommonAppbar({super.key,this.text});
//
//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       backgroundColor: ColorFile.whiteColor,
//       elevation: 0,
//       title: Text(text ?? "",
//           style: TextStyle(
//               decorationColor: ColorFile.onBordingColor,
//               color: ColorFile.onBordingColor,
//               fontFamily: satoshiBold,
//               fontWeight: FontWeight.w400,
//               fontSize: SizeFile.height22)),
//       centerTitle: true,
//       leading: GestureDetector(
//           onTap: (){
//             Get.back();
//           },
//           child: Padding(
//             padding: const EdgeInsets.only(left:SizeFile.height1,top: SizeFile.height20,bottom: SizeFile.height20,),
//             child: Image.asset(AssetImagePaths.backArrow2,
//                 height:SizeFile.height18,
//                 width: SizeFile.height18,color: ColorFile.onBordingColor),
//           )
//         ),
//      );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../config/colors.dart';
import '../config/font_family.dart';
import '../config/size_config.dart';
import '../controller/dark_mode_controller.dart';
import 'assete_icon_paths.dart';

commonAppBar(BuildContext? context,{String? title,bool commonAppBar=false}){
  DarkModeController darkModeController = Get.put(DarkModeController());
  return AppBar(
    elevation: 0,
    backgroundColor: darkModeController.isLightTheme.value ? ColorFile.whiteColor : ColorFile.darkModeColor, //ColorFile.whiteColor,
    title: Text(title.toString(),
      style:TextStyle(
          fontSize: SizeFile.height22.sp,
          fontWeight: FontWeight.w500,
          color: darkModeController.isLightTheme.value ? ColorFile.appbarTitleColor : ColorFile.whiteColor,
          fontFamily: lexendMedium)),
    leading: commonAppBar == false
        ? IconButton(
      splashRadius: SizeFile.height15,
      onPressed: (){
        Navigator.pop(context!);
      },
      icon: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Image.asset(AssetIconPaths.backArrow,height: SizeFile.height24.h,width: SizeFile.height24.w,
          color: darkModeController.isLightTheme.value ? ColorFile.appbarTitleColor : ColorFile.whiteColor,),
      )
    )
        : const SizedBox(),
  );
}

commonAppBarAppIcon(BuildContext? context,{String? title}){
  DarkModeController darkModeController = Get.put(DarkModeController());
  return AppBar(
    elevation: 0,
    backgroundColor: darkModeController.isLightTheme.value ? ColorFile.whiteColor : ColorFile.darkModeColor,
    title: Text(title.toString(),
      style:TextStyle(
          fontSize: SizeFile.height22.sp,
          fontWeight: FontWeight.w500,
          color: darkModeController.isLightTheme.value
              ?  ColorFile.appbarTitleColor
              : ColorFile.whiteColor,

          fontFamily: lexendMedium),),
    leading: IconButton(
      splashRadius: SizeFile.height15,
      onPressed: (){
        // Navigator.pop(context!);
      },
      icon: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Image.asset(AssetIconPaths.appLogo,height: SizeFile.height24.h,width: SizeFile.height24.w,),
      )
    ),
    actions:
    [
      Padding(
        padding: EdgeInsets.only(right: SizeFile.height20.w),
        child: Image.asset(AssetIconPaths.searchIcon,
          height: SizeFile.height20.h,
          width: SizeFile.height20.w,
        color: darkModeController.isLightTheme.value
            ? ColorFile.appbarTitleColor:ColorFile.whiteColor),
      )
    ],
  );
}

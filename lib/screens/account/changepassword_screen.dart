import 'package:cs_give/controller/changepassword_controller.dart';
import 'package:cs_give/core/constants/images.dart';
import 'package:cs_give/core/theme/colors.dart';
import 'package:cs_give/core/utils/common.dart';
import 'package:cs_give/core/utils/extensions.dart';
import 'package:cs_give/widgets/app_scaffold.dart';
import 'package:cs_give/widgets/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

class ChangepasswordScreen extends StatefulWidget {
  const ChangepasswordScreen({super.key});

  @override
  State<ChangepasswordScreen> createState() => _ChangepasswordScreenState();
}

class _ChangepasswordScreenState extends State<ChangepasswordScreen> {
  @override
  void initState() {
    super.initState();

    Get.put(ChangepasswordContoller());
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChangepasswordContoller>(
      builder: (c) {
        return AppScaffold(
          appBar: AppBar(
            toolbarHeight: getHeaderSize(context),
            centerTitle: true,
            leading: const SizedBox(),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                color: kSecondaryColor,
                borderRadius: radiusOnly(bottomLeft: 20, bottomRight: 20),
              ),
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (Navigator.canPop(context))
                    Row(
                      children: [
                        Container(
                          decoration: boxDecorationWithRoundedCorners(
                            boxShape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () => pop(context),
                            icon:
                                const Icon(Icons.arrow_back_ios_new, size: 20),
                          ),
                        ).paddingRight(20),
                        Text(
                          'Change Password',
                          style: boldText(
                              weight: FontWeight.w600, size: 22, color: white),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                  else
                    Text(
                      'Contact Us',
                      style: boldText(
                          weight: FontWeight.w600, size: 22, color: white),
                      textAlign: TextAlign.center,
                    ),
                  10.height,
                ],
              ),
            ),
          ),
          body: SafeArea(
            child: Form(
            key: c.changepasswordKey,
            child: AnimatedScrollView(
              children: [
                SizedBox(height: 50),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8), // Adjust the radius as needed
                    border: Border.all(color: Colors.grey), // Add a grey border
                  ),
                  child: AppTextField(
                    controller: c.oldPasswordTexC,
                    focus: c.oldPasswordFocus,
                    textFieldType: TextFieldType.PASSWORD,
                    suffixPasswordVisibleWidget: ic_show.iconImage(size: 10).paddingAll(14),
                    suffixPasswordInvisibleWidget: ic_hide.iconImage(size: 10).paddingAll(14),
                    decoration: inputDecoration(context, labelText: 'Enter your old password'),
                    autoFillHints: const [AutofillHints.password],
                    onFieldSubmitted: (s) {
                      c.changepassword();
                    },
                  ),
                ),
                20.height,
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8), // Adjust the radius as needed
                    border: Border.all(color: Colors.grey), // Add a grey border
                  ),
                  child: AppTextField(
                    controller: c.passwordTexC,
                    focus: c.passwordFocus,
                    textFieldType: TextFieldType.PASSWORD,
                    suffixPasswordVisibleWidget: ic_show.iconImage(size: 10).paddingAll(14),
                    suffixPasswordInvisibleWidget: ic_hide.iconImage(size: 10).paddingAll(14),
                    decoration: inputDecoration(context, labelText: 'Enter your new password'),
                    autoFillHints: const [AutofillHints.password],
                    onFieldSubmitted: (s) {
                      c.changepassword();
                    },
                  ),
                ),
                20.height,
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8), // Adjust the radius as needed
                    border: Border.all(color: Colors.grey), // Add a grey border
                  ),
                  child: AppTextField(
                    controller: c.confirmPasswordTexC,
                    focus: c.confirmPasswordFocus,
                    textFieldType: TextFieldType.PASSWORD,
                    suffixPasswordVisibleWidget: ic_show.iconImage(size: 10).paddingAll(14),
                    suffixPasswordInvisibleWidget: ic_hide.iconImage(size: 10).paddingAll(14),
                    decoration: inputDecoration(context, labelText: 'Confirm your new password'),
                    autoFillHints: const [AutofillHints.password],
                    onFieldSubmitted: (s) {
                      c.changepassword();
                    },
                  ),
                ),
                20.height,
                AppButton(
                  text: 'Change password',
                  textStyle: boldText(
                    color: white,
                    weight: FontWeight.w600,
                    size: 16,
                  ),
                  color: kSecondaryColor,
                  textColor: kPrimaryColor,
                  width: MediaQuery.of(context).size.width -
                      context.navigationBarHeight,
                  onTap: c.changepassword,
                ),
                20.height,
              ],
            ).paddingSymmetric(horizontal: 15),
            ),
          ),
        );
      },
    );
  }
}

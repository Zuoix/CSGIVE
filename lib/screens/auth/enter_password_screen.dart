import 'package:cs_give/core/constants/images.dart';
import 'package:cs_give/core/theme/colors.dart';
import 'package:cs_give/core/utils/common.dart';
import 'package:cs_give/core/utils/extensions.dart';
import 'package:cs_give/widgets/app_scaffold.dart';
import 'package:cs_give/widgets/app_scroll_view.dart';
import 'package:cs_give/widgets/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class EnterPasswordScreen extends StatelessWidget {
  const EnterPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      showBackButton: true,
      showBackground: true,
      body: Center(
        child: AppScrollView(
          children: [
            100.height,
            Column(
              children: [
                Text(
                  'Enter New Password',
                  style:
                      boldText(color: white, weight: FontWeight.w600, size: 30),
                ),
                10.height,
                Text(
                  'Enter your new password',
                  style:
                      boldText(color: white, weight: FontWeight.w500, size: 16),
                  textAlign: TextAlign.center,
                ),
                20.height,
              ],
            ).center(),
            AppTextField(
              autoFocus: true,
              textFieldType: TextFieldType.PASSWORD,
              textInputAction: TextInputAction.next,
              autoFillHints: const [AutofillHints.newPassword],
              suffixPasswordVisibleWidget:
                  ic_show.iconImage(size: 10).paddingAll(14),
              suffixPasswordInvisibleWidget:
                  ic_hide.iconImage(size: 10).paddingAll(14),
              errorThisFieldRequired: errorThisFieldRequired,
              decoration: inputDecoration(context, labelText: 'Password'),
            ),
            20.height,
            AppTextField(
              textFieldType: TextFieldType.PASSWORD,
              autoFillHints: const [AutofillHints.password],
              validator: (newPass) {
                return null;

                // if (c.passwordCont.text.isEmpty) {
                //   return 'Please enter password first';
                // }

                // if (newPass != c.passwordCont.text) {
                //   return "The password does not match";
                // }
                // return null;
              },
              suffixPasswordVisibleWidget:
                  ic_show.iconImage(size: 10).paddingAll(14),
              suffixPasswordInvisibleWidget:
                  ic_hide.iconImage(size: 10).paddingAll(14),
              errorThisFieldRequired: errorThisFieldRequired,
              decoration:
                  inputDecoration(context, labelText: 'Confirm Password'),
              onFieldSubmitted: (s) {
                // c.register(context);
              },
            ),
            20.height,
            AppButton(
              text: 'SAVE PASSWORD',
              textStyle: boldText(
                color: kSecondaryColor,
                wordSpacing: 1.5,
                weight: FontWeight.w600,
                size: 16,
              ),
              color: white,
              textColor: Colors.white,
              width: MediaQuery.of(context).size.width -
                  context.navigationBarHeight,
              onTap: () {},
            ),
          ],
        ).paddingSymmetric(horizontal: 20),
      ),
    );
  }
}

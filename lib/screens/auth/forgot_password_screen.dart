import 'package:cs_give/app.dart';
import 'package:cs_give/core/constants/images.dart';
import 'package:cs_give/core/theme/colors.dart';
import 'package:cs_give/core/utils/common.dart';
import 'package:cs_give/core/utils/extensions.dart';
import 'package:cs_give/widgets/app_scaffold.dart';
import 'package:cs_give/widgets/app_scroll_view.dart';
import 'package:cs_give/widgets/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailTec = TextEditingController();

  void _action() {
    if (emailTec.text.validateEmailEnhanced()) {
      setLoading(true);
      userServices
          .sendPasswordVerificationLink(emailTec.text.trim())
          .then((value) {
        setLoading(false);

        if (value.validate()) {
          finish(context);
        }
      });
    } else {
      showError('Enter valid email address', title: 'Validation');
    }
  }

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
                  'Forgot Password',
                  style:
                      boldText(color: white, weight: FontWeight.w600, size: 30),
                ),
                10.height,
                Text(
                  'Please enter your email to send link reset password',
                  style:
                      boldText(color: white, weight: FontWeight.w500, size: 16),
                  textAlign: TextAlign.center,
                ),
                20.height,
              ],
            ).center(),
            AppTextField(
              controller: emailTec,
              autoFocus: true,
              textFieldType: TextFieldType.EMAIL_ENHANCED,
              decoration: inputDecoration(context, labelText: 'Email Address'),
              suffix: ic_message.iconImage(size: 10).paddingAll(14),
              autoFillHints: const [AutofillHints.email],
              onFieldSubmitted: (s) {
                _action();
              },
            ),
            20.height,
            AppButton(
              text: 'SEND LINK',
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
              onTap: _action,
            ),
          ],
        ).paddingSymmetric(horizontal: 20),
      ),
    );
  }
}

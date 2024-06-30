import 'package:cs_give/controller/auth_controller.dart';
import 'package:cs_give/core/constants/images.dart';
import 'package:cs_give/core/theme/colors.dart';
import 'package:cs_give/core/utils/common.dart';
import 'package:cs_give/core/utils/extensions.dart';
import 'package:cs_give/screens/auth/forgot_password_screen.dart';
import 'package:cs_give/screens/auth/sign_up_screen.dart';
import 'package:cs_give/widgets/app_scaffold.dart';
import 'package:cs_give/widgets/app_scroll_view.dart';
import 'package:cs_give/widgets/app_texts.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  void initState() {
    super.initState();

    Get.put(AuthContoller());
  }

  @override
  Widget build(BuildContext context) {
    Widget header() {
      return Column(
        children: [
          Hero(
            tag: 'appLogo',
            child: Image.asset(appLogo, width: 120),
          ),
          10.height,
          Text(
            'CS - GIVE',
            style: boldText(color: white, weight: FontWeight.w700, size: 30),
          ),
          10.height,
          Text(
            'Welcome Back!',
            style: boldText(color: white, weight: FontWeight.w600, size: 20),
            textAlign: TextAlign.center,
          ),
          Text(
            'Sign In To Continue',
            style: boldText(color: white, weight: FontWeight.w600, size: 14),
            textAlign: TextAlign.center,
          ),
          20.height,
        ],
      ).center();
    }

    Widget forgotPassword() {
      return Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Forgot Password?',
          style: boldText(color: white, weight: FontWeight.w500, size: 15),
          textAlign: TextAlign.left,
        ).onTap(() {
          const ForgotPasswordScreen()
              .launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
        }),
      ).paddingSymmetric(vertical: 20);
    }

    return GetBuilder<AuthContoller>(
      builder: (c) {
        return AppScaffold(
          showBackground: true,
          body: Center(
            child: SafeArea(
              child: Form(
                key: c.loginKey,
                child: AppScrollView(
                  children: [
                    header(),
                    AppTextField(
                      controller: c.emailTec,
                      focus: c.emailFocus,
                      nextFocus: c.passFocus,
                      textFieldType: TextFieldType.EMAIL_ENHANCED,
                      decoration:
                          inputDecoration(context, labelText: 'Email Address'),
                      suffix: ic_message.iconImage(size: 10).paddingAll(14),
                      autoFillHints: const [AutofillHints.email],
                    ),
                    16.height,
                    AppTextField(
                      controller: c.passTec,
                      focus: c.passFocus,
                      textFieldType: TextFieldType.PASSWORD,
                      suffixPasswordVisibleWidget:
                          ic_show.iconImage(size: 10).paddingAll(14),
                      suffixPasswordInvisibleWidget:
                          ic_hide.iconImage(size: 10).paddingAll(14),
                      decoration:
                          inputDecoration(context, labelText: 'Password'),
                      autoFillHints: const [AutofillHints.password],
                      onFieldSubmitted: (s) {
                        c.login();
                      },
                    ),
                    forgotPassword(),
                    AppButton(
                      text: 'LOG IN',
                      textStyle: boldText(
                        color: kSecondaryColor,
                        weight: FontWeight.w600,
                        size: 16,
                      ),
                      color: white,
                      textColor: Colors.white,
                      width: MediaQuery.of(context).size.width -
                          context.navigationBarHeight,
                      onTap: c.login,
                    ),
                    20.height,
                    RichTextWidget(
                      list: [
                        TextSpan(
                          text: 'Don\'t have an account? ',
                          style: primaryText(
                            size: 15,
                            weight: FontWeight.w400,
                            color: white,
                          ),
                        ),
                        TextSpan(
                          text: 'Sign Up',
                          style: primaryText(
                              size: 15, weight: FontWeight.w700, color: white),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              hideKeyboard(context);
                              const SignUpScreen().launch(
                                context,
                                isNewTask: true,
                                pageRouteAnimation: PageRouteAnimation.Fade,
                              );
                            },
                        ),
                      ],
                    ).center(),
                  ],
                ).paddingSymmetric(horizontal: 20),
              ),
            ),
          ),
        );
      },
    );
  }
}

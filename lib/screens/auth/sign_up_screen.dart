import 'package:cs_give/app.dart';
import 'package:cs_give/controller/auth_controller.dart';
import 'package:cs_give/core/constants/images.dart';
import 'package:cs_give/core/theme/colors.dart';
import 'package:cs_give/core/utils/common.dart';
import 'package:cs_give/core/utils/extensions.dart';
import 'package:cs_give/screens/auth/sign_in_screen.dart';
import 'package:cs_give/widgets/app_scaffold.dart';
import 'package:cs_give/widgets/app_scroll_view.dart';
import 'package:cs_give/widgets/app_texts.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthContoller>(
      builder: (c) {
        return AppScaffold(
          showBackground: true,
          body: Center(
            child: SafeArea(
              child: Form(
                key: c.registerKey,
                child: AppScrollView(
                  children: [
                    Column(
                      children: [
                        Hero(
                          tag: 'appLogo',
                          child: Image.asset(appLogo, width: 120),
                        ),
                        10.height,
                        Text(
                          'CS - GIVE',
                          style: boldText(
                              color: white, weight: FontWeight.w700, size: 30),
                        ),
                        10.height,
                        Text(
                          'Create A New Account To Get Started!',
                          style: boldText(
                              color: white, weight: FontWeight.w600, size: 20),
                          textAlign: TextAlign.center,
                        ),
                        20.height,
                      ],
                    ).center(),
                    Column(
                      children: [
                        10.height,
                        AutofillGroup(
                          child: Row(
                            children: [
                              AppTextField(
                                controller: c.fNameTec,
                                focus: c.fNameFocus,
                                nextFocus: c.lNameFocus,
                                textFieldType: TextFieldType.NAME,
                                decoration: inputDecoration(context,
                                    labelText: 'First Name'),
                                autoFillHints: const [AutofillHints.givenName],
                                textInputAction: TextInputAction.next,
                              ).expand(),
                              20.width,
                              AppTextField(
                                controller: c.lNameTec,
                                focus: c.lNameFocus,
                                nextFocus: c.emailFocus,
                                textFieldType: TextFieldType.NAME,
                                errorThisFieldRequired: errorThisFieldRequired,
                                decoration: inputDecoration(context,
                                    labelText: 'Last Name'),
                                autoFillHints: const [AutofillHints.familyName],
                                textInputAction: TextInputAction.next,
                              ).expand(),
                            ],
                          ),
                        ),
                        20.height,
                        AppTextField(
                          controller: c.emailTec,
                          focus: c.emailFocus,
                          nextFocus: c.passFocus,
                          textFieldType: TextFieldType.EMAIL_ENHANCED,
                          errorThisFieldRequired: errorThisFieldRequired,
                          autoFillHints: const [AutofillHints.email],
                          decoration: inputDecoration(context,
                              labelText: 'Email Address'),
                          suffix: ic_message.iconImage(size: 10).paddingAll(14),
                        ),
                        20.height,
                        AppTextField(
                          controller: c.passTec,
                          focus: c.passFocus,
                          nextFocus: c.confirmPassFocus,
                          textFieldType: TextFieldType.PASSWORD,
                          textInputAction: TextInputAction.next,
                          autoFillHints: const [AutofillHints.newPassword],
                          suffixPasswordVisibleWidget:
                              ic_show.iconImage(size: 10).paddingAll(14),
                          suffixPasswordInvisibleWidget:
                              ic_hide.iconImage(size: 10).paddingAll(14),
                          errorThisFieldRequired: errorThisFieldRequired,
                          decoration:
                              inputDecoration(context, labelText: 'Password'),
                        ),
                        20.height,
                        AppTextField(
                          textFieldType: TextFieldType.PASSWORD,
                          autoFillHints: const [AutofillHints.password],
                          validator: (newPass) {
                            if (c.passTec.text.isEmpty) {
                              return 'Please enter password first';
                            }

                            if (newPass != c.passTec.text) {
                              return "The password does not match";
                            }
                            return null;
                          },
                          suffixPasswordVisibleWidget:
                              ic_show.iconImage(size: 10).paddingAll(14),
                          suffixPasswordInvisibleWidget:
                              ic_hide.iconImage(size: 10).paddingAll(14),
                          errorThisFieldRequired: errorThisFieldRequired,
                          decoration: inputDecoration(context,
                              labelText: 'Confirm Password'),
                          onFieldSubmitted: (s) {
                            c.phoneVerification();
                          },
                        ),
                      ],
                    ),
                    20.height,
                    DropdownButtonFormField<int>(
                      value: c.selectedChurch,
                      validator: (s) {
                        return s.validate(value: -1) == -1
                            ? 'Select Church to continue'
                            : null;
                      },
                      decoration:
                          inputDecoration(context, labelText: 'Select Church'),
                      items: cachedChurches!
                          .map(
                            (e) => DropdownMenuItem(
                              value: e.id,
                              child: Text(
                                e.name.capitalizeFirstLetter(),
                                style: primaryText(),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: c.selectChurch,
                    ),
                    20.height,
                    AppButton(
                      text: 'SIGN UP',
                      textStyle: boldText(
                        color: kSecondaryColor,
                        weight: FontWeight.w600,
                        size: 16,
                      ),
                      color: white,
                      textColor: Colors.white,
                      width: MediaQuery.of(context).size.width -
                          context.navigationBarHeight,
                      onTap: c.phoneVerification,
                    ),
                    20.height,
                    RichTextWidget(
                      list: [
                        TextSpan(
                          text: 'Already have an account? ',
                          style: primaryText(
                            size: 15,
                            weight: FontWeight.w400,
                            color: white,
                          ),
                        ),
                        TextSpan(
                          text: 'Sign In',
                          style: primaryText(
                              size: 15, weight: FontWeight.w700, color: white),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              hideKeyboard(context);
                              const SignInScreen().launch(
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

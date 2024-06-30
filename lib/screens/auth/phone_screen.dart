import 'package:country_code_picker/country_code_picker.dart';
import 'package:cs_give/controller/auth_controller.dart';
import 'package:cs_give/core/constants/app_constants.dart';
import 'package:cs_give/core/constants/images.dart';
import 'package:cs_give/core/theme/colors.dart';
import 'package:cs_give/core/utils/common.dart';
import 'package:cs_give/core/utils/extensions.dart';
import 'package:cs_give/widgets/app_scaffold.dart';
import 'package:cs_give/widgets/app_scroll_view.dart';
import 'package:cs_give/widgets/app_texts.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pinput/pinput.dart';

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthContoller>(
      builder: (c) {
        return AppScaffold(
          showBackground: true,
          body: SafeArea(
            child: Center(
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
                        c.otpSent
                            ? 'Enter Your Security Code'
                            : 'Enter Your Mobile Number',
                        style: boldText(
                            color: white, weight: FontWeight.w600, size: 20),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        c.otpSent
                            ? 'Enter the six digit code sent to your phone number'
                            : 'We will send you a security code to verify',
                        style: boldText(
                            color: white, weight: FontWeight.w600, size: 14),
                        textAlign: TextAlign.center,
                      ),
                      20.height,
                    ],
                  ).center(),
                  20.height,
                  AnimatedCrossFade(
                    firstChild: AppTextField(
                      controller: c.phoneTec,
                      textFieldType: TextFieldType.PHONE,
                      errorThisFieldRequired: errorThisFieldRequired,
                      autoFillHints: const [AutofillHints.telephoneNumber],
                      validator: (s) {
                        if (s.validatePhone()) return null;
                        return 'Invalid Phone Number';
                      },
                      decoration: inputDecoration(
                        context,
                        labelText: 'Phone Number',
                        prefixIcon: CountryCodePicker(
                          initialSelection: 'US',
                          favorite: const [kDefaultCountry],
                          onChanged: (cs) => c.changeDialCode(cs.dialCode!),
                        ),
                      ).copyWith(
                        hintStyle: secondaryText(),
                      ),
                      suffix: ic_call.iconImage(size: 10).paddingAll(14),
                    ),
                    secondChild: Pinput(
                      length: 6,
                      onChanged: (val) {
                        c.otpNumber = val;
                      },
                      pinAnimationType: PinAnimationType.fade,
                      controller: c.pinInputTec,
                      defaultPinTheme: PinTheme(
                        width: 60,
                        height: 60,
                        textStyle:
                            primaryText(color: kSecondaryColor, size: 20),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: kPrimaryColor.withOpacity(0.5)),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                      ),
                    ),
                    crossFadeState: c.otpSent
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 500),
                  ),
                  20.height,
                  if (c.otpSent) ...{
                    Align(
                      alignment: Alignment.center,
                      child: InkWell(
                        onTap: () {
                          c.switchToOtp(false);
                        },
                        child: Text(
                          'Change mobile number',
                          style: boldText(
                              color: white, weight: FontWeight.w500, size: 15),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    if (c.phoneVerificationFail || kDebugMode)
                      Align(
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: () {
                            c.loginWithOTP();
                          },
                          child: Text(
                            'Resend OTP',
                            style: boldText(
                                color: white,
                                weight: FontWeight.w500,
                                size: 15),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  },
                  30.height,
                  AppButton(
                    text: c.otpSent ? 'VERIFY' : 'SUBMIT',
                    textStyle: boldText(
                      color: kSecondaryColor,
                      weight: FontWeight.w600,
                      size: 16,
                    ),
                    color: white,
                    textColor: Colors.white,
                    width: MediaQuery.of(context).size.width -
                        context.navigationBarHeight,
                    onTap: () {
                      c.otpSent ? c.verifyOTP() : c.loginWithOTP();
                    },
                  ),
                ],
              ).paddingSymmetric(horizontal: 20),
            ),
          ),
        );
      },
    );
  }
}

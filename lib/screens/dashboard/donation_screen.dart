import 'package:cs_give/controller/donation_controller.dart';
import 'package:cs_give/core/constants/app_constants.dart';
import 'package:cs_give/core/theme/colors.dart';
import 'package:cs_give/core/utils/common.dart';
import 'package:cs_give/widgets/app_scaffold.dart';
import 'package:cs_give/widgets/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../models/donation_type_data.dart';


class DonationScreen extends StatefulWidget {
  const DonationScreen({super.key});

  @override
  State<DonationScreen> createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    Get.put(DonationController());
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DonationController>(
      builder: (c) {
        c.getDonationHistory();
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
                          'Donation',
                          style: boldText(
                              weight: FontWeight.w600, size: 22, color: white),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                  else
                    Text(
                      'Donation',
                      style: boldText(
                          weight: FontWeight.w600, size: 22, color: white),
                      textAlign: TextAlign.center,
                    ),
                  10.height,
                  Text(
                    'You are about to make a donation. Enter details below to continue',
                    style: boldText(
                        weight: FontWeight.w500, size: 16, color: white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          body: SafeArea(
              child: Form(
                    key: _formKey,
                    child: AnimatedScrollView(
              children: [
                10.height,
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.42,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.5,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (_, index) {
                      return InkWell(
                        onTap: () {
                          c.chooseAmount(donationAmounts[index]);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          decoration: boxDecorationWithRoundedCorners(
                            borderRadius: radius(16),
                            backgroundColor: c.amountCont.text.toInt() ==
                                    donationAmounts[index]
                                ? kPrimaryColor
                                : const Color(0xFFF9FAFB),
                          ),
                          child: Center(
                            child: Text(
                              '\$${donationAmounts.elementAt(index)}',
                              style: boldText(
                                weight: FontWeight.w500,
                                color: c.amountCont.text.toInt() !=
                                        donationAmounts[index]
                                    ? black
                                    : white,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: donationAmounts.length,
                  ).paddingSymmetric(horizontal: 15),
                ),
                if (!donationAmounts.contains(c.amountCont.text.toInt())) ...{

                  AppTextField(
                    inputFormatters: [currencyFormater()],
                    controller: c.amountCont,
                    validator: (s) {
                      final val = parseCurrencyVal(s.validate());
                      return val < kMinAmount
                          ? '${NumberFormat.simpleCurrency(name: 'USD', decimalDigits: 0).format(kMinAmount)} is the minimum requirement'
                          : null;
                    },
                    textFieldType: TextFieldType.NUMBER,
                    keyboardType: TextInputType.number,
                    decoration:
                        inputDecoration(context, labelText: 'Enter Amount'),
                  ).paddingSymmetric(vertical: 20),
                },
                Text(
                  'Choose Payment Method',
                  style: secondaryText(
                    color: kTextFieldHintColor,
                    weight: FontWeight.w400,
                    size: 15,
                  ),
                ).paddingBottom(15),
                Wrap(
                  runSpacing: 15,
                  spacing: 15,
                  children: paymentMethods
                      .map(
                        (e) => InkWell(
                          onTap: () {
                            c.selectPaymentMethod(e);
                          },
                          child: Chip(
                            backgroundColor: c.selectedPaymentMethod == e
                                ? kPrimaryColor
                                : null,
                            label: Text(
                              e,
                              style: primaryText(
                                color:
                                    c.selectedPaymentMethod == e ? white : null,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                15.height,
                DropdownButtonFormField<String>(
                  validator: (s) {
                    return s.validate().isEmpty ? errorThisFieldRequired : null;
                  },
                  decoration:
                      inputDecoration(context, labelText: 'Select Frequency'),
                  items: frequencies
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(e, style: primaryText()),
                        ),
                      )
                      .toList(),
                  onChanged: (s) => c.selectFrequency(s),
                ),
                15.height,
                DropdownButtonFormField<DonationType>(
                  validator: (s) {
                    return s == null ? errorThisFieldRequired : null;
                  },
                  decoration: inputDecoration(context,
                      labelText: 'Select Donation Type'),
                  items: c.donationTypes
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.donationType, style: primaryText()),
                        ),
                      )
                      .toList(),
                  onChanged: (s) => c.selectDonationType(s),
                ),
                20.height,
                AppButton(
                  text: 'GIVE',
                  textStyle: boldText(
                    color: white,
                    weight: FontWeight.w600,
                    size: 16,
                  ),
                  color: kSecondaryColor,
                  textColor: kPrimaryColor,
                  width: MediaQuery.of(context).size.width -
                      context.navigationBarHeight,
                  onTap: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      c.donate();
                    }
                  },
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





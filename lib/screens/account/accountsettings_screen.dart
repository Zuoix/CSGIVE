import 'package:cs_give/controller/donation_controller.dart';
import 'package:cs_give/core/theme/colors.dart';
import 'package:cs_give/core/utils/common.dart';
import 'package:cs_give/widgets/app_scaffold.dart';
import 'package:cs_give/widgets/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cs_give/core/constants/images.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:cs_give/screens/account/changepassword_screen.dart';

class AccountsettingsScreen extends StatefulWidget {
  const AccountsettingsScreen({super.key});

  @override
  State<AccountsettingsScreen> createState() => _DonationScreenState();
}

class _DonationScreenState extends State<AccountsettingsScreen> {
  @override
  void initState() {
    super.initState();

    Get.put(DonationController());
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DonationController>(
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
                          'Account Settings',
                          style: boldText(
                              weight: FontWeight.w600, size: 22, color: white),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                  else
                    Text(
                      'Account Settings',
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
            child: AnimatedScrollView(
              children: [
                10.height,
                ListTile(
                  onTap: () {
                    Get.to(() => ChangepasswordScreen());
                  },
                  title: Text(
                    'Change Password',
                    style: primaryText(
                      size: 18,
                      weight: FontWeight.w400,
                    ),
                  ),
                  trailing: Image.asset(forward_button),
                ).paddingBottom(10),
              ],
            ).paddingSymmetric(horizontal: 15),
          ),
        );
      },
    );
  }
}

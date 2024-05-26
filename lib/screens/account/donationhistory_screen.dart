import 'package:cs_give/controller/donation_controller.dart';
import 'package:cs_give/core/theme/colors.dart';
import 'package:cs_give/core/utils/common.dart';
import 'package:cs_give/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../models/response/donationhistory_response.dart';
import '../../widgets/app_texts.dart';

class DonationhistoryScreen extends StatefulWidget {
  const DonationhistoryScreen({super.key});

  @override
  State<DonationhistoryScreen> createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationhistoryScreen> {
  @override
  void initState() {
    super.initState();

    Get.put(DonationController());
  }

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final rectangleWidthPercentage = 0.8; // 80% of screen width

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
                          'Donation History',
                          style: boldText(
                              weight: FontWeight.w600, size: 22, color: white),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                  else
                    Text(
                      'Donation History',
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
                20.height,
                Text(
                  'This month',
                  style: boldText(
                      weight: FontWeight.w600, size: 22, color: black),
                  textAlign: TextAlign.center,
                ),
                if (c.donationsThisMonth.isEmpty)
                  Center(
                    child: Text(
                      'No donations this month',
                      style: boldText(
                          weight: FontWeight.w400, size: 18, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  )
                else
                ...c.donationsThisMonth.map((donation) {
                  return DonationTile(
                    screenWidth: screenWidth,
                    rectangleWidthPercentage: rectangleWidthPercentage,
                    donation: donation,
                  );
                }).toList(),
                20.height,
                Text(
                  'Last month',
                  style: boldText(
                      weight: FontWeight.w600, size: 22, color: black),
                  textAlign: TextAlign.center,
                ),
                if (c.donationsLastMonth.isEmpty)
                  Center(
                    child: Text(
                      'No donations last month',
                      style: boldText(
                          weight: FontWeight.w400, size: 18, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  )
                else
                  ...c.donationsLastMonth.map((donation) {
                    return DonationTile(
                      screenWidth: screenWidth,
                      rectangleWidthPercentage: rectangleWidthPercentage,
                      donation: donation,
                    );
                  }).toList(),
              ],
            ).paddingSymmetric(horizontal: 20),
          ),
        );
      },
    );
  }

}

class DonationTile extends StatelessWidget {
  const DonationTile({
    Key? key,
    required this.screenWidth,
    required this.rectangleWidthPercentage,
    required this.donation,
  }) : super(key: key);

  final double screenWidth;
  final double rectangleWidthPercentage;
  final DonationhistoryResponse donation;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: (screenWidth - (screenWidth * rectangleWidthPercentage)) / 3,
        top: 10,
      ),
      width: screenWidth * rectangleWidthPercentage,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: 295,
        height: 68,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 10),
            Stack(
              children: [
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    color: Color(0xFFEFF9FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/icons/donate_hist_icon.png'),
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  donation.donationType,
                  style: TextStyle(
                      fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 10),
                Text(
                  '${DateFormat('MMMM d, yyyy').format(donation.createdAt)} - ${donation.statusMessage}',
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400),
                ),
                if (donation.paymentReference != null)
                  Text(
                    'Reference: ${donation.paymentReference}',
                    style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w400),
                  ),
              ],
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '\$${donation.amount}',
                  style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF2979F2),
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}
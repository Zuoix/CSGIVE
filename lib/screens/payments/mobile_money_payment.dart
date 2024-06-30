import 'package:cs_give/controller/donation_controller.dart';
import 'package:cs_give/widgets/app_scaffold.dart';
import 'package:cs_give/widgets/loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MobileMoneyPayment extends StatelessWidget {
  const MobileMoneyPayment({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DonationController>(
      builder: (c) {
        return AppScaffold(
          appBar: AppBar(),
          body: c.controller == null
              ? const LoaderWidget()
              : WebViewWidget(controller: c.controller!),
        );
      },
    );
  }
}

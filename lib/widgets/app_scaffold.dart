// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cs_give/controller/app_state.dart';
import 'package:cs_give/core/theme/colors.dart';
import 'package:cs_give/widgets/loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final AppBar? appBar;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final Widget? bottomSheet;
  final FloatingActionButton? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  final bool showBackground;
  final bool showBackButton;

  const AppScaffold({
    Key? key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.drawer,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.showBackButton = false,
    this.showBackground = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appState = Get.find<AppState>();

    return Stack(
      children: [
        Scaffold(
          body: Stack(
            children: [
              if (showBackground)
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [kPrimaryColor, kSecondaryColor],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              if (showBackButton)
                SafeArea(
                  child: Container(
                    margin: EdgeInsets.only(
                        left: 20,
                        top: MediaQuery.of(context).size.height * 0.05),
                    decoration: boxDecorationWithRoundedCorners(
                      boxShape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () => finish(context),
                      icon: const Icon(Icons.arrow_back_ios_new),
                    ),
                  ),
                ),
              GetBuilder<AppState>(
                builder: (c) {
                  return AnimatedOpacity(
                    opacity: c.isLoading.value ? 0.5 : 1.0,
                    duration: const Duration(milliseconds: 500),
                    child: body,
                  );
                },
              )
            ],
          ),
          appBar: appBar,
          drawer: drawer,
          bottomSheet: bottomSheet,
          bottomNavigationBar: bottomNavigationBar,
          floatingActionButton: floatingActionButton,
          floatingActionButtonLocation: floatingActionButtonLocation,
        ),
        Obx(() =>
            appState.isLoading.value ? const LoaderWidget() : const Offstage())
      ],
    );
  }
}

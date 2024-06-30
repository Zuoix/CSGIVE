// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class AppScrollView extends StatelessWidget {
  final List<Widget> children;
  final Future<void> Function()? onSwipeRefresh;

  const AppScrollView({
    Key? key,
    required this.children,
    this.onSwipeRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedScrollView(
      padding: const EdgeInsets.only(bottom: 16),
      physics: const AlwaysScrollableScrollPhysics(),
      crossAxisAlignment: CrossAxisAlignment.start,
      listAnimationType: ListAnimationType.Slide,
      fadeInConfiguration:
          FadeInConfiguration(duration: const Duration(seconds: 2)),
      onSwipeRefresh: onSwipeRefresh,
      children: children,
    );
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cs_give/models/church_data.dart';
import 'package:cs_give/screens/map_view.dart';
import 'package:cs_give/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';

class ChurchMapView extends StatelessWidget {
  final List<Church> churches;

  const ChurchMapView({
    Key? key,
    required this.churches,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: MapView(
            churchList: churches,
          ),
        ),
      ),
    );
  }
}

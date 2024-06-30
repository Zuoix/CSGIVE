// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cs_give/core/theme/colors.dart';
import 'package:cs_give/core/utils/common.dart';
import 'package:cs_give/models/church_data.dart';
import 'package:cs_give/services/location_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';

class MapView extends StatefulWidget {
  final List<Church> churchList;
  final bool miniView;

  const MapView({
    Key? key,
    required this.churchList,
    this.miniView = false,
  }) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  GoogleMapController? _controller;

  Future<void> onMapCreated(GoogleMapController controller) async {
    _controller = controller;
    String value = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json');
    _controller?.setMapStyle(value);
    _getCurrentLocation();
    _controller
        ?.showMarkerInfoWindow(MarkerId(widget.churchList.first.id.toString()));
  }

  // Method for retrieving the current location
  void _getCurrentLocation() async {
    await getUserLocationPosition().then((position) async {
      _controller?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 18.0,
          ),
        ),
      );

      setState(() {});
    }).catchError((e) {
      toast(e.toString());
    });
  }

  final _kMapCenter = const CameraPosition(
    target: LatLng(40.59185, -74.152414),
    zoom: 11.0,
    bearing: 0,
    tilt: 0,
  );

  Future<Set<Marker>> _createMarkers() async {
    final Set<Marker> markers = {};

    for (int i = 0; i < widget.churchList.length; i++) {
      final church = widget.churchList[i];

      markers.add(
        Marker(
          markerId: MarkerId(church.id.toString()),
          position: LatLng(church.latitude, church.longitude),
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(
            title: church.name,
            snippet: church.website,
            onTap: () {
              setLoading(true);
              buildFullAddressFromLatLong(church.latitude, church.longitude)
                  .then((value) {
                setLoading(false);
                launchMap(value);
              });
            },
          ),
        ),
      );
    }

    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return SnapHelperWidget(
      future: _createMarkers(),
      loadingWidget: Container(
        padding:
            const EdgeInsets.only(left: 15, bottom: 30, right: 15, top: 10),
        decoration: BoxDecoration(
          borderRadius: radius(12),
          color: Colors.grey.shade100,
        ),
      ),
      onSuccess: (markers) {
        final mapWidget = GoogleMap(
          onMapCreated: onMapCreated,
          initialCameraPosition: _kMapCenter,
          markers: markers,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          mapToolbarEnabled: true,
          zoomControlsEnabled: true,
        )
            .cornerRadiusWithClipRRect(12)
            .paddingOnly(left: 15, bottom: 30, right: 15, top: 10);

        if (widget.miniView) return mapWidget;

        return Scaffold(
          floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton.small(
                backgroundColor: kPrimaryColor,
                heroTag: 'zoomOut',
                onPressed: () {
                  _controller?.moveCamera(CameraUpdate.zoomOut());
                },
                child: const Icon(CupertinoIcons.minus, color: Colors.white),
              ),
              FloatingActionButton.small(
                backgroundColor: kPrimaryColor,
                heroTag: 'zoomIn',
                onPressed: () {
                  _controller?.moveCamera(CameraUpdate.zoomIn());
                },
                child: const Icon(CupertinoIcons.plus, color: Colors.white),
              )
            ],
          ),
          body: mapWidget,
        );
      },
    );
  }
}

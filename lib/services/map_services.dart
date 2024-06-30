import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class MapServices {
  Future<Uint8List> getMapIcon(String imageUrl) async {
    const int targetWidth = 150;
    const int targetHeight = 150;
    final File markerImageFile =
        await DefaultCacheManager().getSingleFile(imageUrl);
    final Uint8List markerImageBytes = await markerImageFile.readAsBytes();
    final Codec markerImageCodec = await instantiateImageCodec(
      markerImageBytes,
      targetWidth: targetWidth,
      targetHeight: targetHeight,
    );
    final FrameInfo frameInfo = await markerImageCodec.getNextFrame();
    final ByteData? byteData = await frameInfo.image.toByteData(
      format: ImageByteFormat.png,
    );
    final Uint8List resizedMarkerImageBytes = byteData!.buffer.asUint8List();
    return resizedMarkerImageBytes;
  }
}

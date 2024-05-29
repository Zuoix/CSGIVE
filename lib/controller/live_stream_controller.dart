import 'package:cs_give/core/utils/common.dart';
import 'package:cs_give/models/live_sream.dart';
import 'package:get/get.dart';

import '../app.dart';
import '../services/live_stream_service.dart';

class LiveStreamController extends GetxController {
  var liveStreams = <LiveStreamModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLiveStreams();
  }

  Future<void> refreshLiveStreams() async {
    await fetchLiveStreams();
  }
  Future<void> fetchLiveStreams() async {
    isLoading(true);
   // showSuccess('loading ...');
    try {
      var streams = await LiveStreamService.getLiveStreams();
      //showSuccess('all set  ...');
      liveStreams.assignAll(streams);
     // showSuccess('Count: ' + liveStreams.length.toString());
    } catch (e) {
      print('Error in fetchLiveStreams: $e');
      showSuccess('$e');
    } finally {
      isLoading(false);
      //showSuccess('loaded ...');
    }
  }
}

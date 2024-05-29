import 'package:cs_give/core/utils/common.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../core/constants/api_routes.dart';
import '../models/live_sream.dart';
import 'network_utils.dart';

class LiveStreamService {

  static Future<List<LiveStreamModel>> getLiveStreams() async {

    String apiPath = ApiRoutes.livestream;

    final Map<String, dynamic> response = await handleResponse(await buildHttpResponse(apiPath));



      // Check the status code in the response
      if (response['status_code'] == '00') {
        // Map the data to LiveStreamModel objects
        return (response['data'] as List)
            .map((json) => LiveStreamModel.fromJson(json))
            .toList();
      } else {
        showError('Failed to load live streams, status code: '+ response['status_code']);
        throw Exception('Failed to load live streams, status code: '+ response['status_code']);
      }







     // final returnList = (response as List).map((e) => LiveStreamModel.fromJson(e)).toList();
      //return returnList;
   /* try {
      showError('got resp');
      var data = json.decode(response.body);
      List<LiveStreamModel> liveStreams = (data['data'] as List)
          .map((e) => LiveStreamModel.fromJson(e))
          .toList();
      return liveStreams;
    }catch(e){
      showError(e.toString());
    }*/


    //} else {
     // showError('Failed to load stream.');
      //throw Exception('Failed to load live streams');
    // }
  }
}

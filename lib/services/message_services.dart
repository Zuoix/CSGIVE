import 'package:cs_give/models/message_type_data.dart';
import 'package:cs_give/services/network_utils.dart';

import '../core/constants/api_routes.dart';

class MessageService {
  Future<List<MessageType>> getMessages() async {
    String apiPath = ApiRoutes.message;

    final data = await handleResponse(await buildHttpResponse(apiPath));
    return (data['data'] as List).map((e) => MessageType.fromJson(e)).toList();
  }
}

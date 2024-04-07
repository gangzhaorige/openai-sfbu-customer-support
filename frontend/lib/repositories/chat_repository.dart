import 'package:dio/dio.dart';
import 'package:flutter_front_end/dio.dart';

import '../models/message_model.dart';

class ChatRepository {

  Future<MessageModel> generateMessage(String question, String audio, String language, bool translate) async {
    var data = {
      'question' : question,
      'audio': audio,
      'language': language,
      'translate': translate,
    };
    Response<dynamic> response = await DioApi.postRequest(path: '/generate', data: data);
    return MessageModel(isSender: false, text: response.data['response'], url: response.data['url']);
  }
}
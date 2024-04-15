import 'package:flutter/material.dart';
import 'package:flutter_front_end/locator.dart';
import 'package:flutter_front_end/models/message_model.dart';
import 'package:flutter_front_end/repositories/chat_repository.dart';
import 'package:flutter_front_end/services/audio_services.dart';

import '../constant.dart';

class ConversationViewModel extends ChangeNotifier {

  List<MessageModel> conversations = [];

  bool isLoading = false;

  void addMessage(MessageModel messageModel) {
    conversations.add(messageModel);
    notifyListeners();
  }

  Future<void> generateResponse(String question, String audio, String language, bool translate, bool playAudio) async {
    isLoading = true;
    notifyListeners();
    locator<ChatRepository>().generateMessage(question, audio, language, translate).then((responseMessage) async {
      addMessage(responseMessage);
      isLoading = false;
      
      await locator<AudioPlayerService>().playAudio('$url/stream/${responseMessage.url}/$audio');
    });
    notifyListeners();
  }

   Future<void> clear() async {
    locator<ChatRepository>().reset().then((value) {
      conversations.clear();
      notifyListeners();
    });
  }
} 
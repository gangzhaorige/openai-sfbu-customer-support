import 'package:flutter/material.dart';
import 'package:flutter_front_end/locator.dart';
import 'package:flutter_front_end/models/message_model.dart';
import 'package:flutter_front_end/repositories/chat_repository.dart';
import 'package:flutter_front_end/services/audio_services.dart';

class ConversationViewModel extends ChangeNotifier {

  List<MessageModel> conversations = [];

  void addMessage(MessageModel messageModel) {
    conversations.add(messageModel);
    notifyListeners();
  }

  Future<void> generateResponse(String question, String audio, String language, bool translate) async {
    print(translate);
    MessageModel responseMessage = await locator<ChatRepository>().generateMessage(question, audio, language, translate);
    addMessage(responseMessage);
    print(responseMessage.url);
    locator<AudioPlayerService>().playAudio('http://127.0.0.1:5000/mp3/${responseMessage.url}');
  }
} 
import 'package:flutter/material.dart';

class SettingViewModel extends ChangeNotifier {

  final List<String> translateLanguages = ['English', 'Spanish', 'Chinese', 'Japanese', 'Korean', 'French'];

  final List<String> audioLanguages = ['Alloy', 'Echo', 'Fable', 'Onyx', 'Nova', 'Shimmer'];

  String _curAudio = 'Alloy';

  String _curTranslateLanguage = 'English';

  String get curAudio => _curAudio;

  String get curTranslateLanguage => _curTranslateLanguage; 

  set curAudio(String audio) {
    _curAudio = audio;
    notifyListeners();
  }

  set curTranslateLanguage(String language) {
    _curTranslateLanguage = language;
    notifyListeners();
  }


} 
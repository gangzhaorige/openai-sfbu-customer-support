import 'package:flutter/material.dart';

class SettingViewModel extends ChangeNotifier {

  final List<String> translateLanguages = ['English', 'Spanish', 'Chinese', 'Japanese', 'Korean', 'French'];

  final List<String> audioLanguages = ['Alloy', 'Echo', 'Fable', 'Onyx', 'Nova', 'Shimmer'];

  String _curAudio = 'Alloy';

  String _curTranslateLanguage = 'English';

  String get curAudio => _curAudio;

  String get curTranslateLanguage => _curTranslateLanguage; 

  bool _shouldTranslate = false;

  bool _playAudio = true;

  bool get shouldTranslate => _shouldTranslate;

  bool get playAudio => _playAudio;

  set playAudio(bool input) {
    _playAudio = input;
    notifyListeners();
  }

  set shouldTranslate(bool input) {
    _shouldTranslate = input;
    notifyListeners();
  }

  set curAudio(String audio) {
    _curAudio = audio;
    notifyListeners();
  }

  set curTranslateLanguage(String language) {
    _curTranslateLanguage = language;
    notifyListeners();
  }


} 
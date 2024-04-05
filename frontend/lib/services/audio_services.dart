import 'package:audioplayers/audioplayers.dart';

class AudioPlayerService {

  static AudioPlayerService getInstance() => AudioPlayerService._();

  AudioPlayerService._();

  AudioPlayer player = AudioPlayer();

  void playAudio(String url) {
    player.play(UrlSource(url));
  }
}

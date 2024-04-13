import 'package:audioplayers/audioplayers.dart';

class AudioPlayerService {

  static AudioPlayerService getInstance() => AudioPlayerService._();

  AudioPlayerService._();

  AudioPlayer player = AudioPlayer();

  Future<void> playAudio(String url) async {
    await player.setSourceUrl(url, mimeType: 'audio/mpeg');
    await player.play(UrlSource(url));
  }
}

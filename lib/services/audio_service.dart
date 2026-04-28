import 'package:just_audio/just_audio.dart';

class AudioService {
  final AudioPlayer player = AudioPlayer();

  Future<void> playUrl(String url) async {
    await player.setUrl(url);
    await player.play();
  }
}
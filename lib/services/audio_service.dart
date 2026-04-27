import 'package:just_audio/just_audio.dart';

class AudioService {
  final AudioPlayer player = AudioPlayer();

  Future<void> play(String url) async {
    await player.stop(); // 🔥 FIX: prevents lag + stuck audio
    await player.setUrl(url);
    await player.play();
  }

  Future<void> pause() async {
    await player.pause();
  }

  void seek(Duration d) {
    player.seek(d);
  }
}
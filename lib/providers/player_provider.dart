import 'package:flutter/material.dart';
import '../models/song.dart';
import '../services/audio_service.dart';

class PlayerProvider extends ChangeNotifier {
  final AudioService audio = AudioService();

  List<Song> playlist = [];
  int currentIndex = -1;
  bool playing = false;

  Song? get current =>
      (currentIndex >= 0 && currentIndex < playlist.length)
          ? playlist[currentIndex]
          : null;

  Future<void> play(List<Song> list, int index) async {
    playlist = list;
    currentIndex = index;

    final song = playlist[index];

    try {
      await audio.player.stop();
      await audio.playUrl(song.url);
      playing = true;
    } catch (e) {
      debugPrint("PLAY ERROR: $e");
      playing = false;
    }

    notifyListeners();
  }
Future<void> next() async {
  if (currentIndex < playlist.length - 1) {
    await play(playlist, currentIndex + 1);
  }
}

Future<void> previous() async {
  if (currentIndex > 0) {
    await play(playlist, currentIndex - 1);
  }
}
  Future<void> toggle() async {
    if (audio.player.playing) {
      await audio.player.pause();
      playing = false;
    } else {
      await audio.player.play();
      playing = true;
    }
    notifyListeners();
  }
}
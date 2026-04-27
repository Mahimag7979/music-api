import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../models/song.dart';
import '../services/audio_service.dart';

class PlayerProvider extends ChangeNotifier {
  final AudioService audio = AudioService();

  List<Song> playlist = [];
  int currentIndex = -1;
  bool playing = false;

  // ❤️ FAVORITES
  Set<String> favorites = {};

  PlayerProvider() {
    audio.player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        next();
      }
    });
  }

  Song? get current =>
      (currentIndex >= 0 && currentIndex < playlist.length)
          ? playlist[currentIndex]
          : null;

  // 🎵 STREAMS
  Stream<Duration> get positionStream => audio.player.positionStream;
  Stream<Duration?> get durationStream => audio.player.durationStream;

  // ❤️ FAVORITE METHODS
  bool isFavorite(String id) => favorites.contains(id);

  void toggleFavorite(Song song) {
    if (favorites.contains(song.id)) {
      favorites.remove(song.id);
    } else {
      favorites.add(song.id);
    }
    notifyListeners();
  }

  Future<void> playList(List<Song> list, int index) async {
    playlist = list;
    currentIndex = index;
    await audio.play(playlist[index].url);
    playing = true;
    notifyListeners();
  }

  Future<void> next() async {
    if (currentIndex < playlist.length - 1) {
      currentIndex++;
      await audio.play(playlist[currentIndex].url);
      notifyListeners();
    }
  }

  Future<void> previous() async {
    if (currentIndex > 0) {
      currentIndex--;
      await audio.play(playlist[currentIndex].url);
      notifyListeners();
    }
  }

  Future<void> toggle() async {
    if (playing) {
      await audio.pause();
      playing = false;
    } else {
      await audio.player.play();
      playing = true;
    }
    notifyListeners();
  }
}
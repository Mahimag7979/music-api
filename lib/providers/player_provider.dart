import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../models/song.dart';

class PlayerProvider extends ChangeNotifier {
  final AudioPlayer player = AudioPlayer();

  List<Song> playlist = [];
  bool _initialized = false;

  PlayerProvider() {
    player.playerStateStream.listen((_) {
      notifyListeners();
    });
  }

  bool get isPlaying => player.playing;

  Song? get current {
    final i = player.currentIndex;
    if (i == null || i < 0 || i >= playlist.length) return null;
    return playlist[i];
  }

  Stream<Duration> get positionStream => player.positionStream;
  Stream<Duration?> get durationStream => player.durationStream;

  // 🔥 LOAD PLAYLIST ONCE (KEY FIX)
  Future<void> initPlaylist(List<Song> list) async {
    if (_initialized) return;

    playlist = list;

    final sources = list
        .map((s) => AudioSource.uri(Uri.parse(s.url)))
        .toList();

    await player.setAudioSource(
      ConcatenatingAudioSource(children: sources),
    );

    _initialized = true;
  }

  // 🚀 INSTANT PLAY
  Future<void> play(List<Song> list, int index) async {
    await initPlaylist(list);
    await player.seek(Duration.zero, index: index);
    await player.play();
  }

  Future<void> toggle() async {
    if (player.playing) {
      await player.pause();
    } else {
      await player.play();
    }
  }

  Future<void> next() async {
    await player.seekToNext();
  }

  Future<void> previous() async {
    await player.seekToPrevious();
  }

  Future<void> seek(Duration d) async {
    await player.seek(d);
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
}
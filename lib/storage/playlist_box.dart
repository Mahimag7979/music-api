import '../models/song.dart';

class PlaylistBox {
  final Map<String, List<Song>> _data = {};

  void create(String name) {
    _data[name] = [];
  }

  void add(String name, Song song) {
    _data[name]?.add(song);
  }

  List<Song> get(String name) {
    return _data[name] ?? [];
  }

  List<String> keys() {
    return _data.keys.toList();
  }
}
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/song.dart';

class ApiService {
  static const String _url =
      'https://raw.githubusercontent.com/Mahimag7979/music-api/refs/heads/main/songs.json';

  List<Song>? _cache;

  Future<List<Song>> _fetch() async {
    if (_cache != null) return _cache!;
    try {
      final res = await http.get(Uri.parse(_url));
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        _cache = data.map((j) => Song.fromJson(j)).toList();
        return _cache!;
      }
    } catch (_) {}
    return [];
  }

  Future<List<Song>> fetchTrending({int limit = 25}) async {
    final all = await _fetch();
    return all
        .where((s) => s.genre == 'trending')
        .take(limit)
        .toList();
  }

  Future<List<Song>> fetchByGenre(int genreId, {int limit = 25}) async {
    final genreMap = {
      132: 'pop',
      116: 'rap',
      152: 'rock',
      113: 'dance',
      165: 'rnb',
      106: 'electronic',
      129: 'jazz',
      98:  'classical',
    };
    final all = await _fetch();
    final tag = genreMap[genreId];
    if (tag == null) return all.take(limit).toList();
    return all
        .where((s) => s.genre == tag)
        .take(limit)
        .toList();
  }

  Future<List<Song>> searchSongs(String query, {int limit = 25}) async {
    final all = await _fetch();
    final q = query.toLowerCase();
    return all
        .where((s) =>
            s.title.toLowerCase().contains(q) ||
            s.artist.toLowerCase().contains(q))
        .toList();
  }

  Future<List<Song>> fetchLocalSongs() => fetchTrending();
}
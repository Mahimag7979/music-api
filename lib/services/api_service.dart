import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/song.dart';

class ApiService {
  Future<List<Song>> fetchSongs() async {
    final res = await http.get(Uri.parse(
      "https://raw.githubusercontent.com/Mahimag7979/music-api/main/songs.json",
    ));

    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      return data.map((e) => Song.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load songs");
    }
  }
}
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/song.dart';

class ApiService {
  Future<List<Song>> fetchSongs() async {
    try {
      final response = await http.get(Uri.parse(
        'https://raw.githubusercontent.com/Mahimag7979/music-api/main/songs.json'
      ));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        return data.map((e) => Song.fromJson(e)).toList();
      } else {
        throw Exception('Failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print("API ERROR: $e");
      return []; // prevents crash
    }
  }
}
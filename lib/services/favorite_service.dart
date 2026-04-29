import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/song.dart';

class FavoriteService extends ChangeNotifier {
  final Set<String> _favorites = {};

  Set<String> get favorites => Set.unmodifiable(_favorites);

  bool isFavorite(String songId) => _favorites.contains(songId);

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('favorite_song_ids') ?? [];
    _favorites.addAll(saved);
    notifyListeners();
  }

  Future<void> toggleFavorite(Song song) async {
    if (_favorites.contains(song.id)) {
      _favorites.remove(song.id);
    } else {
      _favorites.add(song.id);
    }
    await _saveFavorites();
    notifyListeners();
  }

  List<Song> getFavorites(List<Song> allSongs) {
    return allSongs.where((s) => _favorites.contains(s.id)).toList();
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorite_song_ids', _favorites.toList());
  }
}
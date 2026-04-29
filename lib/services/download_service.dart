import 'dart:io';
import 'package:flutter/foundation.dart'; // ← add this
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/song.dart';

class DownloadService extends ChangeNotifier {
  final Map<String, double> _progress = {};
  final Set<String> _downloaded = {};

  Map<String, double> get progress => Map.unmodifiable(_progress);
  Set<String> get downloaded => Set.unmodifiable(_downloaded);

  bool isDownloaded(String songId) => _downloaded.contains(songId);
  double? downloadProgress(String songId) => _progress[songId];

  Future<void> init() async {
    if (kIsWeb) return; // ← skip on web
    final prefs = await SharedPreferences.getInstance();
    final paths = prefs.getStringList('downloaded_songs') ?? [];
    _downloaded.addAll(paths);
    notifyListeners();
  }

  Future<void> downloadSong(Song song) async {
    if (kIsWeb) {
      // Web doesn't support file download
      notifyListeners();
      return;
    }
    if (_downloaded.contains(song.id)) return;
    _downloaded.add(song.id);
    await _saveDownloads();
    notifyListeners();
  }

  Future<void> removeDownload(Song song) async {
    if (kIsWeb) return;
    _downloaded.remove(song.id);
    await _saveDownloads();
    notifyListeners();
  }

  Future<List<Song>> getDownloadedSongs(List<Song> allSongs) async {
    return allSongs.where((s) => _downloaded.contains(s.id)).toList();
  }

  Future<void> _saveDownloads() async {
    if (kIsWeb) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('downloaded_songs', _downloaded.toList());
  }
}
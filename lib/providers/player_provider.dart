import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../models/song.dart';
import '../services/audio_service.dart';
import '../services/api_service.dart';
import '../services/favorite_service.dart';
import '../services/download_service.dart';

class PlayerProvider extends ChangeNotifier {
  final AudioService    _audio  = AudioService();
  final ApiService      _api    = ApiService();
  final FavoriteService _favSvc = FavoriteService();
  final DownloadService _dlSvc  = DownloadService();

  List<Song> _allSongs      = [];
  List<Song> _displayed     = [];
  List<Song> _searchResults = [];
  bool _isLoading           = false;
  bool _isSearching         = false;
  String _searchQuery       = '';
  int _navIndex             = 0;
  String _selectedGenre     = 'Trending';
  Timer? _debounce;

  List<Song>      get allSongs        => _allSongs;
  List<Song>      get displayedSongs  => _isSearching ? _searchResults : _displayed;
  bool            get isLoading       => _isLoading;
  bool            get isSearching     => _isSearching;
  int             get navIndex        => _navIndex;
  String          get selectedGenre   => _selectedGenre;
  Song?           get currentSong     => _audio.currentSong;
  AudioService    get audioService    => _audio;
  FavoriteService get favoriteService => _favSvc;
  DownloadService get downloadService => _dlSvc;
  AudioRepeatMode get repeatMode      => _audio.repeatMode;
  bool            get isShuffled      => _audio.isShuffled;

  Stream<PlayerState> get playerStateStream => _audio.playerStateStream;
  Stream<Duration?>   get durationStream    => _audio.durationStream;
  Stream<Duration>    get positionStream    => _audio.positionStream;

  bool get isPlaying => _audio.player.playing;

  /// Deduplicated pool of all known songs
  List<Song> get _songPool {
    final seen = <String>{};
    return [..._allSongs, ..._searchResults]
        .where((s) => seen.add(s.id))
        .toList();
  }

  List<Song> get favoriteSongs  => _favSvc.getFavorites(_songPool);
  List<Song> get downloadedSongs =>
      _songPool.where((s) => _dlSvc.isDownloaded(s.id)).toList();

  static const List<Map<String, dynamic>> genres = [
    {'name': 'Trending',    'id': 0},
    {'name': 'Pop',         'id': 132},
    {'name': 'Rap/Hip Hop', 'id': 116},
    {'name': 'Rock',        'id': 152},
    {'name': 'Dance',       'id': 113},
    {'name': 'R&B',         'id': 165},
    {'name': 'Electronic',  'id': 106},
    {'name': 'Jazz',        'id': 129},
    {'name': 'Classical',   'id': 98},
  ];

  Future<void> init() async {
    await Future.wait([
      _audio.init(),
      _favSvc.init(),
      _dlSvc.init(),
    ]);
    await loadSongs();
  }

  Future<void> loadSongs() async {
    _isLoading = true;
    _selectedGenre = 'Trending';
    notifyListeners();

    _allSongs  = await _api.fetchTrending();
    _displayed = List.from(_allSongs);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadByGenre(String name, int id) async {
    _isLoading     = true;
    _selectedGenre = name;
    _isSearching   = false;
    _searchResults = [];
    notifyListeners();

    _allSongs  = id == 0
        ? await _api.fetchTrending()
        : await _api.fetchByGenre(id);
    _displayed = List.from(_allSongs);

    _isLoading = false;
    notifyListeners();
  }

  void search(String query) {
    _searchQuery = query.trim();
    if (_searchQuery.isEmpty) {
      clearSearch();
      return;
    }

    _isSearching = true;
    _isLoading   = true;
    notifyListeners();

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      _searchResults = await _api.searchSongs(_searchQuery);
      _isLoading     = false;
      notifyListeners();
    });
  }

  void clearSearch() {
    _isSearching   = false;
    _searchQuery   = '';
    _searchResults = [];
    _debounce?.cancel();
    notifyListeners();
  }

  void setNavIndex(int index) {
    _navIndex = index;
    notifyListeners();
  }

  Future<void> playSong(Song song, {List<Song>? queue}) async {
    await _audio.playSong(song, queue: queue ?? displayedSongs);
    notifyListeners();
  }

  Future<void> togglePlayPause() async {
    await _audio.togglePlayPause();
    notifyListeners();
  }

  Future<void> playNext() async {
    await _audio.playNext();
    notifyListeners();
  }

  Future<void> playPrevious() async {
    await _audio.playPrevious();
    notifyListeners();
  }

  Future<void> seek(Duration pos) async => _audio.seek(pos);

  Future<void> toggleRepeat() async {
    await _audio.toggleRepeat();
    notifyListeners();
  }

  Future<void> toggleShuffle() async {
    await _audio.toggleShuffle();
    notifyListeners();
  }

  Future<void> toggleFavorite(Song song) async {
    await _favSvc.toggleFavorite(song);
    notifyListeners();
  }

  bool isFavorite(String songId) => _favSvc.isFavorite(songId);

  Future<void> downloadSong(Song song) async {
    await _dlSvc.downloadSong(song);
    notifyListeners();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _audio.dispose();
    super.dispose();
  }
}
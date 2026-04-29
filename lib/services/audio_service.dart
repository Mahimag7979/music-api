import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/song.dart';
import '../core/constants.dart';

enum AudioRepeatMode { none, all, one }

class AudioService {
  final AudioPlayer _player = AudioPlayer();
  List<Song> _queue = [];
  int _currentIndex = -1;
  AudioRepeatMode _repeatMode = AudioRepeatMode.none;
  bool _isShuffled = false;
  List<int> _shuffleIndices = [];

  AudioPlayer get player => _player;
  List<Song> get queue => _queue;
  int get currentIndex => _currentIndex;
  AudioRepeatMode get repeatMode => _repeatMode;
  bool get isShuffled => _isShuffled;

  Song? get currentSong =>
      _currentIndex >= 0 && _currentIndex < _queue.length
          ? _queue[_currentIndex]
          : null;

  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<Duration> get positionStream => _player.positionStream;

  Future<void> init() async {
    await _loadPreferences();
    _player.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        _onSongComplete();
      }
    });
  }

  Future<void> _loadPreferences() async {
    if (kIsWeb) return;
    final prefs = await SharedPreferences.getInstance();
    final repeatIndex = prefs.getInt(AppConstants.kRepeatMode) ?? 0;
    _repeatMode = AudioRepeatMode.values[repeatIndex];
    _isShuffled = prefs.getBool(AppConstants.kShuffleMode) ?? false;
    final volume = prefs.getDouble(AppConstants.kVolume) 
        ?? AppConstants.defaultVolume;
    await _player.setVolume(volume);
  }

  Future<void> _savePreferences() async {
    if (kIsWeb) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(AppConstants.kRepeatMode, _repeatMode.index);
    await prefs.setBool(AppConstants.kShuffleMode, _isShuffled);
    await prefs.setDouble(AppConstants.kVolume, _player.volume);
    if (currentSong != null) {
      await prefs.setString(
          AppConstants.kLastPlayedSongId, currentSong!.id);
      await prefs.setInt(
        AppConstants.kLastPlayedPosition,
        _player.position.inMilliseconds,
      );
    }
  }

  Future<void> playSong(Song song, {List<Song>? queue, int? index}) async {
    if (queue != null) {
      _queue = List.from(queue);
      _currentIndex = index ?? queue.indexOf(song);
      if (_isShuffled) _buildShuffleIndices();
    } else if (!_queue.contains(song)) {
      _queue.add(song);
      _currentIndex = _queue.length - 1;
    } else {
      _currentIndex = _queue.indexOf(song);
    }
    await _player.setUrl(song.filePath);
    await _player.play();
    await _savePreferences();
  }

  Future<void> togglePlayPause() async {
    if (_player.playing) {
      await _player.pause();
    } else {
      await _player.play();
    }
    await _savePreferences();
  }

  Future<void> playNext() async {
    final nextIndex = _getNextIndex();
    if (nextIndex == -1) return;
    _currentIndex = nextIndex;
    await _player.setUrl(_queue[_currentIndex].filePath);
    await _player.play();
    await _savePreferences();
  }

  Future<void> playPrevious() async {
    if (_player.position.inSeconds > 3) {
      await _player.seek(Duration.zero);
      return;
    }
    final prevIndex = _getPreviousIndex();
    if (prevIndex == -1) return;
    _currentIndex = prevIndex;
    await _player.setUrl(_queue[_currentIndex].filePath);
    await _player.play();
    await _savePreferences();
  }

  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  Future<void> seekForward() async {
    final newPos = _player.position + AppConstants.seekStep;
    final dur = _player.duration ?? Duration.zero;
    await _player.seek(newPos > dur ? dur : newPos);
  }

  Future<void> seekBackward() async {
    final newPos = _player.position - AppConstants.seekStep;
    await _player.seek(
        newPos < Duration.zero ? Duration.zero : newPos);
  }

  Future<void> setVolume(double volume) async {
    await _player.setVolume(volume);
    await _savePreferences();
  }

  Future<void> toggleRepeat() async {
    _repeatMode = AudioRepeatMode.values[
      (_repeatMode.index + 1) % AudioRepeatMode.values.length
    ];
    await _savePreferences();
  }

  Future<void> toggleShuffle() async {
    _isShuffled = !_isShuffled;
    if (_isShuffled) {
      _buildShuffleIndices();
    } else {
      _shuffleIndices = [];
    }
    await _savePreferences();
  }

  void _buildShuffleIndices() {
    _shuffleIndices = List.generate(_queue.length, (i) => i)
      ..remove(_currentIndex)
      ..shuffle()
      ..insert(0, _currentIndex);
  }

  int _getNextIndex() {
    if (_queue.isEmpty) return -1;
    if (_repeatMode == AudioRepeatMode.one) return _currentIndex;
    if (_isShuffled && _shuffleIndices.isNotEmpty) {
      final pos = _shuffleIndices.indexOf(_currentIndex);
      if (pos < _shuffleIndices.length - 1) 
        return _shuffleIndices[pos + 1];
      return _repeatMode == AudioRepeatMode.all 
          ? _shuffleIndices[0] : -1;
    }
    if (_currentIndex < _queue.length - 1) return _currentIndex + 1;
    return _repeatMode == AudioRepeatMode.all ? 0 : -1;
  }

  int _getPreviousIndex() {
    if (_queue.isEmpty) return -1;
    if (_isShuffled && _shuffleIndices.isNotEmpty) {
      final pos = _shuffleIndices.indexOf(_currentIndex);
      if (pos > 0) return _shuffleIndices[pos - 1];
      return _repeatMode == AudioRepeatMode.all
          ? _shuffleIndices.last
          : _currentIndex;
    }
    if (_currentIndex > 0) return _currentIndex - 1;
    return _repeatMode == AudioRepeatMode.all ? _queue.length - 1 : 0;
  }

  void _onSongComplete() {
    final next = _getNextIndex();
    if (next == -1) {
      _player.seek(Duration.zero);
      return;
    }
    _currentIndex = next;
    _player
        .setUrl(_queue[_currentIndex].filePath)
        .then((_) => _player.play());
    _savePreferences();
  }

  Future<void> dispose() async {
    await _savePreferences();
    await _player.dispose();
  }
}
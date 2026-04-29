class AppConstants {
  static const String kLastPlayedSongId    = 'last_played_song_id';
  static const String kLastPlayedPosition  = 'last_played_position';
  static const String kRepeatMode          = 'repeat_mode';
  static const String kShuffleMode         = 'shuffle_mode';
  static const String kVolume              = 'volume';
  static const String kFavoriteSongIds     = 'favorite_song_ids';
  static const String kDownloadedSongPaths = 'downloaded_song_paths';

  static const Duration seekStep             = Duration(seconds: 10);
  static const double   defaultVolume        = 1.0;
  static const double   miniPlayerHeight     = 72.0;
  static const double   bottomNavHeight      = 60.0;
  static const Duration animationDuration    = Duration(milliseconds: 300);
  static const Duration snackbarDuration     = Duration(seconds: 2);
  static const String   downloadsFolder      = 'MusicPlayer';
}
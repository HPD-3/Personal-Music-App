class AppConstants {
  // App Info
  static const String appName = 'Personal Music Player';
  static const String appVersion = '1.0.0';

  // Durations
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration shortDelay = Duration(milliseconds: 200);
  static const Duration mediumDelay = Duration(milliseconds: 500);

  // UI Sizing
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double largeRadius = 20.0;

  // Storage Keys
  static const String favoritesKey = 'favorites';
  static const String recentlyPlayedKey = 'recently_played';
  static const String playlistsKey = 'playlists';
  static const String settingsKey = 'settings';
  static const String currentSongKey = 'current_song';
  static const String playbackPositionKey = 'playback_position';

  // Limits
  static const int maxRecentlyPlayed = 50;
  static const int maxPlaylists = 100;
  static const int searchLimit = 1000;

  // Sleep Timer Options (in minutes)
  static const List<int> sleepTimerOptions = [5, 10, 15, 30, 45, 60];
}

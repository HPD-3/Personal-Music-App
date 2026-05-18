import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/playlist_model.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  late SharedPreferences _prefs;
  bool _initialized = false;

  factory StorageService() {
    return _instance;
  }

  StorageService._internal();

  Future<void> init() async {
    if (!_initialized) {
      _prefs = await SharedPreferences.getInstance();
      _initialized = true;
    }
  }

  // Favorites Management
  Future<void> addFavorite(int songId) async {
    final favorites = getFavorites();
    if (!favorites.contains(songId)) {
      favorites.add(songId);
      await _prefs.setString('favorites', jsonEncode(favorites));
    }
  }

  Future<void> removeFavorite(int songId) async {
    final favorites = getFavorites();
    favorites.remove(songId);
    await _prefs.setString('favorites', jsonEncode(favorites));
  }

  List<int> getFavorites() {
    final data = _prefs.getString('favorites');
    if (data == null) return [];
    return List<int>.from(jsonDecode(data));
  }

  bool isFavorite(int songId) {
    return getFavorites().contains(songId);
  }

  // Recently Played Management
  Future<void> addToRecentlyPlayed(int songId) async {
    final recent = getRecentlyPlayed();
    recent.remove(songId);
    recent.insert(0, songId);
    if (recent.length > 50) {
      recent.removeRange(50, recent.length);
    }
    await _prefs.setString('recently_played', jsonEncode(recent));
  }

  List<int> getRecentlyPlayed() {
    final data = _prefs.getString('recently_played');
    if (data == null) return [];
    return List<int>.from(jsonDecode(data));
  }

  // Playlists Management
  Future<void> addPlaylist(PlaylistModel playlist) async {
    final playlists = getPlaylists();
    playlists.add(playlist);
    await _savePlaylists(playlists);
  }

  Future<void> updatePlaylist(PlaylistModel playlist) async {
    final playlists = getPlaylists();
    final index = playlists.indexWhere((p) => p.id == playlist.id);
    if (index != -1) {
      playlists[index] = playlist;
      await _savePlaylists(playlists);
    }
  }

  Future<void> deletePlaylist(String playlistId) async {
    final playlists = getPlaylists();
    playlists.removeWhere((p) => p.id == playlistId);
    await _savePlaylists(playlists);
  }

  List<PlaylistModel> getPlaylists() {
    final data = _prefs.getString('playlists');
    if (data == null) return [];
    return (jsonDecode(data) as List)
        .map((p) => PlaylistModel.fromJson(p))
        .toList();
  }

  Future<void> _savePlaylists(List<PlaylistModel> playlists) async {
    await _prefs.setString(
      'playlists',
      jsonEncode(playlists.map((p) => p.toJson()).toList()),
    );
  }

  // Settings Management
  Future<void> saveSetting(String key, dynamic value) async {
    if (value is String) {
      await _prefs.setString(key, value);
    } else if (value is int) {
      await _prefs.setInt(key, value);
    } else if (value is bool) {
      await _prefs.setBool(key, value);
    } else if (value is double) {
      await _prefs.setDouble(key, value);
    }
  }

  dynamic getSetting(String key, dynamic defaultValue) {
    return _prefs.get(key) ?? defaultValue;
  }

  // Playback State
  Future<void> saveCurrentSong(int songId) async {
    await _prefs.setInt('current_song', songId);
  }

  int? getCurrentSong() {
    return _prefs.getInt('current_song');
  }

  Future<void> savePlaybackPosition(int positionMs) async {
    await _prefs.setInt('playback_position', positionMs);
  }

  int getPlaybackPosition() {
    return _prefs.getInt('playback_position') ?? 0;
  }

  Future<void> clearAll() async {
    await _prefs.clear();
  }
}

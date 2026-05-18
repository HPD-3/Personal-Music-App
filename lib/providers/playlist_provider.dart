import 'package:flutter/foundation.dart';
import '../models/playlist_model.dart';
import '../services/audio_query_service.dart';
import '../services/storage_service.dart';
import 'song_provider.dart';

class PlaylistProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService();
  final SongProvider _songProvider;

  List<PlaylistModel> _playlists = [];

  PlaylistProvider(this._songProvider) {
    _loadPlaylists();
  }

  List<PlaylistModel> get playlists => _playlists;

  void _loadPlaylists() {
    _playlists = _storageService.getPlaylists();
    notifyListeners();
  }

  Future<void> createPlaylist(String name) async {
    final newPlaylist = PlaylistModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      songIds: [],
      createdAt: DateTime.now().millisecondsSinceEpoch,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
    await _storageService.addPlaylist(newPlaylist);
    _loadPlaylists();
  }

  Future<void> renamePlaylist(String playlistId, String newName) async {
    final playlistIndex = _playlists.indexWhere((p) => p.id == playlistId);
    if (playlistIndex == -1) return;
    
    final playlist = _playlists[playlistIndex];
    final updated = playlist.copyWith(
      name: newName,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
    await _storageService.updatePlaylist(updated);
    _loadPlaylists();
  }

  Future<void> deletePlaylist(String playlistId) async {
    await _storageService.deletePlaylist(playlistId);
    _loadPlaylists();
  }

  Future<void> addSongToPlaylist(String playlistId, int songId) async {
    final playlistIndex = _playlists.indexWhere((p) => p.id == playlistId);
    if (playlistIndex == -1) return;
    
    final playlist = _playlists[playlistIndex];
    if (!playlist.songIds.contains(songId)) {
      final updated = playlist.copyWith(
        songIds: [...playlist.songIds, songId],
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      );
      await _storageService.updatePlaylist(updated);
      _loadPlaylists();
    }
  }

  Future<void> removeSongFromPlaylist(String playlistId, int songId) async {
    final playlistIndex = _playlists.indexWhere((p) => p.id == playlistId);
    if (playlistIndex == -1) return;
    
    final playlist = _playlists[playlistIndex];
    final updated = playlist.copyWith(
      songIds: (List<int>.from(playlist.songIds)..remove(songId)),
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
    await _storageService.updatePlaylist(updated);
    _loadPlaylists();
  }

  List<SongModel> getPlaylistSongs(String playlistId) {
    final playlistIndex = _playlists.indexWhere((p) => p.id == playlistId);
    if (playlistIndex == -1) return [];
    
    final playlist = _playlists[playlistIndex];
    return _songProvider.allSongs
        .where((song) => playlist.songIds.contains(song.id))
        .toList();
  }

  bool isSongInPlaylist(String playlistId, int songId) {
    final playlistIndex = _playlists.indexWhere((p) => p.id == playlistId);
    if (playlistIndex == -1) return false;
    
    return _playlists[playlistIndex].songIds.contains(songId);
  }
}

import 'package:flutter/foundation.dart';
import '../services/audio_query_service.dart';
import '../services/storage_service.dart';

class SongProvider extends ChangeNotifier {
  final AudioQueryService _audioQueryService = AudioQueryService();
  final StorageService _storageService = StorageService();

  List<SongModel> _allSongs = [];
  List<SongModel> _filteredSongs = [];
  List<SongModel> _favoritesSongs = [];
  bool _isLoading = false;
  String _lastSearchQuery = '';

  SongProvider() {
    init();
  }

  // Getters
  List<SongModel> get allSongs => _allSongs;
  List<SongModel> get filteredSongs => _filteredSongs;
  List<SongModel> get favoritesSongs => _favoritesSongs;
  bool get isLoading => _isLoading;

  Future<void> init() async {
    await loadSongs();
    _loadFavorites();
  }

  Future<void> loadSongs() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allSongs = await _audioQueryService.getSongs();
      _filteredSongs = List.from(_allSongs);
      _loadFavorites();
    } catch (e) {
      print('Error loading songs: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  void _loadFavorites() {
    final favoriteIds = _storageService.getFavorites();
    _favoritesSongs =
        _allSongs.where((song) => favoriteIds.contains(song.id)).toList();
  }

  Future<void> toggleFavorite(int songId) async {
    if (_storageService.isFavorite(songId)) {
      await _storageService.removeFavorite(songId);
    } else {
      await _storageService.addFavorite(songId);
    }
    _loadFavorites();
    notifyListeners();
  }

  bool isFavorite(int songId) {
    return _storageService.isFavorite(songId);
  }

  void searchSongs(String query) {
    _lastSearchQuery = query;
    if (query.isEmpty) {
      _filteredSongs = List.from(_allSongs);
    } else {
      _filteredSongs = _allSongs
          .where((song) =>
              (song.title?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
              (song.artist?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
              (song.album?.toLowerCase().contains(query.toLowerCase()) ?? false))
          .toList();
    }
    notifyListeners();
  }

  void sortSongs(SortOption option) {
    switch (option) {
      case SortOption.byName:
        _filteredSongs.sort((a, b) => (a.title ?? '').compareTo(b.title ?? ''));
        break;
      case SortOption.byArtist:
        _filteredSongs.sort((a, b) => (a.artist ?? '').compareTo(b.artist ?? ''));
        break;
      case SortOption.byDuration:
        _filteredSongs.sort((a, b) => (a.duration ?? 0).compareTo(b.duration ?? 0));
        break;
      case SortOption.byDateAdded:
        _filteredSongs.sort((a, b) => (b.dateAdded ?? 0).compareTo(a.dateAdded ?? 0));
        break;
    }
    notifyListeners();
  }

  void clearSearch() {
    _lastSearchQuery = '';
    _filteredSongs = List.from(_allSongs);
    notifyListeners();
  }
}

enum SortOption { byName, byArtist, byDuration, byDateAdded }

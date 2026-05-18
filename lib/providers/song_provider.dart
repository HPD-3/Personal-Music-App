import 'package:flutter/foundation.dart';
import '../services/audio_query_service.dart';
import '../services/storage_service.dart';
import '../core/utils/song_text_utils.dart';

class SongProvider extends ChangeNotifier {
  final AudioQueryService _audioQueryService = AudioQueryService();
  final StorageService _storageService = StorageService();

  List<SongModel> _allSongs = [];
  List<SongModel> _filteredSongs = [];
  List<SongModel> _favoritesSongs = [];
  List<int> _hiddenSongIds = [];
  bool _isLoading = false;
  String _lastSearchQuery = '';

  SongProvider() {
    init();
  }

  // Getters
  List<SongModel> get allSongs => _allSongs;
  List<SongModel> get filteredSongs => _filteredSongs;
  List<SongModel> get favoritesSongs => _favoritesSongs;
  List<int> get hiddenSongIds => _hiddenSongIds;
  bool get isLoading => _isLoading;

  Future<void> init() async {
    await loadSongs();
  }

  Future<void> loadSongs() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allSongs = await _audioQueryService.getSongs();
      _loadHiddenSongs();
      _applyFilters();
      _loadFavorites();
    } catch (e) {
      print('Error loading songs: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  void _loadFavorites() {
    final favoriteIds = _storageService.getFavorites();
    _favoritesSongs = _allSongs
        .where(
          (song) => favoriteIds.contains(song.id) && !_hiddenSongIds.contains(song.id),
        )
        .toList();
  }

  void _loadHiddenSongs() {
    _hiddenSongIds = _storageService.getHiddenSongs();
  }

  List<SongModel> _getVisibleSongs() {
    return _allSongs.where((song) => !_hiddenSongIds.contains(song.id)).toList();
  }

  void _applyFilters() {
    final visibleSongs = _getVisibleSongs();
    if (_lastSearchQuery.isEmpty) {
      _filteredSongs = List.from(visibleSongs);
      return;
    }

    final query = _lastSearchQuery.toLowerCase();
    _filteredSongs = visibleSongs
        .where(
          (song) =>
              SongTextUtils.displayTitle(song).toLowerCase().contains(query) ||
              SongTextUtils.displayArtist(song).toLowerCase().contains(query) ||
              (song.title ?? '').toLowerCase().contains(query) ||
              (song.artist ?? '').toLowerCase().contains(query) ||
              (song.album ?? '').toLowerCase().contains(query),
        )
        .toList();
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
    _applyFilters();
    notifyListeners();
  }

  void sortSongs(SortOption option) {
    switch (option) {
      case SortOption.byName:
        _filteredSongs.sort(
          (a, b) => SongTextUtils.displayTitle(a)
              .toLowerCase()
              .compareTo(SongTextUtils.displayTitle(b).toLowerCase()),
        );
        break;
      case SortOption.byArtist:
        _filteredSongs.sort(
          (a, b) => SongTextUtils.sortArtistKey(a).compareTo(SongTextUtils.sortArtistKey(b)),
        );
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
    _applyFilters();
    notifyListeners();
  }

  Future<void> hideSong(int songId) async {
    if (_hiddenSongIds.contains(songId)) return;
    await _storageService.hideSong(songId);
    _loadHiddenSongs();
    _applyFilters();
    _loadFavorites();
    notifyListeners();
  }
}

enum SortOption { byName, byArtist, byDuration, byDateAdded }

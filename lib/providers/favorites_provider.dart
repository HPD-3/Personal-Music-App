import 'package:flutter/foundation.dart';
import '../services/storage_service.dart';

class FavoritesProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService();

  List<int> _favorites = [];

  FavoritesProvider() {
    _loadFavorites();
  }

  List<int> get favorites => _favorites;
  int get favoritesCount => _favorites.length;

  void _loadFavorites() {
    _favorites = _storageService.getFavorites();
    notifyListeners();
  }

  Future<void> addFavorite(int songId) async {
    if (!_favorites.contains(songId)) {
      await _storageService.addFavorite(songId);
      _loadFavorites();
    }
  }

  Future<void> removeFavorite(int songId) async {
    await _storageService.removeFavorite(songId);
    _loadFavorites();
  }

  Future<void> toggleFavorite(int songId) async {
    if (_favorites.contains(songId)) {
      await removeFavorite(songId);
    } else {
      await addFavorite(songId);
    }
  }

  bool isFavorite(int songId) {
    return _favorites.contains(songId);
  }

  Future<void> clearFavorites() async {
    for (int songId in _favorites) {
      await _storageService.removeFavorite(songId);
    }
    _loadFavorites();
  }
}

import 'package:flutter/foundation.dart';
import '../services/storage_service.dart';

class SettingsProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService();

  bool _showNotifications = true;
  bool _useSystemVolume = true;
  double _playbackSpeed = 1.0;
  int _sleepTimerMinutes = 0;
  int _equalizer = 0; // 0-10 scale

  SettingsProvider() {
    _loadSettings();
  }

  // Getters
  bool get showNotifications => _showNotifications;
  bool get useSystemVolume => _useSystemVolume;
  double get playbackSpeed => _playbackSpeed;
  int get sleepTimerMinutes => _sleepTimerMinutes;
  int get equalizer => _equalizer;

  void _loadSettings() {
    _showNotifications = _storageService.getSetting('showNotifications', true);
    _useSystemVolume = _storageService.getSetting('useSystemVolume', true);
    _playbackSpeed = _storageService.getSetting('playbackSpeed', 1.0);
    _sleepTimerMinutes = _storageService.getSetting('sleepTimerMinutes', 0);
    _equalizer = _storageService.getSetting('equalizer', 0);
  }

  Future<void> setShowNotifications(bool value) async {
    _showNotifications = value;
    await _storageService.saveSetting('showNotifications', value);
    notifyListeners();
  }

  Future<void> setUseSystemVolume(bool value) async {
    _useSystemVolume = value;
    await _storageService.saveSetting('useSystemVolume', value);
    notifyListeners();
  }

  Future<void> setPlaybackSpeed(double speed) async {
    _playbackSpeed = speed;
    await _storageService.saveSetting('playbackSpeed', speed);
    notifyListeners();
  }

  Future<void> setSleepTimer(int minutes) async {
    _sleepTimerMinutes = minutes;
    await _storageService.saveSetting('sleepTimerMinutes', minutes);
    notifyListeners();
  }

  Future<void> setEqualizer(int value) async {
    _equalizer = value.clamp(0, 10);
    await _storageService.saveSetting('equalizer', _equalizer);
    notifyListeners();
  }
}

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../services/audio_playback_service.dart';
import '../services/audio_query_service.dart';
import '../services/storage_service.dart';

enum AudioRepeatMode { none, one, all }

class AudioProvider extends ChangeNotifier {
  final AudioPlaybackService _audioService = AudioPlaybackService();
  final StorageService _storageService = StorageService();

  SongModel? _currentSong;
  List<SongModel> _playlist = [];
  int _currentIndex = 0;
  bool _isShuffled = false;
  AudioRepeatMode _repeatMode = AudioRepeatMode.none;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isLoading = false;
  bool _isPrepared = false;

  // Getters
  SongModel? get currentSong => _currentSong;
  List<SongModel> get playlist => _playlist;
  int get currentIndex => _currentIndex;
  bool get isShuffled => _isShuffled;
  AudioRepeatMode get repeatMode => _repeatMode;
  Duration get duration => _duration;
  Duration get position => _position;
  bool get isPlaying => _audioService.isPlaying;
  bool get isLoading => _isLoading;
  bool get isPrepared => _isPrepared;

  AudioProvider() {
    _setupListeners();
  }

  void _setupListeners() {
    _audioService.durationStream.listen((duration) {
      _duration = duration ?? Duration.zero;
      notifyListeners();
    });

    _audioService.positionStream.listen((position) {
      _position = position;
      notifyListeners();
    });

    _audioService.isPlayingStream.listen((_) {
      notifyListeners();
    });
  }

  Future<void> loadPlaylist(List<SongModel> songs, {int startIndex = 0}) async {
    _isLoading = true;
    _playlist = songs;
    _currentIndex = startIndex;

    if (songs.isNotEmpty) {
      _currentSong = songs[startIndex];
      await _loadSong(_currentSong!);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadSong(SongModel song) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _audioService.loadSong(song.data);
      _currentSong = song;
      _storageService.saveCurrentSong(song.id);
      _storageService.addToRecentlyPlayed(song.id);
      _isPrepared = true;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error loading song: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> play() async {
    try {
      await _audioService.play();
      notifyListeners();
    } catch (e) {
      print('Error playing: $e');
    }
  }

  Future<void> pause() async {
    try {
      await _audioService.pause();
      _storageService.savePlaybackPosition(position.inMilliseconds);
      notifyListeners();
    } catch (e) {
      print('Error pausing: $e');
    }
  }

  Future<void> next() async {
    if (_playlist.isEmpty) return;

    int nextIndex;
    if (_isShuffled) {
      final indices = List.generate(_playlist.length, (i) => i)..shuffle();
      nextIndex = indices[0];
    } else {
      nextIndex = (_currentIndex + 1) % _playlist.length;
    }

    _currentIndex = nextIndex;
    await _loadSong(_playlist[nextIndex]);
    await play();
  }

  Future<void> previous() async {
    if (_playlist.isEmpty) return;

    int prevIndex;
    if (_isShuffled) {
      final indices = List.generate(_playlist.length, (i) => i)..shuffle();
      prevIndex = indices[0];
    } else {
      prevIndex = (_currentIndex - 1 + _playlist.length) % _playlist.length;
    }

    _currentIndex = prevIndex;
    await _loadSong(_playlist[prevIndex]);
    await play();
  }

  Future<void> seek(Duration position) async {
    try {
      await _audioService.seek(position);
      _position = position;
      notifyListeners();
    } catch (e) {
      print('Error seeking: $e');
    }
  }

  void toggleShuffle() {
    _isShuffled = !_isShuffled;
    _audioService.setShuffleMode(_isShuffled);
    notifyListeners();
  }

  void toggleRepeatMode() {
    switch (_repeatMode) {
      case AudioRepeatMode.none:
        _repeatMode = AudioRepeatMode.all;
        _audioService.setLoopMode(LoopMode.all);
        break;
      case AudioRepeatMode.all:
        _repeatMode = AudioRepeatMode.one;
        _audioService.setLoopMode(LoopMode.one);
        break;
      case AudioRepeatMode.one:
        _repeatMode = AudioRepeatMode.none;
        _audioService.setLoopMode(LoopMode.off);
        break;
    }
    notifyListeners();
  }

  Future<void> setVolume(double volume) async {
    try {
      await _audioService.setVolume(volume);
      notifyListeners();
    } catch (e) {
      print('Error setting volume: $e');
    }
  }

  double get volume => _audioService.volume;

  Future<void> jumpToSong(int index) async {
    if (index < 0 || index >= _playlist.length) return;

    _currentIndex = index;
    await _loadSong(_playlist[index]);
    await play();
  }

}

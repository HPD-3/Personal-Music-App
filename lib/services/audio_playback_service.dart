import 'package:just_audio/just_audio.dart';
import 'package:audio_service/audio_service.dart';

class AudioPlaybackService {
  static final AudioPlaybackService _instance =
      AudioPlaybackService._internal();
  late AudioPlayer _audioPlayer;

  factory AudioPlaybackService() {
    return _instance;
  }

  AudioPlaybackService._internal() {
    _audioPlayer = AudioPlayer();
  }

  AudioPlayer get player => _audioPlayer;

  // Playing state
  Stream<bool> get isPlayingStream => _audioPlayer.playingStream;
  Stream<Duration?> get durationStream => _audioPlayer.durationStream;
  Stream<Duration> get positionStream => _audioPlayer.positionStream;
  Stream<ProcessingState> get processingStateStream =>
      _audioPlayer.processingStateStream;

  bool get isPlaying => _audioPlayer.playing;
  Duration get duration => _audioPlayer.duration ?? Duration.zero;
  Duration get position => _audioPlayer.position;

  // Shuffle and repeat states
  Future<void> setShuffleMode(bool enable) async {
    await _audioPlayer.setShuffleModeEnabled(enable);
  }

  Future<void> setLoopMode(LoopMode mode) async {
    await _audioPlayer.setLoopMode(mode);
  }

  // Load and play
  Future<void> loadSong({
    required String filePath,
    required String id,
    required String title,
    required String artist,
    required String album,
  }) async {
    try {
      await _audioPlayer.setAudioSource(
        AudioSource.uri(
          Uri.file(filePath),
          tag: MediaItem(
            id: id,
            title: title,
            artist: artist,
            album: album,
            artUri: Uri.file(filePath),
          ),
        ),
      );
    } catch (e) {
      print('Error loading song: $e');
    }
  }

  Future<void> playSong({
    required String filePath,
    required String id,
    required String title,
    required String artist,
    required String album,
  }) async {
    try {
      await loadSong(
        filePath: filePath,
        id: id,
        title: title,
        artist: artist,
        album: album,
      );
      await play();
    } catch (e) {
      print('Error playing song: $e');
    }
  }

  // Playback controls
  Future<void> play() async {
    try {
      await _audioPlayer.play();
    } catch (e) {
      print('Error playing: $e');
    }
  }

  Future<void> pause() async {
    try {
      await _audioPlayer.pause();
    } catch (e) {
      print('Error pausing: $e');
    }
  }

  Future<void> resume() async {
    try {
      await _audioPlayer.play();
    } catch (e) {
      print('Error resuming: $e');
    }
  }

  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      print('Error stopping: $e');
    }
  }

  Future<void> seek(Duration position) async {
    try {
      await _audioPlayer.seek(position);
    } catch (e) {
      print('Error seeking: $e');
    }
  }

  // Speed and volume
  Future<void> setSpeed(double speed) async {
    try {
      await _audioPlayer.setSpeed(speed);
    } catch (e) {
      print('Error setting speed: $e');
    }
  }

  Future<void> setVolume(double volume) async {
    try {
      await _audioPlayer.setVolume(volume);
    } catch (e) {
      print('Error setting volume: $e');
    }
  }

  double get volume => _audioPlayer.volume;

  // Playlist handling
  Future<void> setPlaylist(List<String> paths) async {
    try {
      final playlist = ConcatenatingAudioSource(
        children: paths
            .map((path) => AudioSource.file(path))
            .toList(),
      );
      await _audioPlayer.setAudioSource(playlist);
    } catch (e) {
      print('Error setting playlist: $e');
    }
  }

  int? get currentIndex => _audioPlayer.currentIndex;

  Future<void> seekToIndex(int index) async {
    try {
      await _audioPlayer.seek(Duration.zero, index: index);
    } catch (e) {
      print('Error seeking to index: $e');
    }
  }

  // Cleanup
  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }
}

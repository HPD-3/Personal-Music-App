extension DurationExtension on Duration {
  String toMmSsFormat() {
    final minutes = (inMilliseconds ~/ 1000) ~/ 60;
    final seconds = ((inMilliseconds ~/ 1000) % 60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String toHhMmSsFormat() {
    final hours = inHours;
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

class SongModel {
  final int id;
  final String title;
  final String artist;
  final String album;
  final String data; // File path
  final int duration;
  final int albumId;
  final int artistId;
  final String? displayNameExtn;
  final int dateAdded;
  final String? genre;

  SongModel({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.data,
    required this.duration,
    required this.albumId,
    required this.artistId,
    this.displayNameExtn,
    required this.dateAdded,
    this.genre,
  });

  // Get duration in MM:SS format
  String getDurationString() {
    final minutes = (duration ~/ 1000) ~/ 60;
    final seconds = ((duration ~/ 1000) % 60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SongModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

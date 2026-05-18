import 'song_model.dart';

class AlbumModel {
  final int id;
  final String name;
  final String artist;
  final int numOfSongs;
  final int releaseYear;

  List<SongModel> songs;

  AlbumModel({
    required this.id,
    required this.name,
    required this.artist,
    required this.numOfSongs,
    required this.releaseYear,
    this.songs = const [],
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlbumModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

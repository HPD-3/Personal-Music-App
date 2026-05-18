import 'song_model.dart';

class ArtistModel {
  final int id;
  final String name;
  final int numOfSongs;
  final int numOfAlbums;

  List<SongModel> songs;

  ArtistModel({
    required this.id,
    required this.name,
    required this.numOfSongs,
    required this.numOfAlbums,
    this.songs = const [],
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArtistModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

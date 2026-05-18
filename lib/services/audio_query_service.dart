import 'dart:typed_data';
import 'package:on_audio_query/on_audio_query.dart' as oaq;

// Export on_audio_query models (not PlaylistModel - we have our own)
typedef SongModel = oaq.SongModel;
typedef AlbumModel = oaq.AlbumModel;
typedef ArtistModel = oaq.ArtistModel;

class AudioQueryService {
  static final AudioQueryService _instance = AudioQueryService._internal();
  final _audioQuery = oaq.OnAudioQuery();

  factory AudioQueryService() {
    return _instance;
  }

  AudioQueryService._internal();

  // Get all songs
  Future<List<SongModel>> getSongs() async {
    try {
      final songs = await _audioQuery.querySongs(
        sortType: oaq.SongSortType.DISPLAY_NAME,
        orderType: oaq.OrderType.ASC_OR_SMALLER,
        ignoreCase: true,
      );
      return songs;
    } catch (e) {
      print('Error getting songs: $e');
      return [];
    }
  }

  // Get albums
  Future<List<AlbumModel>> getAlbums() async {
    try {
      final albums = await _audioQuery.queryAlbums(
        sortType: oaq.AlbumSortType.ALBUM,
        orderType: oaq.OrderType.ASC_OR_SMALLER,
        ignoreCase: true,
      );
      return albums;
    } catch (e) {
      print('Error getting albums: $e');
      return [];
    }
  }

  // Get artists
  Future<List<ArtistModel>> getArtists() async {
    try {
      final artists = await _audioQuery.queryArtists(
        sortType: oaq.ArtistSortType.ARTIST,
        orderType: oaq.OrderType.ASC_OR_SMALLER,
        ignoreCase: true,
      );
      return artists;
    } catch (e) {
      print('Error getting artists: $e');
      return [];
    }
  }

  // Get songs by artist - filter all songs
  Future<List<SongModel>> getSongsFromArtist(int artistId) async {
    try {
      final songs = await _audioQuery.querySongs();
      return songs.where((song) => song.artistId == artistId).toList();
    } catch (e) {
      print('Error getting songs for artist: $e');
      return [];
    }
  }

  // Get songs by album - filter all songs
  Future<List<SongModel>> getSongsFromAlbum(int albumId) async {
    try {
      final songs = await _audioQuery.querySongs();
      return songs.where((song) => song.albumId == albumId).toList();
    } catch (e) {
      print('Error getting songs for album: $e');
      return [];
    }
  }

  // Search songs
  Future<List<SongModel>> searchSongs(String query) async {
    try {
      if (query.isEmpty) return [];
      final songs = await _audioQuery.querySongs();
      return songs
          .where((song) =>
              (song.title?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
              (song.artist?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
              (song.album?.toLowerCase().contains(query.toLowerCase()) ?? false))
          .toList();
    } catch (e) {
      print('Error searching songs: $e');
      return [];
    }
  }

  // Get album artwork
  Future<Uint8List?> getAlbumArt(int albumId, {int size = 400}) async {
    try {
      return await _audioQuery.queryArtwork(albumId, oaq.ArtworkType.ALBUM);
    } catch (e) {
      print('Error getting album art: $e');
      return null;
    }
  }
}

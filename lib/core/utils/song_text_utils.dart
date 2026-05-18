import '../../services/audio_query_service.dart';

class SongTextUtils {
  static const Set<String> _unknownArtistTokens = {
    '<unknown>',
    'unknown',
    'unknown artist',
  };

  static String displayArtist(SongModel song) {
    final artist = (song.artist ?? '').trim();
    if (artist.isNotEmpty && !_unknownArtistTokens.contains(artist.toLowerCase())) {
      return artist;
    }

    final extracted = extractArtistFromTitle(song.title);
    return extracted.isEmpty ? 'Unknown Artist' : extracted;
  }

  static String displayTitle(SongModel song) {
    final originalTitle = song.title ?? 'Unknown Song';
    final cleaned = cleanTrackTitle(originalTitle);
    return cleaned.isEmpty ? originalTitle : cleaned;
  }

  static String sortArtistKey(SongModel song) {
    final key = displayArtist(song).toLowerCase();
    return key.startsWith('the ') ? key.substring(4) : key;
  }

  static String extractArtistFromTitle(String title) {
    if (title.trim().isEmpty) return '';
    final trimmed = title.trim();
    final separatorMatch = RegExp(r'\s-\s').firstMatch(trimmed);
    if (separatorMatch == null) return '';

    final maybeArtist = trimmed.substring(0, separatorMatch.start).trim();
    if (maybeArtist.length < 2 || maybeArtist.length > 80) return '';

    final invalidPattern = RegExp(r'official|lyric|video', caseSensitive: false);
    if (invalidPattern.hasMatch(maybeArtist)) return '';

    return maybeArtist;
  }

  static String cleanTrackTitle(String title) {
    if (title.trim().isEmpty) return '';
    final trimmed = title.trim();
    final separatorMatch = RegExp(r'\s-\s').firstMatch(trimmed);

    var trackTitle = separatorMatch == null
        ? trimmed
        : trimmed.substring(separatorMatch.end).trim();

    trackTitle = trackTitle.replaceAll(
      RegExp(r'\((official|lyrics?|audio|video)[^)]*\)', caseSensitive: false),
      '',
    );
    trackTitle = trackTitle.replaceAll(
      RegExp(r'\[(official|lyrics?|audio|video)[^\]]*\]', caseSensitive: false),
      '',
    );

    return trackTitle.replaceAll(RegExp(r'\s{2,}'), ' ').trim();
  }
}

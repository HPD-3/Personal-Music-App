import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/playlist_provider.dart';
import '../providers/audio_provider.dart';
import '../core/constants/app_constants.dart';
import '../widgets/shared/song_tile.dart';
import 'player_screen.dart';

class PlaylistDetailScreen extends StatelessWidget {
  final String playlistId;

  const PlaylistDetailScreen({
    super.key,
    required this.playlistId,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaylistProvider>(
      builder: (context, playlistProvider, _) {
        final playlist = playlistProvider.getPlaylistById(playlistId);
        final songs = playlistProvider.getPlaylistSongs(playlistId);

        return Scaffold(
          backgroundColor: const Color(0xFF121212),
          appBar: AppBar(
            backgroundColor: const Color(0xFF121212),
            title: Text(playlist?.name ?? 'Playlist'),
            actions: [
              if (songs.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.play_arrow),
                  onPressed: () async {
                    final navigator = Navigator.of(context);
                    await context.read<AudioProvider>().loadPlaylist(songs, startIndex: 0);
                    await context.read<AudioProvider>().play();
                    if (!navigator.mounted) return;
                    navigator.push(
                      MaterialPageRoute(builder: (_) => const PlayerScreen()),
                    );
                  },
                ),
            ],
          ),
          body: songs.isEmpty
              ? const Center(
                  child: Text(
                    'No songs in this playlist',
                    style: TextStyle(color: Color(0xFFB3B3B3)),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(top: AppConstants.smallPadding),
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    final song = songs[index];
                    return Dismissible(
                      key: ValueKey('${playlistId}_${song.id}'),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: AppConstants.defaultPadding,
                          vertical: AppConstants.smallPadding,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                        ),
                        alignment: Alignment.centerRight,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (_) {
                        context
                            .read<PlaylistProvider>()
                            .removeSongFromPlaylist(playlistId, song.id);
                      },
                      child: SongTile(
                        song: song,
                        onTap: () async {
                          final navigator = Navigator.of(context);
                          await context.read<AudioProvider>().loadPlaylist(
                                songs,
                                startIndex: index,
                              );
                          await context.read<AudioProvider>().play();
                          if (!navigator.mounted) return;
                          navigator.push(
                            MaterialPageRoute(builder: (_) => const PlayerScreen()),
                          );
                        },
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}

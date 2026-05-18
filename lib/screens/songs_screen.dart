import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/audio_query_service.dart';
import '../providers/song_provider.dart';
import '../providers/audio_provider.dart';
import '../providers/playlist_provider.dart';
import '../widgets/shared/song_tile.dart';
import '../core/constants/app_constants.dart';
import 'player_screen.dart';

class SongsScreen extends StatefulWidget {
  const SongsScreen({super.key});

  @override
  State<SongsScreen> createState() => _SongsScreenState();
}

class _SongsScreenState extends State<SongsScreen> {
  late TextEditingController _searchController;
  bool _showSearch = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showSongActions(SongModel song) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.playlist_add, color: Color(0xFF1DB954)),
                title: const Text(
                  'Add to playlist',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _showAddToPlaylistSheet(song);
                },
              ),
              ListTile(
                leading: const Icon(Icons.visibility_off, color: Colors.redAccent),
                title: const Text(
                  'Hide song',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () async {
                  final sheetNavigator = Navigator.of(sheetContext);
                  final messenger = ScaffoldMessenger.of(context);
                  await context.read<SongProvider>().hideSong(song.id);
                  if (!mounted) return;
                  sheetNavigator.pop();
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Song hidden from library')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddToPlaylistSheet(SongModel song) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return Consumer<PlaylistProvider>(
          builder: (_, playlistProvider, child) {
            if (playlistProvider.playlists.isEmpty) {
              return const SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text(
                    'Create a playlist first',
                    style: TextStyle(color: Color(0xFFB3B3B3)),
                  ),
                ),
              );
            }

            return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'Add to playlist',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Divider(height: 1, color: Color(0xFF2B2B2B)),
                  SizedBox(
                    height: 320,
                    child: ListView.builder(
                      itemCount: playlistProvider.playlists.length,
                      itemBuilder: (context, index) {
                        final playlist = playlistProvider.playlists[index];
                        final inPlaylist =
                            playlistProvider.isSongInPlaylist(playlist.id, song.id);
                        return ListTile(
                          leading: const Icon(
                            Icons.playlist_play,
                            color: Color(0xFF1DB954),
                          ),
                          title: Text(
                            playlist.name,
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            '${playlist.songIds.length} songs',
                            style: const TextStyle(color: Color(0xFFB3B3B3)),
                          ),
                          trailing: Icon(
                            inPlaylist ? Icons.check_circle : Icons.add_circle_outline,
                            color: inPlaylist
                                ? const Color(0xFF1DB954)
                                : const Color(0xFFB3B3B3),
                          ),
                          onTap: inPlaylist
                              ? null
                              : () async {
                                  final sheetNavigator = Navigator.of(sheetContext);
                                  final messenger = ScaffoldMessenger.of(context);
                                  await context
                                      .read<PlaylistProvider>()
                                      .addSongToPlaylist(playlist.id, song.id);
                                  if (!mounted) return;
                                  sheetNavigator.pop();
                                  messenger.showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Added to "${playlist.name}"',
                                      ),
                                    ),
                                  );
                                },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SongProvider>(
      builder: (context, songProvider, _) {
        return Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                child: _showSearch
                    ? TextField(
                        controller: _searchController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Search songs...',
                          hintStyle: const TextStyle(color: Color(0xFF79797D)),
                          prefixIcon: const Icon(Icons.search, color: Color(0xFFB3B3B3)),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.close, color: Color(0xFFB3B3B3)),
                            onPressed: () {
                              _searchController.clear();
                              songProvider.clearSearch();
                              setState(() => _showSearch = false);
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: const Color(0xFF282828),
                        ),
                        onChanged: (value) {
                          songProvider.searchSongs(value);
                        },
                      )
                    : GestureDetector(
                        onTap: () => setState(() => _showSearch = true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF282828),
                            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.search, color: Color(0xFFB3B3B3)),
                              SizedBox(width: 12),
                              Text(
                                'Search songs...',
                                style: TextStyle(color: Color(0xFF79797D)),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
            ),
            // Sort options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _SortChip(
                      label: 'Name',
                      onTap: () => songProvider.sortSongs(SortOption.byName),
                    ),
                    const SizedBox(width: 8),
                    _SortChip(
                      label: 'Artist',
                      onTap: () => songProvider.sortSongs(SortOption.byArtist),
                    ),
                    const SizedBox(width: 8),
                    _SortChip(
                      label: 'Duration',
                      onTap: () => songProvider.sortSongs(SortOption.byDuration),
                    ),
                    const SizedBox(width: 8),
                    _SortChip(
                      label: 'Recently Added',
                      onTap: () => songProvider.sortSongs(SortOption.byDateAdded),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            // Songs list
            Expanded(
              child: songProvider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1DB954)),
                      ),
                    )
                  : songProvider.filteredSongs.isEmpty
                      ? const Center(
                          child: Text(
                            'No songs found',
                            style: TextStyle(color: Color(0xFFB3B3B3)),
                          ),
                        )
                      : ListView.builder(
                          itemCount: songProvider.filteredSongs.length,
                          itemBuilder: (context, index) {
                            final song = songProvider.filteredSongs[index];
                            return SongTile(
                              song: song,
                              onLongPress: () => _showSongActions(song),
                              onTap: () async {
                                final navigator = Navigator.of(context);
                                await context.read<AudioProvider>().loadPlaylist(
                                  songProvider.filteredSongs,
                                  startIndex: index,
                                );
                                await context.read<AudioProvider>().play();
                                if (!navigator.mounted) return;
                                navigator.push(
                                  MaterialPageRoute(
                                    builder: (_) => const PlayerScreen(),
                                  ),
                                );
                              },
                            );
                          },
                        ),
            ),
          ],
        );
      },
    );
  }
}

class _SortChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SortChip({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF282828),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF3E3E42)),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Color(0xFFB3B3B3),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

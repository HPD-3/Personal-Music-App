import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/playlist_provider.dart';
import '../core/constants/app_constants.dart';

class PlaylistsScreen extends StatefulWidget {
  const PlaylistsScreen({super.key});

  @override
  State<PlaylistsScreen> createState() => _PlaylistsScreenState();
}

class _PlaylistsScreenState extends State<PlaylistsScreen> {
  late TextEditingController _playlistNameController;

  @override
  void initState() {
    super.initState();
    _playlistNameController = TextEditingController();
  }

  @override
  void dispose() {
    _playlistNameController.dispose();
    super.dispose();
  }

  void _showCreatePlaylistDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF282828),
        title: const Text(
          'Create Playlist',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: _playlistNameController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Playlist name',
            hintStyle: TextStyle(color: Color(0xFF79797D)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (_playlistNameController.text.isNotEmpty) {
                context.read<PlaylistProvider>().createPlaylist(
                  _playlistNameController.text,
                );
                _playlistNameController.clear();
                Navigator.pop(context);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaylistProvider>(
      builder: (context, playlistProvider, _) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Your Playlists',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _showCreatePlaylistDialog,
                    icon: const Icon(Icons.add),
                    label: const Text('New'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1DB954),
                    ),
                  ),
                ],
              ),
            ),
            if (playlistProvider.playlists.isEmpty)
              const Expanded(
                child: Center(
                  child: Text(
                    'No playlists yet. Create one!',
                    style: TextStyle(color: Color(0xFFB3B3B3)),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: playlistProvider.playlists.length,
                  itemBuilder: (context, index) {
                    final playlist = playlistProvider.playlists[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: AppConstants.defaultPadding,
                        vertical: AppConstants.smallPadding,
                      ),
                      padding: const EdgeInsets.all(AppConstants.smallPadding),
                      decoration: BoxDecoration(
                        color: const Color(0xFF282828),
                        borderRadius:
                            BorderRadius.circular(AppConstants.borderRadius),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.playlist_play,
                            color: Color(0xFF1DB954)),
                        title: Text(
                          playlist.name,
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          '${playlist.songIds.length} songs',
                          style: const TextStyle(color: Color(0xFFB3B3B3)),
                        ),
                        trailing: PopupMenuButton(
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              child: const Text('Edit'),
                              onTap: () {
                                _playlistNameController.text = playlist.name;
                                _showCreatePlaylistDialog();
                              },
                            ),
                            PopupMenuItem(
                              child: const Text('Delete'),
                              onTap: () {
                                playlistProvider.deletePlaylist(playlist.id);
                              },
                            ),
                          ],
                        ),
                      ),
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

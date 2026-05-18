import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/audio_provider.dart';
import '../widgets/player/mini_player.dart';
import 'songs_screen.dart';
import 'albums_screen.dart';
import 'artists_screen.dart';
import 'playlists_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    SongsScreen(),
    AlbumsScreen(),
    ArtistsScreen(),
    PlaylistsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Music Player'),
        elevation: 0,
        backgroundColor: const Color(0xFF121212),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Main content
          IndexedStack(
            index: _selectedIndex,
            children: _screens,
          ),
          // Mini player at bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 60,
            child: Consumer<AudioProvider>(
              builder: (context, audioProvider, _) {
                if (audioProvider.currentSong == null) {
                  return const SizedBox.shrink();
                }
                return const MiniPlayer();
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Consumer<AudioProvider>(
        builder: (context, audioProvider, _) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: audioProvider.currentSong != null ? 60 : 0,
            ),
            child: BottomNavigationBar(
              currentIndex: _selectedIndex,
              backgroundColor: const Color(0xFF1E1E1E),
              selectedItemColor: const Color(0xFF1DB954),
              unselectedItemColor: const Color(0xFF79797D),
              type: BottomNavigationBarType.fixed,
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.music_note),
                  label: 'Songs',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.album),
                  label: 'Albums',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Artists',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.playlist_play),
                  label: 'Playlists',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

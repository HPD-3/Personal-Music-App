import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/song_provider.dart';
import '../providers/audio_provider.dart';
import '../widgets/shared/song_tile.dart';
import '../core/constants/app_constants.dart';
import 'player_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SongProvider>(
      builder: (context, songProvider, _) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Row(
                children: [
                  const Icon(
                    Icons.favorite,
                    color: Color(0xFF1DB954),
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Favorites (${songProvider.favoritesSongs.length})',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            if (songProvider.favoritesSongs.isEmpty)
              const Expanded(
                child: Center(
                  child: Text(
                    'No favorite songs yet',
                    style: TextStyle(color: Color(0xFFB3B3B3)),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: songProvider.favoritesSongs.length,
                  itemBuilder: (context, index) {
                    final song = songProvider.favoritesSongs[index];
                    return SongTile(
                      song: song,
                      onTap: () async {
                        final navigator = Navigator.of(context);
                        await context.read<AudioProvider>().loadPlaylist(
                          songProvider.favoritesSongs,
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

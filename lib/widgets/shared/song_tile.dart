import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/audio_query_service.dart';
import '../../providers/favorites_provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/extensions/duration_extension.dart';

class SongTile extends StatelessWidget {
  final SongModel song;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const SongTile({
    super.key,
    required this.song,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritesProvider>(
      builder: (context, favoritesProvider, _) {
        final isFavorite = favoritesProvider.isFavorite(song.id);
        
        return GestureDetector(
          onTap: onTap,
          onLongPress: onLongPress,
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: AppConstants.defaultPadding,
              vertical: AppConstants.smallPadding,
            ),
            padding: const EdgeInsets.all(AppConstants.smallPadding),
            decoration: BoxDecoration(
              color: const Color(0xFF282828),
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
            child: Row(
              children: [
                // Album art placeholder
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1F1F1F),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.music_note,
                    color: Color(0xFF79797D),
                    size: 28,
                  ),
                ),
                const SizedBox(width: AppConstants.defaultPadding),
                // Song info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        song.title ?? 'Unknown Song',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        song.artist ?? 'Unknown Artist',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFFB3B3B3),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Duration
                Text(
                  Duration(milliseconds: song.duration ?? 0).toMmSsFormat(),
                  style: const TextStyle(
                    color: Color(0xFF79797D),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 8),
                // Favorite button
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? const Color(0xFF1DB954) : const Color(0xFF79797D),
                    size: 20,
                  ),
                  onPressed: () {
                    favoritesProvider.toggleFavorite(song.id);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

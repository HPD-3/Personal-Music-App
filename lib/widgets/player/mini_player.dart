import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/audio_provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/song_text_utils.dart';
import '../../screens/player_screen.dart';
import '../shared/custom_buttons.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioProvider>(
      builder: (context, audioProvider, _) {
        final song = audioProvider.currentSong;
        if (song == null) {
          return const SizedBox.shrink();
        }

        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PlayerScreen()),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: AppConstants.defaultPadding,
              vertical: AppConstants.smallPadding,
            ),
            padding: const EdgeInsets.all(AppConstants.smallPadding),
            decoration: BoxDecoration(
              color: const Color(0xFF282828),
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Row(
              children: [
                // Album art
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1F1F1F),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.music_note,
                    color: Color(0xFF79797D),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                // Song info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        SongTextUtils.displayTitle(song),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        SongTextUtils.displayArtist(song),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFFB3B3B3),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Play/Pause button
                CustomIconButton(
                  icon: audioProvider.isPlaying ? Icons.pause : Icons.play_arrow,
                  onPressed: audioProvider.isPlaying
                      ? audioProvider.pause
                      : audioProvider.play,
                  size: 18,
                  backgroundColor: const Color(0xFF1DB954),
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                // Next button
                CustomIconButton(
                  icon: Icons.skip_next,
                  onPressed: audioProvider.next,
                  size: 18,
                  backgroundColor: const Color(0xFF1F1F1F),
                  color: const Color(0xFFB3B3B3),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

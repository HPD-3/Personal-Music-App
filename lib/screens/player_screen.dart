import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/audio_provider.dart';
import '../core/extensions/duration_extension.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/song_text_utils.dart';
import '../widgets/shared/custom_buttons.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.expand_more),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer<AudioProvider>(
        builder: (context, audioProvider, _) {
          final song = audioProvider.currentSong;
          if (song == null) {
            return const Center(
              child: Text('No song playing'),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                children: [
                  // Album Art
                  Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      color: const Color(0xFF282828),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1DB954).withOpacity(0.2),
                          blurRadius: 30,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.music_note,
                      size: 140,
                      color: Color(0xFF79797D),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Song info
                  Text(
                    SongTextUtils.displayTitle(song),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    SongTextUtils.displayArtist(song),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFFB3B3B3),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Progress slider
                  Column(
                    children: [
                      CustomSlider(
                        value: audioProvider.position.inMilliseconds.toDouble(),
                        min: 0,
                        max: audioProvider.duration.inMilliseconds.toDouble(),
                        onChanged: (value) {
                          audioProvider.seek(Duration(milliseconds: value.toInt()));
                        },
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            audioProvider.position.toMmSsFormat(),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF79797D),
                            ),
                          ),
                          Text(
                            audioProvider.duration.toMmSsFormat(),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF79797D),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // Control buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Repeat button
                      CustomIconButton(
                        icon: _getRepeatIcon(audioProvider.repeatMode),
                        onPressed: audioProvider.toggleRepeatMode,
                        backgroundColor: const Color(0xFF282828),
                      ),
                      // Previous
                      CustomIconButton(
                        icon: Icons.skip_previous,
                        onPressed: audioProvider.previous,
                        size: 28,
                        backgroundColor: const Color(0xFF282828),
                      ),
                      // Play/Pause
                      CustomPlayButton(
                        isPlaying: audioProvider.isPlaying,
                        onPressed: audioProvider.isPlaying
                            ? audioProvider.pause
                            : audioProvider.play,
                      ),
                      // Next
                      CustomIconButton(
                        icon: Icons.skip_next,
                        onPressed: audioProvider.next,
                        size: 28,
                        backgroundColor: const Color(0xFF282828),
                      ),
                      // Shuffle button
                      CustomIconButton(
                        icon: Icons.shuffle,
                        onPressed: audioProvider.toggleShuffle,
                        backgroundColor: audioProvider.isShuffled
                            ? const Color(0xFF1DB954)
                            : const Color(0xFF282828),
                        color: audioProvider.isShuffled ? Colors.white : const Color(0xFFB3B3B3),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // Additional info
                  Container(
                    padding: const EdgeInsets.all(AppConstants.defaultPadding),
                    decoration: BoxDecoration(
                      color: const Color(0xFF282828),
                      borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Album',
                          style: TextStyle(
                            color: Color(0xFF79797D),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          (song.album ?? '').isEmpty ? 'Unknown Album' : song.album!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _getRepeatIcon(AudioRepeatMode mode) {
    switch (mode) {
      case AudioRepeatMode.none:
        return Icons.repeat;
      case AudioRepeatMode.all:
        return Icons.repeat;
      case AudioRepeatMode.one:
        return Icons.repeat_one;
    }
  }
}

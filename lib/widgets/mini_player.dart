import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import '../providers/player_provider.dart';
import '../screens/player_screen.dart';
import '../core/theme.dart';
import '../core/constants.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PlayerProvider>();
    final song = provider.currentSong;
    if (song == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PlayerScreen()),
      ),
      child: Container(
        height: AppConstants.miniPlayerHeight,
        decoration: const BoxDecoration(
          color: AppTheme.surface,
          border: Border(top: BorderSide(color: AppTheme.surfaceAlt, width: 0.5)),
        ),
        child: Column(
          children: [
            // Progress bar
            StreamBuilder<Duration>(
              stream: provider.positionStream,
              builder: (context, posSnap) {
                return StreamBuilder<Duration?>(
                  stream: provider.durationStream,
                  builder: (context, durSnap) {
                    final pos = posSnap.data ?? Duration.zero;
                    final dur = durSnap.data ?? Duration.zero;
                    final progress = dur.inMilliseconds > 0
                        ? pos.inMilliseconds / dur.inMilliseconds
                        : 0.0;
                    return LinearProgressIndicator(
                      value: progress.clamp(0.0, 1.0),
                      backgroundColor: AppTheme.surfaceAlt,
                      valueColor: const AlwaysStoppedAnimation(AppTheme.primary),
                      minHeight: 2,
                    );
                  },
                );
              },
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    // Art
                    Container(
                      width: 42, height: 42,
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceAlt,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(Icons.music_note, color: AppTheme.textSecondary),
                    ),
                    const SizedBox(width: 12),
                    // Info
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            song.title,
                            style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            song.artist,
                            style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // Controls
                    StreamBuilder<PlayerState>(
                      stream: provider.playerStateStream,
                      builder: (_, snap) {
                        final playing = snap.data?.playing ?? false;
                        return Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.skip_previous, color: AppTheme.textPrimary),
                              onPressed: provider.playPrevious,
                            ),
                            IconButton(
                              icon: Icon(
                                playing ? Icons.pause : Icons.play_arrow,
                                color: AppTheme.primary,
                                size: 28,
                              ),
                              onPressed: provider.togglePlayPause,
                            ),
                            IconButton(
                              icon: const Icon(Icons.skip_next, color: AppTheme.textPrimary),
                              onPressed: provider.playNext,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
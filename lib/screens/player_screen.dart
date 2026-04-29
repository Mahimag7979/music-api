import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import '../providers/player_provider.dart';
import '../services/audio_service.dart';
import '../core/theme.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PlayerProvider>();
    final song = provider.currentSong;

    if (song == null) {
      return const Scaffold(body: Center(child: Text('No song selected')));
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down, size: 32),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Now Playing',
            style: TextStyle(fontSize: 14, color: AppTheme.textSecondary)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              provider.isFavorite(song.id) ? Icons.favorite : Icons.favorite_border,
              color: provider.isFavorite(song.id)
                  ? AppTheme.primary
                  : AppTheme.textSecondary,
            ),
            onPressed: () => provider.toggleFavorite(song),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Album Art
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                color: AppTheme.surfaceAlt,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withOpacity(0.2),
                    blurRadius: 40,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Icon(Icons.music_note, size: 100, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 32),
            // Song info
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        song.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        song.artist,
                        style: const TextStyle(fontSize: 15, color: AppTheme.textSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.download_outlined, color: AppTheme.textSecondary),
                  onPressed: () => provider.downloadSong(song),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Progress
            StreamBuilder<Duration>(
              stream: provider.positionStream,
              builder: (_, posSnap) {
                return StreamBuilder<Duration?>(
                  stream: provider.durationStream,
                  builder: (_, durSnap) {
                    final pos = posSnap.data ?? Duration.zero;
                    final dur = durSnap.data ?? Duration.zero;
                    return Column(
                      children: [
                        Slider(
                          value: dur.inMilliseconds > 0
                              ? (pos.inMilliseconds / dur.inMilliseconds)
                                  .clamp(0.0, 1.0)
                              : 0.0,
                          onChanged: (v) => provider.seek(
                            Duration(milliseconds: (v * dur.inMilliseconds).round()),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_formatDuration(pos),
                                  style: const TextStyle(
                                      color: AppTheme.textSecondary, fontSize: 12)),
                              Text(_formatDuration(dur),
                                  style: const TextStyle(
                                      color: AppTheme.textSecondary, fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            // Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Shuffle
                IconButton(
                  icon: Icon(
                    Icons.shuffle,
                    color: provider.isShuffled
                        ? AppTheme.primary
                        : AppTheme.textSecondary,
                  ),
                  onPressed: provider.toggleShuffle,
                ),
                // Previous
                IconButton(
                  icon: const Icon(Icons.skip_previous,
                      size: 36, color: AppTheme.textPrimary),
                  onPressed: provider.playPrevious,
                ),
                // Play/Pause
                StreamBuilder<PlayerState>(
                  stream: provider.playerStateStream,
                  builder: (_, snap) {
                    final playing = snap.data?.playing ?? false;
                    final loading =
                        snap.data?.processingState == ProcessingState.loading ||
                        snap.data?.processingState == ProcessingState.buffering;
                    return GestureDetector(
                      onTap: provider.togglePlayPause,
                      child: Container(
                        width: 68,
                        height: 68,
                        decoration: const BoxDecoration(
                          color: AppTheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: loading
                            ? const Padding(
                                padding: EdgeInsets.all(18),
                                child: CircularProgressIndicator(
                                    color: Colors.black, strokeWidth: 2.5),
                              )
                            : Icon(
                                playing ? Icons.pause : Icons.play_arrow,
                                size: 36,
                                color: Colors.black,
                              ),
                      ),
                    );
                  },
                ),
                // Next
                IconButton(
                  icon: const Icon(Icons.skip_next,
                      size: 36, color: AppTheme.textPrimary),
                  onPressed: provider.playNext,
                ),
                // Repeat
                IconButton(
                  icon: Icon(
                    provider.repeatMode == AudioRepeatMode.one
                        ? Icons.repeat_one
                        : Icons.repeat,
                    color: provider.repeatMode != AudioRepeatMode.none
                        ? AppTheme.primary
                        : AppTheme.textSecondary,
                  ),
                  onPressed: provider.toggleRepeat,
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Volume
            Row(
              children: [
                const Icon(Icons.volume_down, color: AppTheme.textSecondary),
                Expanded(
                  child: Slider(
                    value: provider.audioService.player.volume,
                    onChanged: (v) => provider.audioService.setVolume(v),
                  ),
                ),
                const Icon(Icons.volume_up, color: AppTheme.textSecondary),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
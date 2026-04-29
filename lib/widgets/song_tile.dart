import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/song.dart';
import '../providers/player_provider.dart';
import '../core/theme.dart';

class SongTile extends StatelessWidget {
  final Song song;
  final List<Song>? queue;
  final bool showIndex;
  final int? index;

  const SongTile({
    super.key,
    required this.song,
    this.queue,
    this.showIndex = false,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PlayerProvider>();
    final isActive = provider.currentSong?.id == song.id;
    final isFav = provider.isFavorite(song.id);
    final dlSvc = provider.downloadService;
    final isDownloaded = dlSvc.isDownloaded(song.id);
    final dlProgress = dlSvc.downloadProgress(song.id);

    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: _buildLeading(isActive),
      title: Text(
        song.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: isActive ? AppTheme.primary : AppTheme.textPrimary,
          fontWeight:
              isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: Text(
        song.artist,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
            color: AppTheme.textSecondary, fontSize: 12),
      ),
      trailing: SizedBox(
        width: 80, // ← fixed width stops URL overflow
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (dlProgress != null)
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  value: dlProgress,
                  strokeWidth: 2,
                  color: AppTheme.primary,
                ),
              )
            else
              IconButton(
                icon: Icon(
                  isDownloaded
                      ? Icons.download_done
                      : Icons.download_outlined,
                  size: 20,
                  color: isDownloaded
                      ? AppTheme.primary
                      : AppTheme.textSecondary,
                ),
                onPressed: () => provider.downloadSong(song),
              ),
            IconButton(
              icon: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                size: 20,
                color: isFav
                    ? Colors.redAccent
                    : AppTheme.textSecondary,
              ),
              onPressed: () => provider.toggleFavorite(song),
            ),
          ],
        ),
      ),
      onTap: () => provider.playSong(song, queue: queue),
    );
  }

  Widget _buildLeading(bool isActive) {
    // Show album art image
    if (song.imageUrl.isNotEmpty && !isActive) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.network(
          song.imageUrl,
          width: 44,
          height: 44,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _defaultIcon(isActive),
        ),
      );
    }
    return _defaultIcon(isActive);
  }

  Widget _defaultIcon(bool isActive) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppTheme.surfaceAlt,
        borderRadius: BorderRadius.circular(6),
      ),
      child: isActive
          ? const Icon(Icons.equalizer, color: AppTheme.primary)
          : const Icon(Icons.music_note,
              color: AppTheme.textSecondary),
    );
  }
}
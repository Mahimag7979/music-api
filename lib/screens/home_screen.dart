import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/player_provider.dart';
import '../widgets/song_tile.dart';
import '../widgets/search_bar.dart';
import '../core/theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PlayerProvider>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'RhythmAlchemist',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: provider.loadSongs,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: MusicSearchBar(
              onChanged: provider.search,
              onCleared: provider.clearSearch,
            ),
          ),

          // Genre chips — hidden while searching
          if (!provider.isSearching) ...[
            SizedBox(
              height: 40,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: PlayerProvider.genres.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final genre = PlayerProvider.genres[i];
                  final selected = provider.selectedGenre == genre['name'];
                  return ChoiceChip(
                    label: Text(genre['name']),
                    selected: selected,
                    onSelected: (_) =>
                        provider.loadByGenre(genre['name'], genre['id']),
                    selectedColor: AppTheme.primary,
                    backgroundColor: AppTheme.surfaceAlt,
                    labelStyle: TextStyle(
                      color: selected ? Colors.black : AppTheme.textSecondary,
                      fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),

            // Section title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text(
                provider.selectedGenre == 'Trending'
                    ? '🔥 Trending Now'
                    : '🎵 ${provider.selectedGenre}',
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ] else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text(
                provider.isLoading
                    ? 'Searching...'
                    : '${provider.displayedSongs.length} results',
                style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
              ),
            ),

          // Song list
          if (provider.isLoading)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(color: AppTheme.primary),
              ),
            )
          else if (provider.displayedSongs.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.music_off,
                        color: AppTheme.textSecondary, size: 56),
                    const SizedBox(height: 12),
                    Text(
                      provider.isSearching
                          ? 'No results found'
                          : 'Could not load songs.\nCheck your internet connection.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppTheme.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.black,
                      ),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try Again'),
                      onPressed: provider.loadSongs,
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: provider.displayedSongs.length,
                itemBuilder: (context, i) => SongTile(
                  song: provider.displayedSongs[i],
                  queue: provider.displayedSongs,
                  showIndex: true,
                  index: i,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
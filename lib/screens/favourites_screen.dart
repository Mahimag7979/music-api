import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/player_provider.dart';
import '../widgets/song_tile.dart';
import '../core/theme.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PlayerProvider>();
    final songs = provider.favoriteSongs;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Favourites'),
      ),
      body: songs.isEmpty
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.favorite_border,
                      color: AppTheme.textSecondary, size: 56),
                  SizedBox(height: 12),
                  Text(
                    'No favourites yet.\nTap ❤️ on any song to save it.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, i) => SongTile(
                song: songs[i],
                queue: songs,
                showIndex: true,
                index: i,
              ),
            ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/player_provider.dart';
import '../widgets/song_tile.dart';
import '../core/background.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = Provider.of<PlayerProvider>(context);

    final favSongs = p.playlist
        .where((s) => p.favorites.contains(s.id))
        .toList();

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 10),

              const Text(
                "Favorites",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Expanded(
                child: favSongs.isEmpty
                    ? const Center(
                        child: Text(
                          "No favorites yet",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : ListView.builder(
                        itemCount: favSongs.length,
                        itemBuilder: (c, i) {
                          return SongTile(
                            song: favSongs[i],
                            list: favSongs,
                            index: i,
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
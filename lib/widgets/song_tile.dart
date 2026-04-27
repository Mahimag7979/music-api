import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/song.dart';
import '../providers/player_provider.dart';

class SongTile extends StatelessWidget {
  final Song song;
  final List<Song> list;
  final int index;

  const SongTile({
    super.key,
    required this.song,
    required this.list,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.read<PlayerProvider>();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: LinearGradient(
                colors: [
                  song.color,
                  song.color.withOpacity(0.6),
                ],
              ),
            ),
            child: const Icon(Icons.music_note, color: Colors.white),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              song.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // ❤️ FAVORITE BUTTON
          Consumer<PlayerProvider>(
            builder: (_, p, __) {
              final fav = p.isFavorite(song.id);

              return IconButton(
                icon: Icon(
                  fav ? Icons.favorite : Icons.favorite_border,
                  color: fav ? Colors.red : Colors.white,
                ),
                onPressed: () => p.toggleFavorite(song),
              );
            },
          ),

          // ▶️ PLAY BUTTON
          IconButton(
            icon: const Icon(Icons.play_arrow, color: Colors.white),
            onPressed: () => p.playList(list, index),
          ),
        ],
      ),
    );
  }
}
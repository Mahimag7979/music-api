import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/song.dart';
import '../providers/player_provider.dart';
import '../screens/player_screen.dart';

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
    final p = context.watch<PlayerProvider>();
    final isPlaying = p.current?.id == song.id && p.isPlaying;

    return ListTile(
      leading: const Icon(Icons.music_note, color: Colors.white),

      title: Text(song.title,
          style: const TextStyle(color: Colors.white)),

      subtitle: Text(song.artist,
          style: const TextStyle(color: Colors.white54)),

      trailing: Icon(
        isPlaying ? Icons.pause : Icons.play_arrow,
        color: Colors.white,
      ),

      onTap: () async {
        await context.read<PlayerProvider>().play(list, index);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const PlayerScreen(),
          ),
        );
      },
    );
  }
}
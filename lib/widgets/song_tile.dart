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
    return Consumer<PlayerProvider>(
      builder: (_, p, __) {
        final isPlaying =
            p.current?.id == song.id && p.playing;

        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(song.image),
          ),

          title: Text(
            song.title,
            style: const TextStyle(color: Colors.white),
          ),

          subtitle: Text(
            song.artist,
            style: const TextStyle(color: Colors.white54),
          ),

          trailing: Icon(
            isPlaying ? Icons.equalizer : Icons.play_arrow,
            color: Colors.white,
          ),

          onTap: () async {
            await p.play(list, index);
          },
        );
      },
    );
  }
}
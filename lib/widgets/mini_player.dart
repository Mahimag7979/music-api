import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/player_provider.dart';
import '../screens/player_screen.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final p = Provider.of<PlayerProvider>(context);

    if (p.current == null) return const SizedBox();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PlayerScreen()),
        );
      },
      child: Container(
        color: Colors.black87,
        child: ListTile(
          title: Text(p.current!.title, style: const TextStyle(color: Colors.white)),
          trailing: IconButton(
            icon: Icon(p.playing ? Icons.pause : Icons.play_arrow, color: Colors.white),
            onPressed: p.toggle,
          ),
        ),
      ),
    );
  }
}
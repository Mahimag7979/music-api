import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/player_provider.dart';
import '../core/background.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerProvider>(
      builder: (_, p, __) {
        final song = p.current;

        return Scaffold(
          body: AppBackground(
            child: SafeArea(
              child: Center(
                child: song == null
                    ? const Text(
                        "No song playing",
                        style: TextStyle(color: Colors.white),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 🎵 ICON
                          const Icon(
                            Icons.music_note,
                            size: 100,
                            color: Colors.white,
                          ),

                          const SizedBox(height: 20),

                          // 🎶 TITLE
                          Text(
                            song.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 30),

                          // 🎮 CONTROLS
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // ⏮ PREVIOUS
                              IconButton(
                                icon: const Icon(
                                  Icons.skip_previous,
                                  color: Colors.white,
                                  size: 40,
                                ),
                                onPressed: p.previous,
                              ),

                              // ▶️ PLAY / PAUSE
                              IconButton(
                                icon: Icon(
                                  p.playing
                                      ? Icons.pause_circle
                                      : Icons.play_circle,
                                  size: 70,
                                  color: Colors.white,
                                ),
                                onPressed: p.toggle,
                              ),

                              // ⏭ NEXT
                              IconButton(
                                icon: const Icon(
                                  Icons.skip_next,
                                  color: Colors.white,
                                  size: 40,
                                ),
                                onPressed: p.next,
                              ),
                            ],
                          ),
                        ],
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}
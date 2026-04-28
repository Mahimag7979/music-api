import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/player_provider.dart';
import '../core/background.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<PlayerProvider>();
    final song = p.current;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: AppBackground(
        child: SafeArea(
          child: Center(
            child: song == null
                ? const Text("No song",
                    style: TextStyle(color: Colors.white))
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.music_note,
                          size: 100, color: Colors.white),

                      const SizedBox(height: 20),

                      Text(
                        song.title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 30),

                      // 🎚 PROGRESS + TIME
                      StreamBuilder<Duration>(
                        stream: p.positionStream,
                        builder: (_, snapshot) {
                          final pos = snapshot.data ?? Duration.zero;

                          return StreamBuilder<Duration?>(
                            stream: p.durationStream,
                            builder: (_, snap) {
                              final dur = snap.data ?? Duration.zero;

                              return Column(
                                children: [
                                  Slider(
                                    min: 0,
                                    max: dur.inSeconds == 0
                                        ? 1
                                        : dur.inSeconds.toDouble(),
                                    value: pos.inSeconds
                                        .clamp(0, dur.inSeconds)
                                        .toDouble(),
                                    onChanged: (v) {
                                      p.seek(Duration(seconds: v.toInt()));
                                    },
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(_format(pos),
                                            style: const TextStyle(
                                                color: Colors.white70)),
                                        Text(_format(dur),
                                            style: const TextStyle(
                                                color: Colors.white70)),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 30),

                      // 🎮 CONTROLS
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.skip_previous,
                                color: Colors.white, size: 40),
                            onPressed: p.previous,
                          ),
                          IconButton(
                            icon: Icon(
                              p.isPlaying
                                  ? Icons.pause_circle
                                  : Icons.play_circle,
                              size: 70,
                              color: Colors.white,
                            ),
                            onPressed: p.toggle,
                          ),
                          IconButton(
                            icon: const Icon(Icons.skip_next,
                                color: Colors.white, size: 40),
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
  }

  String _format(Duration d) {
    final m = d.inMinutes.toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }
}
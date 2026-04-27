import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/player_provider.dart';
import '../core/background.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  String format(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  @override
  Widget build(BuildContext context) {
    final p = Provider.of<PlayerProvider>(context);

    return Scaffold(
      body: AppBackground( // 🔥 APPLY GLOBAL BACKGROUND
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // 🎵 ICON / ALBUM
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
                child: const Icon(Icons.music_note,
                    size: 100, color: Colors.white),
              ),

              const SizedBox(height: 20),

              Text(
                p.current?.title ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              // 🎚 PROGRESS BAR
              StreamBuilder<Duration?>(
                stream: p.durationStream,
                builder: (context, dSnap) {
                  final duration = dSnap.data ?? Duration.zero;

                  return StreamBuilder<Duration>(
                    stream: p.positionStream,
                    builder: (context, pSnap) {
                      final position = pSnap.data ?? Duration.zero;

                      final max = duration.inSeconds > 0
                          ? duration.inSeconds.toDouble()
                          : 1.0;

                      final value = position.inSeconds
                          .clamp(0, max.toInt())
                          .toDouble();

                      return Column(
                        children: [
                          Slider(
                            activeColor: Colors.purple,
                            value: value,
                            max: max,
                            onChanged: (v) {
                              p.audio.player
                                  .seek(Duration(seconds: v.toInt()));
                            },
                          ),

                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(format(position),
                                    style: const TextStyle(
                                        color: Colors.white)),
                                Text(format(duration),
                                    style: const TextStyle(
                                        color: Colors.white)),
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
                    iconSize: 70,
                    icon: Icon(
                      p.playing
                          ? Icons.pause_circle
                          : Icons.play_circle,
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
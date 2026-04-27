import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/song.dart';
import '../widgets/song_tile.dart';
import '../widgets/mini_player.dart';
import '../widgets/search_bar.dart';
import '../core/background.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Song> songs = [];
  List<Song> allSongs = [];

  @override
  void initState() {
    super.initState();
    loadSongs();
  }

  void loadSongs() async {
    final data = await ApiService().fetchSongs();
    setState(() {
      songs = data;
      allSongs = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 10),

              // 🔥 HEADER (TITLE + FAVORITES BUTTON)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Pulse Player',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const FavoritesScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // 🔍 SEARCH BAR
              SearchBarWidget(
                onChanged: (query) {
                  setState(() {
                    songs = allSongs
                        .where((s) => s.title
                            .toLowerCase()
                            .contains(query.toLowerCase()))
                        .toList();
                  });
                },
              ),

              const SizedBox(height: 5),

              // 🎧 SONG LIST
              Expanded(
                child: songs.isEmpty
                    ? const Center(
                        child: Text(
                          "No songs found",
                          style: TextStyle(color: Colors.white70),
                        ),
                      )
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: songs.length,
                        itemBuilder: (c, i) {
                          return SongTile(
                            song: songs[i],
                            list: songs,
                            index: i,
                          );
                        },
                      ),
              ),

              // 🎵 MINI PLAYER
              const MiniPlayer(),
            ],
          ),
        ),
      ),
    );
  }
}
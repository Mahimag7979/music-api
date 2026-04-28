import 'package:flutter/material.dart';
import '../models/song.dart';
import '../services/api_service.dart';
import '../widgets/song_tile.dart';
import '../widgets/search_bar.dart';
import '../core/background.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Song> songs = [];
  List<Song> filtered = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadSongs();
  }

  void loadSongs() async {
    final data = await ApiService().fetchSongs();

    if (!mounted) return;

    setState(() {
      songs = data;
      filtered = data;
      loading = false;
    });
  }

  void search(String q) {
    setState(() {
      filtered = songs
          .where((s) =>
              s.title.toLowerCase().contains(q.toLowerCase()))
          .toList();
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

              const Text(
                "Pulse Player",
                style: TextStyle(color: Colors.white, fontSize: 26),
              ),

              SearchBarWidget(onChanged: search),

              Expanded(
                child: loading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (_, i) {
                          return SongTile(
                            song: filtered[i],
                            list: filtered,
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
import 'package:flutter/material.dart';
import '../storage/playlist_box.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  final box = PlaylistBox();
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final playlists = box.keys();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Playlists'),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: controller,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Create playlist',
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.black54,
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                box.create(controller.text);
                setState(() {});
                controller.clear();
              },
              child: const Text('Create'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: playlists.length,
                itemBuilder: (c, i) {
                  return ListTile(
                    title: Text(
                      playlists[i],
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
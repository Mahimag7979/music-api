import 'package:flutter/material.dart';

class Song {
  final String id;
  final String title;
  final String artist;
  final String url;
  final Color color;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.url,
    required this.color,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      artist: json['artist'] ?? '',
      url: json['url'] ?? '',
      color: Colors.primaries[
          int.parse(json['id'].toString()) % Colors.primaries.length],
    );
  }
}
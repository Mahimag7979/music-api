class Song {
  final String id;
  final String title;
  final String artist;
  final String url;
  final String image;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.url,
    required this.image,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      artist: json['artist'] ?? 'Unknown',
      url: json['url'] ?? '',
      image: json['image'] ?? '',
    );
  }
}
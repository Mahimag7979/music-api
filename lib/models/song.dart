class Song {
  final String id;
  final String title;
  final String artist;
  final String filePath;
  final String imageUrl;
  final String genre;

  const Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.filePath,
    required this.imageUrl,
    this.genre = 'trending',
  });

  factory Song.fromJson(Map<String, dynamic> j) => Song(
        id:       j['id'].toString(),
        title:    j['title']  ?? 'Unknown',
        artist:   j['artist'] ?? 'Unknown',
        filePath: j['url']    ?? '',
        imageUrl: j['image']  ?? '',
        genre:    j['genre']  ?? 'trending',
      );

  factory Song.fromSaavn(Map<String, dynamic> j) {
    // Get highest quality download URL
    final List downloadUrls = j['downloadUrl'] ?? [];
    String audioUrl = '';
    if (downloadUrls.isNotEmpty) {
      // Pick highest quality (last item = 320kbps)
      audioUrl = downloadUrls.last['url'] ?? '';
    }

    // Get image
    final List images = j['image'] ?? [];
    String imageUrl = '';
    if (images.isNotEmpty) {
      imageUrl = images.last['url'] ?? '';
    }

    // Get artist name
    final List artists = j['artists']?['primary'] ?? [];
    final artistName = artists.isNotEmpty
        ? artists.map((a) => a['name']).join(', ')
        : 'Unknown';

    return Song(
      id:       j['id']?.toString() ?? '',
      title:    j['name']  ?? 'Unknown',
      artist:   artistName,
      filePath: audioUrl,
      imageUrl: imageUrl,
      genre:    'trending',
    );
  }
}
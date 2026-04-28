import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class DownloadService {
  Future<String> download(String url, String id) async {
    final dir = await getApplicationDocumentsDirectory();
    final path = "${dir.path}/$id.mp3";

    await Dio().download(url, path);
    return path;
  }
}
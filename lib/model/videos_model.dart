import 'dart:convert';
import 'package:hls_video_player/constant/weburl.dart';
import 'package:hls_video_player/service/dio_service.dart';

class VideoModel {
  String? title;
  String? url;

  VideoModel(this.title, this.url);
  Uri getUrl() => Uri.parse(url ?? '');

  factory VideoModel.fromJson(Map<String, dynamic>? json) {
    return VideoModel(
      json?['title'],
      json?['url'],
    );
  }

  static Future<List<VideoModel>> getVideosData() async {
    List<VideoModel> list = [];
    var service = ServiceHttp();
    var data = await service.get(WebUrl.videoUrl);
    var json = jsonDecode(data);
    if (json is List) {
      list = json.map((element) => VideoModel.fromJson(element)).toList();
    }
    return list;
  }
}

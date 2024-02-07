import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:hls_video_player/model/videos_model.dart';
import 'package:hls_video_player/pages/video_player_page.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List<VideoModel> videosList = [];

  @override
  void initState() {
    videosList = VideoModel.getVideosData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('LSH Videos List')),
      ),
      body: ListView.builder(
        itemCount: videosList.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(top: 10),
            color: Colors.grey[100],
            child: ListTile(
              onTap: () {
                Get.to(() => const VideoPlayerPage(),
                    arguments: videosList[index]);
              },
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    videosList[index].title ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    videosList[index].url ?? '',
                    style: const TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

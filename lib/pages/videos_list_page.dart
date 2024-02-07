import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:hls_video_player/model/videos_model.dart';
import 'package:hls_video_player/pages/video_player_page.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class VideoListPage extends StatefulWidget {
  const VideoListPage({super.key});

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<VideoListPage> {
  List<VideoModel> videosList = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<List<VideoModel>> _loadData() async {
    if (!await InternetConnection().hasInternetAccess) {
      showSnackBar('No Internet Connection');
      return [];
    }
    return await VideoModel.getVideosData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'LSH Videos List',
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          IconButton(
            onPressed: () => setState(() {}),
            icon: const Icon(
              Icons.refresh,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: FutureBuilder(
        future: _loadData(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return snapshot.data.isEmpty
                ? const Center(
                    child: Text(
                    'No records found',
                    style: TextStyle(color: Colors.black),
                  ))
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 5),
                    itemCount: snapshot.data.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      VideoModel model = snapshot.data[index];
                      return Container(
                        margin: const EdgeInsets.only(top: 10),
                        color: Colors.grey[100],
                        child: ListTile(
                          onTap: () {
                            Get.to(() => const VideoPlayerPage(),
                                arguments: model);
                          },
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                model.title ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                model.url ?? '',
                                style: const TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
          }
        },
      ),
    );
  }

  void showSnackBar(String message) {
    final snackBar =
        SnackBar(content: Text(message), backgroundColor: Colors.red);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

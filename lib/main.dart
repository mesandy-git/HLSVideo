import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:hls_video_player/pages/videos_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HLS Video',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        primaryColor: Colors.black,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
        ),
        useMaterial3: true,
      ),
      home: const ListScreen(),
    );
  }
}

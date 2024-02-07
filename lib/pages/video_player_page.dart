import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:hls_video_player/model/videos_model.dart';
import 'package:hls_video_player/pages/control_overlay.dart';
import 'package:hls_video_player/parser/hls/vdo_player_hls_utils.dart';
import 'package:hls_video_player/parser/hls/hls_parser/vdo_player_asms_track.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage({super.key});

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  VdoPlayerAsmsTrack? _selectedTrack;
  late VideoPlayerController _controller;
  VideoModel videoModel = Get.arguments;
  List<VdoPlayerAsmsTrack> resolutions = [];
  bool _overlayVisibility = true;
  bool isPlaying = false;
  bool isPortrait = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    fullScreenExit(); // Force Portait

    _controller = VideoPlayerController.networkUrl(
      videoModel.getUrl(),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    )
      ..initialize().then(
        (_) async {
          setState(() {});
          stateChangeListner();
          extractResolutionsFromManifest(videoModel.url);
          resetTimer();
        },
      )
      ..setLooping(true)
      ..play();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (!isPortrait) {
          fullScreenExit();
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: !isPortrait
            ? null
            : AppBar(
                title: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    videoModel.title ?? '',
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
        body: OrientationBuilder(
          builder: (context, orientation) {
            isPortrait = orientation == Orientation.portrait;
            return Stack(
              //This will help to expand video in Horizontal mode till last pixel of screen
              fit: isPortrait ? StackFit.loose : StackFit.expand,
              children: [
                AspectRatio(
                  aspectRatio: _controller.value.isInitialized
                      ? _controller.value.aspectRatio
                      : 16 / 9,
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _overlayVisibility = !_overlayVisibility;
                          resetTimer();
                          setState(() {});
                        },
                        child: Container(
                          color: Colors.black,
                          child: VideoPlayer(_controller),
                        ),
                      ),
                      Visibility(
                        visible: _overlayVisibility,
                        child: GestureDetector(
                          onTap: () {
                            _overlayVisibility = !_overlayVisibility;
                            resetTimer();
                            setState(() {});
                          },
                          child: ControlsOverlay(
                            controller: _controller,
                            resolutions: resolutions,
                            selectedTrack: _selectedTrack,
                            onResolutionChange: (track) {
                              changeResolution(track);
                            },
                            resetTimer: resetTimer,
                            cancelTimer: cancelTimer,
                            fullscreen: fullScreen,
                            fullscreenExit: fullScreenExit,
                            isFullScreen: !isPortrait,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: VideoProgressIndicator(
                          _controller,
                          allowScrubbing: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  fullScreenExit() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    // Force to screen portraitUp
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  void fullScreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
  }

  // On Resolution Update
  Future<void> changeResolution(VdoPlayerAsmsTrack track) async {
    log('${track.variant?.url}  height - ${track.height} width - ${track.width}');
    late VideoPlayerController controller;
    _selectedTrack = track;
    controller = VideoPlayerController.networkUrl(track.variant!.url,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true))
      ..initialize().then(
        (_) async {
          Duration? position = await _controller.position;
          await controller.seekTo(position!);
          await _controller.pause();
          _controller.dispose();
          _controller = controller;
          setState(() {});
          stateChangeListner();
          resetTimer();
        },
      )
      ..setLooping(true)
      ..play();
  }

  Future<void> extractResolutionsFromManifest(url) async {
    // Download the HLS manifest file
    Response response = await Dio().get(url);
    var manifestContent = response.data;
    // Find Resolutions
    resolutions = await VdoPlayerHlsUtils.parseTracks(manifestContent, url);
    if (resolutions.isNotEmpty) {
      _selectedTrack = resolutions.first;
    }
  }

  stateChangeListner() {
    _controller.setVolume(1.0);
    _controller.addListener(() {
      log('Player State Change');
      setState(() {});
    });
  }

  resetTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 2500), (_) {
      setState(() {
        _overlayVisibility = false;
      });
    });
  }

  cancelTimer() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    cancelTimer();
    _controller.dispose();
    fullScreenExit();
    super.dispose();
  }
}

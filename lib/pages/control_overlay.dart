import 'package:flutter/material.dart';
import 'package:hls_video_player/parser/hls/hls_parser/vdo_player_asms_track.dart';
import 'package:hls_video_player/utils/Utils.dart';
import 'package:video_player/video_player.dart';

// ignore: must_be_immutable
class ControlsOverlay extends StatelessWidget {
  ControlsOverlay({
    super.key,
    required this.controller,
    required this.resolutions,
    this.selectedTrack,
    required this.onResolutionChange,
    required this.resetTimer,
    required this.cancelTimer,
    required this.fullscreen,
    required this.fullscreenExit,
    required this.isFullScreen,
  });
  bool isFullScreen = false;
  VdoPlayerAsmsTrack? selectedTrack;
  final void Function(VdoPlayerAsmsTrack track) onResolutionChange;
  final void Function() resetTimer, cancelTimer, fullscreen, fullscreenExit;
  VideoPlayerController controller;
  List<VdoPlayerAsmsTrack> resolutions = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Stack(
        children: <Widget>[
          Row(
            children: [
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTap: () async {
                      var pos = await controller.position;
                      await controller.seekTo(
                          Duration(seconds: (pos?.inSeconds ?? 0) - 10));
                      resetTimer();
                    },
                    child: Image.asset(
                      'assets/images/bacword_fast.png',
                      color: Colors.white,
                      width: 34.0,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTap: () async {
                      controller.value.isPlaying
                          ? await controller.pause()
                          : await controller.play();
                      resetTimer();
                    },
                    child: Icon(
                      controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: Colors.white,
                      size: 55.0,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 50),
                  reverseDuration: const Duration(milliseconds: 200),
                  child: Center(
                    child: GestureDetector(
                      onTap: () async {
                        var pos = await controller.position;
                        await controller.seekTo(
                            Duration(seconds: (pos?.inSeconds ?? 0) + 10));
                        resetTimer();
                      },
                      child: Image.asset(
                        'assets/images/forword_fast.png',
                        color: Colors.white,
                        width: 34.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.topRight,
            child: PopupMenuButton<double>(
              onOpened: cancelTimer,
              initialValue: controller.value.playbackSpeed,
              onSelected: (double speed) async {
                await controller.setPlaybackSpeed(speed);
                resetTimer();
              },
              itemBuilder: (BuildContext context) {
                return <PopupMenuItem<double>>[
                  for (final double speed in Utils.playbackRates)
                    PopupMenuItem<double>(
                      value: speed,
                      child: Text('${speed}x'),
                    )
                ];
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(2),
                ),
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 8,
                ),
                child: Text(
                  '${controller.value.playbackSpeed}x',
                  textScaleFactor: 0.9,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 58),
            alignment: Alignment.bottomRight,
            child: PopupMenuButton<VdoPlayerAsmsTrack>(
              initialValue: selectedTrack,
              onOpened: cancelTimer,
              onSelected: (VdoPlayerAsmsTrack track) {
                onResolutionChange(track);
              },
              itemBuilder: (BuildContext context) {
                return <PopupMenuItem<VdoPlayerAsmsTrack>>[
                  for (VdoPlayerAsmsTrack track in resolutions)
                    PopupMenuItem<VdoPlayerAsmsTrack>(
                      value: track,
                      child: Text(
                        track.height == 0 ? 'Auto' : '${track.height}p',
                      ),
                    )
                ];
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(2),
                ),
                margin: const EdgeInsets.all(8),
                child: const Icon(
                  Icons.hd,
                  size: 30,
                  color: Colors.white70,
                ),
              ),
            ),
          ),
          Positioned(
            left: 10,
            bottom: 10,
            child: Text(
              '${Utils.formattedTime(controller.value.position)}/${Utils.formattedTime(controller.value.duration)}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            right: 14,
            bottom: 6,
            child: InkWell(
              onTap: isFullScreen ? fullscreenExit : fullscreen,
              child: Icon(
                size: 34,
                color: Colors.white70,
                !isFullScreen ? Icons.fullscreen : Icons.fullscreen_exit,
              ),
            ),
          ),
          Visibility(
            visible: controller.value.isBuffering,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}

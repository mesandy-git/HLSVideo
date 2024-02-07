import 'package:hls_video_player/parser/hls/hls_parser/variant.dart';

/// Represents HLS / DASH track which can be played within player
class VdoPlayerAsmsTrack {
  ///Id of the track
  final String? id;

  ///Width in px of the track
  final int? width;

  ///Height in px of the track
  final int? height;

  ///Bitrate in px of the track
  final int? bitrate;

  ///Frame rate of the track
  final int? frameRate;

  final Variant? variant;

  VdoPlayerAsmsTrack(this.id, this.width, this.height, this.bitrate,
      this.frameRate, this.variant);

  factory VdoPlayerAsmsTrack.defaultTrack() {
    return VdoPlayerAsmsTrack('', 0, 0, 0, 0, null);
  }

  @override
  // ignore: unnecessary_overrides
  int get hashCode => super.hashCode;

  @override
  bool operator ==(dynamic other) {
    return other is VdoPlayerAsmsTrack &&
        width == other.width &&
        height == other.height &&
        bitrate == other.bitrate &&
        frameRate == other.frameRate &&
        variant == other.variant;
  }
}

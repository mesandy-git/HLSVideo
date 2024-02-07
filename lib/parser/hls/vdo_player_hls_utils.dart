import 'dart:developer';
import 'package:hls_video_player/parser/hls/hls_parser/format.dart';
import 'package:hls_video_player/parser/hls/hls_parser/variant.dart';
import 'package:hls_video_player/parser/hls/hls_parser/vdo_player_asms_track.dart';
import 'package:hls_video_player/parser/hls/hls_parser/hls_master_playlist.dart';
import 'package:hls_video_player/parser/hls/hls_parser/hls_playlist_parser.dart';

class VdoPlayerHlsUtils {
  static Future<List<VdoPlayerAsmsTrack>> parseTracks(
      String data, String masterPlaylistUrl) async {
    final List<VdoPlayerAsmsTrack> tracks = [];
    tracks.add(
      VdoPlayerAsmsTrack(
        'Auto',
        0,
        0,
        0,
        0,
        Variant(
          url: Uri.parse(masterPlaylistUrl),
          format: Format(),
          videoGroupId: '',
          audioGroupId: '',
          subtitleGroupId: '',
          captionGroupId: '',
        ),
      ), // Added default to manage auto
    );
    try {
      final parsedPlaylist = await HlsPlaylistParser.create()
          .parseString(Uri.parse(masterPlaylistUrl), data);
      if (parsedPlaylist is HlsMasterPlaylist) {
        for (var variant in parsedPlaylist.variants) {
          if (variant.format.height != null) {
            tracks.add(
              VdoPlayerAsmsTrack(
                variant.format.id,
                variant.format.width,
                variant.format.height,
                variant.format.bitrate,
                0,
                variant,
              ),
            );
          }
        }
      }
    } catch (exception) {
      log("Exception on parseSubtitles: $exception");
    }
    tracks.sort((val1, val2) {
      return (val1.width ?? 0).compareTo(val2.width ?? 0);
    });
    return tracks;
  }
}

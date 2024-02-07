class VideoModel {
  String? title;
  String? url;

  VideoModel(this.title, this.url);

  Uri getUrl() => Uri.parse(url ?? '');

  static List<VideoModel> getVideosData() {
    var list = [
      VideoModel('Skate Phantom Flex 4k',
          'http://sample.vodobox.net/skate_phantom_flex_4k/skate_phantom_flex_4k.m3u8'),
      VideoModel('Big Buck Bunny',
          'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8'),
      VideoModel('Tears of Steel',
          'https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8'),
      VideoModel('Image Bipbop Adv',
          'https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/master.m3u8'),
      VideoModel('Big Buck Bunny Clip Live',
          'https://live-par-2-cdn-alt.livepush.io/live/bigbuckbunnyclip/index.m3u8'),
      VideoModel('Tears of Steel 2',
          'http://content.jwplatform.com/manifests/vM7nH0Kl.m3u8'),
      VideoModel('Sintel Trailer',
          'http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8'),
      VideoModel('Sample',
          'https://diceyk6a7voy4.cloudfront.net/e78752a1-2e83-43fa-85ae-3d508be29366/hls/fitfest-sample-1_Ott_Hls_Ts_Avc_Aac_16x9_1280x720p_30Hz_6.0Mbps_qvbr.m3u8'),
    ];
    return list;
  }
}

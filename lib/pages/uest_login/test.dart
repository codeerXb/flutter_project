import 'package:flutter/material.dart';
import 'package:flutter_template/pages/uest_login/video.dart';

// import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
//视频测试
class VideoTest extends StatefulWidget {
  const VideoTest({super.key});

  @override
  State<VideoTest> createState() => _VideoTestState();
}

class _VideoTestState extends State<VideoTest> {
  @override
  Widget build(BuildContext context) {
    return const SimpleVideoPage();
  }
}



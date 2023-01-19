import 'dart:convert';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:fijkplayer_skin/fijkplayer_skin.dart';
import 'package:fijkplayer_skin/schema.dart' show VideoSourceFormat;
import 'package:flutter/material.dart';

// show 表示只导出 VideoSourceFormat 类
class SimpleVideoPage extends StatefulWidget {
  const SimpleVideoPage({Key? key}) : super(key: key);

  @override
  _SimpleVideoPageState createState() => _SimpleVideoPageState();
}

String videoUrl = '';

class _SimpleVideoPageState extends State<SimpleVideoPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: VideoDetailPage(),
      ),
    );
  }
}

//定制UI配置项
class PlayerShowConfig implements ShowConfigAbs {
  //自动播放下一个视频
  @override
  bool autoNext = false;
  //底部进度条
  @override
  bool bottomPro = true;
  //剧集显示
  @override
  bool drawerBtn = true;
  //进入页面自动播放
  @override
  bool isAutoPlay = false;
  //是否有锁
  @override
  bool lockBtn = true;
  //下一个按钮
  @override
  bool nextBtn = false;
  //显示封面 但是貌似没有效果
  bool showCover = false;
  //播放速度 1.0倍 2.0倍
  @override
  bool speedBtn = true;
  @override
  bool stateAuto = true;
  //顶部标题栏
  @override
  bool topBar = true;
}

class VideoDetailPage extends StatefulWidget {
  const VideoDetailPage({Key? key}) : super(key: key);

  @override
  _VideoDetailPageState createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage>
    with SingleTickerProviderStateMixin {
  final FijkPlayer player = FijkPlayer();

  getVideo() async {
    Dio dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback = (cert, host, port) {
        return true; // 返回true强制通过
      };
      return null;
    };
    var res = await dio.get(
        'http://ccapi.smawave.com:18080/api/play/start/31011300001188000006/31011300001328000501');
    setState(() {
      videoUrl = json.decode(res.toString())['data']['rtsp'];
      videoList = {
        "video": [
          {
            "name": "线路资源一",
            "list": [
              {"url": videoUrl, "name": "视频名称"},
            ]
          }
        ]
      };
    });
  }

  Map<String, List<Map<String, dynamic>>> videoList = {
    "video": [
      {
        "name": "线路资源一",
        "list": [
          {"url": videoUrl, "name": "视频名称"},
        ]
      }
    ]
  };

  VideoSourceFormat? _videoSourceTabs;
  final int _currTabIndex = 0;
  final int _currActiveIdx = 0;
  ShowConfigAbs vConfig = PlayerShowConfig();

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getVideo();
    _videoSourceTabs = VideoSourceFormat.fromJson(videoList);
    //这句不能省，必须有
    speed = 1.0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FijkView(
          height: 260,
          color: Colors.black,
          fit: FijkFit.cover,
          player: player,
          panelBuilder: (FijkPlayer player, FijkData data, BuildContext context,
              Size viewSize, Rect texturePos) {
            return CustomFijkPanel(
                player: player,
                viewSize: viewSize,
                texturePos: texturePos,
                pageContent: context,
                //标题 当前页面顶部的标题部分
                // playerTitle: '顶部视频标题',
                //视频显示的配置
                showConfig: vConfig,
                //json格式化后的视频数据
                videoFormat: _videoSourceTabs,
                //当前视频源 资源一 资源二等
                curTabIdx: _currTabIndex,
                //当前视频 高清 标清 流畅等
                curActiveIdx: _currActiveIdx);
          },
        )
      ],
    );
  }
}

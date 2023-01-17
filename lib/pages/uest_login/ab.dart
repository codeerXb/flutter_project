import 'dart:convert';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:fijkplayer_skin/fijkplayer_skin.dart';
import 'package:flutter/material.dart';
import 'package:fijkplayer_skin/schema.dart';

//相对比较复杂的视频页面
class ComplexVideoPage extends StatefulWidget {
  const ComplexVideoPage({Key? key}) : super(key: key);
  @override
  _ComplexVideoPageState createState() => _ComplexVideoPageState();
}

String videoUrl = '';

class _ComplexVideoPageState extends State<ComplexVideoPage> {
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
      videoUrl = json.decode(res.toString())['data']['hls'];
    });
  }

  @override
  void initState() {
    super.initState();
    getVideo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: VideoDetailPage(),
      ),
    );
  }
}

class VideoDetailPage extends StatefulWidget {
  @override
  _VideoDetailPageState createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage>
    with TickerProviderStateMixin {
  final FijkPlayer player = FijkPlayer();
  Map<String, List<Map<String, dynamic>>> videoList = {
    "video": [
      {
        "name": "天空资源",
        "list": [
          {
            "url": videoUrl,
            "name": "锤子UI-1",
          },
        ]
      },
    ]
  };

  VideoSourceFormat? _videoSourceTabs;
  late TabController _controller;

  int _currTabIndex = 0;
  int _currActiveIdx = 0;

  ShowConfigAbs vConfig = PlayerShowConfig();

  @override
  void dispose() {
    player.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    //格式化json对象
    print(videoUrl);
    print(333);
    // videoList['video']![0]['list'][0]['url'] = widget.videoUrl.toString();
    _videoSourceTabs = VideoSourceFormat.fromJson(videoList);
    //初始化TabController
    _controller = TabController(
        length: _videoSourceTabs!.video!.length, //length 表示几个视频来源 比如 百度云 迅雷加速
        vsync: this); //每个资源包含了具体的剧集内容 name和url
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
                playerTitle: '标题',
                showConfig: vConfig,
                videoFormat: _videoSourceTabs,
                curTabIdx: _currTabIndex,
                curActiveIdx: _currActiveIdx);
          },
        ),
        Container(
          height: 300,
          child: buildPlayDrawer(),
        ),
        Container(
          child: Text(
              "当前 ${_currTabIndex.toString()} 当前 activeIndex ${_currActiveIdx.toString()}"),
        ),
      ],
    );
  }

  //build 剧集
  buildPlayDrawer() {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(24),
        child: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          primary: false,
          elevation: 0,
          title: TabBar(
            tabs: _videoSourceTabs!.video!
                .map((e) => Tab(
                      text: e!.name!,
                    ))
                .toList(),
            isScrollable: true,
            controller: _controller,
          ),
        ),
      ),
      body: Container(
        color: Colors.black87,
        child: TabBarView(
          controller: _controller,
          children: createTabContentList(),
        ),
      ),
    );
  }

  createTabContentList() {
    List<Widget> list = []; //Page
    _videoSourceTabs!.video!.asMap().keys.forEach((int tabIndex) {
      //资源
      List<Widget> playListButtons = _videoSourceTabs!.video![tabIndex]!.list!
          .asMap()
          .keys
          .map((int activeIndex) {
        //剧集
        return Padding(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: ElevatedButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5))),
                elevation: MaterialStateProperty.all(0),
                backgroundColor: MaterialStateProperty.all(
                    tabIndex == _currTabIndex && activeIndex == _currActiveIdx
                        ? Colors.red //选中是红色的
                        : Colors.blue)),
            onPressed: () async {
              setState(() {
                _currTabIndex = tabIndex;
                _currActiveIdx = activeIndex;
              });
              String nextVideoUrl =
                  _videoSourceTabs!.video![tabIndex]!.list![activeIndex]!.url!;
              //切换资源
              //如果不是自动开始播放，那么先执行 stop
              if (player.value.state == FijkState.completed) {
                await player.stop();
              }
              await player.reset().then((_) async {
                player.setDataSource(nextVideoUrl, autoPlay: true);
              });
            },
            child: Text(
              _videoSourceTabs!.video![tabIndex]!.list![activeIndex]!.name!,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      }).toList();
      list.add(SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: Wrap(
            direction: Axis.horizontal,
            children: playListButtons,
          ),
        ),
      ));
    });
    return list;
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
  @override
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

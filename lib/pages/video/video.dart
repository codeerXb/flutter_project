import 'dart:async';
import 'dart:convert';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:fijkplayer_skin/fijkplayer_skin.dart';
import 'package:fijkplayer_skin/schema.dart' show VideoSourceFormat;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/widget/custom_app_bar.dart';
import 'package:get/get.dart';

import '../../generated/l10n.dart';

// show 表示只导出 VideoSourceFormat 类
class SimpleVideoPage extends StatefulWidget {
  const SimpleVideoPage({Key? key}) : super(key: key);

  @override
  State<SimpleVideoPage> createState() => _SimpleVideoPageState();
}

String videoUrl = '';

class _SimpleVideoPageState extends State<SimpleVideoPage> {
  late Timer? _timer;
  @override
  void initState() {
    super.initState();
    getImg();
    _timer = Timer.periodic(const Duration(milliseconds: 3000), (timer) {
      if (mounted) getImg();
    });
  }

  @override
  void dispose() {
    super.dispose();
    // 组件销毁时判断Timer是否仍然处于激活状态，是则取消
    _timer?.cancel();
    _timer = null;
  }

  List imgList = [];
  getImg() async {
    Dio dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback = (cert, host, port) {
        return true; // 返回true强制通过
      };
      return null;
    };
    try {
      var res = await dio.get(
          'http://10.0.40.118:8080/scps_plat/smawave/ai_history/query?channelid=34020000001320000211');
      if (mounted) {
        setState(() {
          if (imgList.toString() !=
              json.decode(res.toString())['data']['list'].toString()) {
            imgList = json.decode(res.toString())['data']['list'];
          }
        });
      }
      printInfo(info: '视频截图数据 ${json.decode(res.toString())}');
    } on DioError catch (err) {
      printError(info: err.toString());
    }
  }

  List imgs = List.generate(15, ((index) {
    return index;
  }));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
          child: const SafeArea(
            top: true,
            child: Offstage(),
          ),
        ),
        body: Column(children: [
          const SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: VideoDetailPage(),
          ),
          Padding(padding: EdgeInsets.only(bottom: 30.w)),
          Expanded(
            //解决column里面放其它布局和listview。listview不显示的问题。expanded flex=1.自适应高度
            flex: 1,
            child: imgList.isNotEmpty
                ? ListView(children: [
                    ...imgList.map((e) {
                      return Card(
                        elevation: 5, //设置卡片阴影的深度

                        margin: EdgeInsets.only(
                            left: 20.w, right: 20.w, bottom: 10.w), //设置卡片外边距
                        child: Column(
                          children: [
                            ListTile(
                              leading: Image.network(
                                  'http://172.16.110.1:8080/scps_plat/profile/ai/2023/1/14/5c731284d38e43dc98bd58676002d552.jpg',
                                  fit: BoxFit.fitWidth,
                                  height: 80,
                                  width: 80),
                              title: Text(e['warnStatusName'].toString()),
                              subtitle: Text(
                                e['createTime'].toString(),
                                style: TextStyle(fontSize: 20.sp),
                              ),
                              trailing: TextButton(
                                onPressed: () {
                                  Get.toNamed('/img', arguments: [
                                    {
                                      "url":
                                          'http://172.16.110.1:8080/scps_plat/profile/ai/2023/1/14/5c731284d38e43dc98bd58676002d552.jpg'
                                    }
                                  ]);
                                },
                                child:  Text(S.current.examine),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ])
                :  Center(
                    child: Text(S.current.noData),
                  ),
          ),
        ]));
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
  bool topBar = false;
}

class VideoDetailPage extends StatefulWidget {
  const VideoDetailPage({Key? key}) : super(key: key);

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
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
    try {
      var res = await dio.get(
          'http://ccapi.smawave.com:18080/api/play/start/34020000001110000001/34020000001320000211');
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
        _videoSourceTabs = VideoSourceFormat.fromJson(videoList);
        printInfo(info: '视频队列信息${videoList.toString()}');
      });
    } on DioError catch (e) {
      printError(info: '播放视频错误${e.toString()}');
    }
  }

  Map<String, List<Map<String, dynamic>>> videoList = {
    "video": [
      {"name": "线路资源一", "list": []}
    ]
  };

  VideoSourceFormat? _videoSourceTabs;
  final int _currTabIndex = 0;
  final int _currActiveIdx = 0;
  ShowConfigAbs vConfig = PlayerShowConfig();

  @override
  void dispose() {
    player.release();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getVideo();
    setState(() {
      _videoSourceTabs = VideoSourceFormat.fromJson(videoList);
    });
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

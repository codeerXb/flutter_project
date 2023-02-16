import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../core/utils/shared_preferences_util.dart';
import '../../core/widget/common_widget.dart';
import '../../core/widget/custom_app_bar.dart';
import '../../generated/l10n.dart';

/// 订阅服务
class SubSerivce extends StatefulWidget {
  const SubSerivce({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SubSerivceState();
}

class _SubSerivceState extends State<SubSerivce> {
  String type = '暂未订阅';
  @override
  void initState() {
    super.initState();
    //读取存储的订阅选项
    sharedGetData('parental_control', int).then(((res) {
      if (res != null) {
        setState(() {
          switch (int.parse(res.toString())) {
            case 1:
              type = '连续包年';
              break;
            case 2:
              type = '连续包季';
              break;
            case 3:
              type = '连续包月';
              break;
          }
        });
      }
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppbar(context: context, title: S.of(context).subService),
        body: Container(
          decoration:
              const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
          height: 1400.w,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Padding(padding: EdgeInsets.only(top: 30.w)),
                TitleWidger(title: S.of(context).subService),
                Card(
                  elevation: 5, //设置卡片阴影的深度
                  shape: const RoundedRectangleBorder(
                    //设置卡片圆角
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  margin: EdgeInsets.only(
                      left: 26.w, right: 26.w, bottom: 26.w), //设置卡片外边距
                  child: Column(
                    children: [
                      //家长控制
                      ListTile(
                        leading: ClipOval(
                          child: Image.network(
                            "https://img1.baidu.com/it/u=3844424264,2786123313&fm=253&fmt=auto&app=138&f=JPEG?w=256&h=256",
                            height: 50,
                            width: 50,
                          ),
                        ),
                        title: Text(S.of(context).parentalControl),
                        subtitle: Text('套餐类型'+ "-$type"),
                        trailing: Icon(Icons.arrow_forward_ios),
                        enabled: true,
                        onTap: () => Get.toNamed("/parcontrol_info"),
                      ),
                      commonLine(),
                      //游戏加速
                      ListTile(
                        leading: ClipOval(
                          child: Image.network(
                              "https://img0.baidu.com/it/u=1731282158,1336459636&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=501",
                              height: 50,
                              width: 50),
                        ),
                        title: Text(S.of(context).gameAcceleration),
                        subtitle: Text(S.of(context).gameAcceleration + "-未开启"),
                        trailing: Icon(Icons.arrow_forward_ios),
                        enabled: true,
                        onTap: () => Get.toNamed("/gameacce_inofo"),
                      ),
                      commonLine(),
                      //ai视频
                      ListTile(
                        leading: ClipOval(
                          child: Image.network(
                              "https://img0.baidu.com/it/u=2731303767,1175207941&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500",
                              height: 50,
                              width: 50),
                        ),
                        title: Text(S.of(context).aivideo),
                        subtitle: Text(S.of(context).aivideo + "-未开启"),
                        trailing: Icon(Icons.arrow_forward_ios),
                        enabled: true,
                        onTap: () => Get.toNamed("/ai_video"),
                      ),
                    ],
                  ),
                ),
                Card(
                  elevation: 5, //设置卡片阴影的深度
                  shape: const RoundedRectangleBorder(
                    //设置卡片圆角
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  margin: EdgeInsets.only(
                      left: 26.w, right: 26.w, bottom: 26.w), //设置卡片外边距
                  child: Column(
                    children: [],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

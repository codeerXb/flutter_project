import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
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
                //家长控制
                TitleWidger(title: S.of(context).parentalControl),

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
                      ListTile(
                        leading: ClipOval(
                          child: Image.network(
                              "https://img.zcool.cn/community/019b3559c38839a801218e18c0143d.jpg@1280w_1l_2o_100sh.jpg",
                              height: 50,
                              width: 50),
                        ),
                        title: Text("家长控制"),
                        subtitle: Text("家长控制-12345678"),
                        trailing: Icon(Icons.arrow_forward_ios),
                        enabled: true,
                        onTap: () => Get.toNamed("/parcontrol_info"),
                      ),
                    ],
                  ),
                ),

                //游戏加速
                TitleWidger(title: S.of(context).gameAcceleration),
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
                      ListTile(
                        leading: ClipOval(
                          child: Image.network(
                              "https://img0.baidu.com/it/u=1731282158,1336459636&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=501",
                              height: 50,
                              width: 50),
                        ),
                        title: Text("游戏加速"),
                        subtitle: Text("游戏加速-12345678"),
                        trailing: Icon(Icons.arrow_forward_ios),
                        enabled: true,
                        onTap: () => Get.toNamed("/gameacce_inofo"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

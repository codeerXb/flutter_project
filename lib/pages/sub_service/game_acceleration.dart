import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import '../../core/widget/custom_app_bar.dart';
import '../../generated/l10n.dart';

/// 游戏加速
class Gameacce extends StatefulWidget {
  const Gameacce({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GameacceState();
}

class _GameacceState extends State<Gameacce> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppbar(
            context: context, title: S.of(context).gameAcceleration),
        body: Container(
          decoration:
              const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
          height: 1400.w,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                            width: 50,
                          ),
                        ),
                        title: Text(S.of(context).gameAcceleration),
                        subtitle: Text("剩余1个月"),
                        trailing: Text("￥9.99"),
                      ),
                    ],
                  ),
                ),
                //选项
                TitleWidger(title: S.of(context).options),

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
                        title: Text('1个月-￥9.99'),
                        trailing: Icon(
                          Icons.check,
                          color: index == 1 ? Colors.black : Colors.white,
                        ),
                        onTap: () {
                          setState(() {
                            index = 1;
                          });
                        },
                      ),
                     commonLine(),
                      ListTile(
                        title: Text('2个月-￥19.88'),
                        trailing: Icon(
                          Icons.check,
                          color: index == 2 ? Colors.black : Colors.white,
                        ),
                        onTap: () {
                          setState(() {
                            index = 2;
                          });
                        },
                      ),
                      commonLine(),
                      ListTile(
                        title: Text('3个月-￥28.88'),
                        trailing: Icon(
                          Icons.check,
                          color: index == 3 ? Colors.black : Colors.white,
                        ),
                        onTap: () {
                          setState(() {
                            index = 3;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 10.w),
                  child: Center(
                    child: SizedBox(
                      height: 70.sp,
                      width: 680.sp,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color.fromARGB(255, 48, 118, 250))),
                        onPressed: () {
                          print(index);
                        },
                        child: Text(
                          "订阅",
                          style: TextStyle(fontSize: 30.sp),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

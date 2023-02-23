import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/widget/custom_app_bar.dart';

/// DNS设置
class Vidicon extends StatefulWidget {
  const Vidicon({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _VidiconState();
}

class _VidiconState extends State<Vidicon> {
  @override
  void initState() {
    super.initState();
    // getDnsData();
  }

  // 点击空白  关闭键盘 时传的一个对象
  FocusNode blankNode = FocusNode();

  /// 点击空白  关闭输入键盘
  void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(blankNode);
  }

  // void getDnsData() async {
  //   Map<String, dynamic> data = {
  //     'method': 'obj_get',
  //     'param': '["lteManualDns1","lteManualDns2"]',
  //   };
  //   try {
  //     var response = await XHttp.get('/data.html', data);
  //     var d = json.decode(response.toString());
  //   } catch (e) {
  //     debugPrint('获取DSN 失败：$e.toString()');
  //     ToastUtils.toast(S.current.error);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppbar(context: context, title: '摄像机'),
        body: SingleChildScrollView(
          child: InkWell(
            onTap: () => closeKeyboard(context),
            child: Container(
              decoration:
                  const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
              height: 1400.w,
              child: Column(
                children: [
                  const Image(
                    image: AssetImage('assets/images/videocan.png'),
                    width: 390,
                    height: 350,
                  ),
                  Padding(padding: EdgeInsets.only(top: 20.sp)),
                  InfoBox(
                    boxCotainer: SizedBox(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Get.toNamed("/look_house");
                        },
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                          const CircleBorder()),
                                    ),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Icon(Icons.notifications,
                                              color: Colors.white)
                                        ]),
                                  ),
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('看家',
                                            style: TextStyle(fontSize: 30.sp)),
                                        Text('拍摄到的重要事件 ',
                                            style: TextStyle(
                                                fontSize: 24.sp,
                                                color: const Color.fromRGBO(
                                                    144, 147, 153, 1))),
                                      ]),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    color:
                                        const Color.fromRGBO(144, 147, 153, 1),
                                    size: 30.w,
                                  )
                                ],
                              ),
                            ]),
                      ),
                    ),
                  ),
                  InfoBox(
                    boxCotainer: SizedBox(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Get.toNamed("/look_back");
                        },
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                          const CircleBorder()),
                                    ),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Icon(Icons.play_circle_filled,
                                              color: Colors.white)
                                        ]),
                                  ),
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('回看',
                                            style: TextStyle(fontSize: 30.sp)),
                                        Text('查看历史监测记录 ',
                                            style: TextStyle(
                                                fontSize: 24.sp,
                                                color: const Color.fromRGBO(
                                                    144, 147, 153, 1))),
                                      ]),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    color:
                                        const Color.fromRGBO(144, 147, 153, 1),
                                    size: 30.w,
                                  )
                                ],
                              ),
                            ]),
                      ),
                    ),
                  ),
                  InfoBox(
                    boxCotainer: SizedBox(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Get.toNamed("/storage_administration");
                        },
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                          const CircleBorder()),
                                    ),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Icon(Icons.sd_card,
                                              color: Colors.white)
                                        ]),
                                  ),
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('存储管理',
                                            style: TextStyle(fontSize: 30.sp)),
                                        Text('云存、SD卡和本地 ',
                                            style: TextStyle(
                                                fontSize: 24.sp,
                                                color: const Color.fromRGBO(
                                                    144, 147, 153, 1))),
                                      ]),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    color:
                                        const Color.fromRGBO(144, 147, 153, 1),
                                    size: 30.w,
                                  )
                                ],
                              ),
                            ]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class InfoBox extends StatelessWidget {
  final Widget boxCotainer;
  const InfoBox({super.key, required this.boxCotainer});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(28.0.w),
        margin: EdgeInsets.only(bottom: 20.w, left: 30.w, right: 30.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.w),
        ),
        child: boxCotainer);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/pages/toolbar/toolbar_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

/// 消息页面
class NetStatus extends StatefulWidget {
  const NetStatus(this.service, {Key? key}) : super(key: key);
  final String service;
  @override
  State<StatefulWidget> createState() => _NetStatusState();
}

class _NetStatusState extends State<NetStatus> {
  // 点击空白  关闭键盘 时传的一个对象
  FocusNode blankNode = FocusNode();

  /// 点击空白  关闭输入键盘
  void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(blankNode);
  }

  final ToolbarController toolbarController = Get.put(ToolbarController());
  String get vn => widget.service;
  // 下拉列表
  bool isShowList = false;
  List<Map<String, dynamic>> get serviceList => [
        {
          'label': widget.service,
          'sn': '12123213',
        },
        {
          'label': 'test',
          'sn': '12123213',
        }
      ];

// 下拉列表
  Widget buildGrid() {
    List<Widget> tiles = []; //先建一个数组用于存放循环生成的widget
    Widget content; //单独一个widget组件，用于返回需要生成的内容widget
    for (var item in serviceList) {
      tiles.add(Container(
        padding: EdgeInsets.only(left: 20.w, top: 20.w, bottom: 20.w),
        child: InkWell(
          onTap: () {},
          child: Row(children: <Widget>[
            if (item['label'] == vn)
              Padding(
                padding: EdgeInsets.only(right: 16.sp),
                child: FaIcon(
                  FontAwesomeIcons.chevronRight,
                  size: 30.w,
                  color: Colors.white,
                ),
              ),
            Text(
              item['label'],
              style: TextStyle(color: Colors.white, fontSize: 30.sp),
            ),
          ]),
        ),
      ));
    }
    content = Container(
      color: const Color.fromARGB(153, 31, 31, 31),
      width: 1.sw,
      child: Column(
          children: tiles //重点在这里，因为用编辑器写Column生成的children后面会跟一个<Widget>[]，
          //此时如果我们直接把生成的tiles放在<Widget>[]中是会报一个类型不匹配的错误，把<Widget>[]删了就可以了
          ),
    );
    return content;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              alignment: Alignment.topCenter,
              image: AssetImage(
                'assets/images/picture_home.png',
              ),
              fit: BoxFit.fitWidth)),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: InkWell(
            overlayColor: const MaterialStatePropertyAll(Colors.transparent),
            onTap: () {
              setState(() {
                isShowList = !isShowList;
              });
            },
            //下拉icon
            child: SizedBox(
              width: 1.sw,
              child: Row(
                children: [
                  Text(vn),
                  FaIcon(
                    FontAwesomeIcons.chevronDown,
                    size: 30.w,
                  )
                ],
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          onTap: () => closeKeyboard(context),
          behavior: HitTestBehavior.opaque,
          child: Container(
            decoration:
                const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
            height: 1000,
            child: Stack(
              children: [
                // 头部下拉widget
                Container(
                  width: 1.sw,
                  height: 200.h,
                  color: Colors.transparent,
                ),
                // if (isShowList) Positioned(top: 10.w, child: buildGrid()),

                Padding(
                  padding: EdgeInsets.only(top: 10.w),
                  child: ListView(
                    children: [
                      // //热力图
                      Container(
                        height: 600.w,
                        margin: EdgeInsets.only(
                            bottom: 20.w, left: 30.w, right: 30.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18.w),
                        ),
                        child: Image.asset(
                          'assets/images/state.png',
                        ),
                      ),
                      //网络环境
                      WhiteCard(
                          boxCotainer: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            '已连接',
                            style: TextStyle(
                                fontSize: 30.sp,
                                color: const Color(0xff051220)),
                          ),
                          Column(
                            children: [
                              Text(
                                '优',
                                style: TextStyle(
                                    fontSize: 30.sp, color: Colors.blue),
                              ),
                              Text(
                                '网络环境',
                                style: TextStyle(
                                    fontSize: 30.sp, color: Colors.blue),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  const CircleBorder()),
                            ),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.rocket,
                                    size: 32,
                                  )
                                ]),
                          )
                        ],
                      )),
                      //流量套餐
                      WhiteCard(
                          boxCotainer: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                '0.4  MB',
                                style: TextStyle(
                                    fontSize: 30.sp,
                                    color: const Color(0xff051220)),
                              ),
                              Text(
                                '已经使用',
                                style: TextStyle(
                                  fontSize: 28.sp,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  const CircleBorder()),
                            ),
                            onPressed: () {},
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text('套餐'),
                                  Text('设置'),
                                ]),
                          ),
                          Column(
                            children: [
                              Text(
                                '5 GB/月',
                                style: TextStyle(
                                    fontSize: 30.sp,
                                    color: const Color(0xff051220)),
                              ),
                              Text(
                                '流量套餐',
                                style: TextStyle(
                                  fontSize: 28.sp,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                      //下载速率
                      WhiteCard(
                          boxCotainer: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                '0.4Kbps',
                                style: TextStyle(
                                    fontSize: 30.sp,
                                    color: const Color(0xff051220)),
                              ),
                              Text(
                                '下载速率',
                                style: TextStyle(
                                  fontSize: 28.sp,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  const CircleBorder()),
                            ),
                            onPressed: () {},
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.wifi_outlined,
                                    size: 32,
                                  )
                                ]),
                          ),
                          Column(
                            children: [
                              Text(
                                '5 GB/月',
                                style: TextStyle(
                                    fontSize: 30.sp,
                                    color: const Color(0xff051220)),
                              ),
                              Text(
                                '流量套餐',
                                style: TextStyle(
                                  fontSize: 28.sp,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                      //2*3网格
                      SizedBox(
                        height: 550.w,
                        child: GridView(
                          physics: const NeverScrollableScrollPhysics(), //禁止滚动
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, //一行的Widget数量
                                  childAspectRatio: 2 //宽高比为1
                                  ),
                          children: <Widget>[
                            //接入设备
                            WhiteCard(
                                boxCotainer: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Icons.devices_other_rounded,
                                    color: Colors.blue[500], size: 80.sp),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text('接入设备'),
                                    Text(
                                      '1个在线 ',
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 25.sp),
                                    ),
                                  ],
                                )
                              ],
                            )),

                            //儿童上网
                            WhiteCard(
                                boxCotainer: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Icons.child_care,
                                    color: Colors.blue[500], size: 80.sp),
                                const Text('儿童上网'),
                              ],
                            )),
                            //摄像头
                            WhiteCard(
                                boxCotainer: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Icons.camera_alt,
                                    color: Colors.blue[500], size: 80.sp),
                                const Text('摄像头'),
                              ],
                            )),
                            //网络测速
                            WhiteCard(
                                boxCotainer: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Icons.network_check,
                                    color: Colors.blue[500], size: 80.sp),
                                const Text('网络测速'),
                              ],
                            )),
                            //网课加速
                            WhiteCard(
                                boxCotainer: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Icons.book,
                                    color: Colors.blue[500], size: 80.sp),
                                const Text('网课加速'),
                              ],
                            )),
                            //游戏加速
                            WhiteCard(
                                boxCotainer: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Icons.speed,
                                    color: Colors.blue[500], size: 80.sp),
                                const Text('游戏加速'),
                              ],
                            )),
                          ],
                        ),
                      ),
                      //查看更多
                      TextButton(
                          onPressed: () {
                            toolbarController.setPageIndex(2);
                          },
                          child: const Text('查看更多'))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//card
class WhiteCard extends StatelessWidget {
  final Widget boxCotainer;
  const WhiteCard({super.key, required this.boxCotainer});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.w,
      padding: EdgeInsets.all(28.0.w),
      margin: EdgeInsets.only(bottom: 20.w, left: 30.w, right: 30.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.w),
      ),
      child: boxCotainer,
    );
  }
}

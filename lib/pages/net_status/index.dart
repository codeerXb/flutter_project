// import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_template/core/widget/common_box.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// import '../../core/widget/common_widget.dart';

// /// 消息页面
// class NetStatus extends StatefulWidget {
//   const NetStatus(this.service, {Key? key}) : super(key: key);
//   final String service;
//   @override
//   State<StatefulWidget> createState() => _NetStatusState();
// }

// class _NetStatusState extends State<NetStatus> {
//   // 点击空白  关闭键盘 时传的一个对象
//   FocusNode blankNode = FocusNode();

//   /// 点击空白  关闭输入键盘
//   void closeKeyboard(BuildContext context) {
//     FocusScope.of(context).requestFocus(blankNode);
//   }

//   String get vn => widget.service;
//   // 下拉列表
//   bool isShowList = false;
//   List<Map<String, dynamic>> get serviceList => [
//         {
//           'label': widget.service,
//           'sn': '12123213',
//         },
//         {
//           'label': 'test',
//           'sn': '12123213',
//         }
//       ];

// // 下拉列表
//   Widget buildGrid() {
//     List<Widget> tiles = []; //先建一个数组用于存放循环生成的widget
//     Widget content; //单独一个widget组件，用于返回需要生成的内容widget
//     for (var item in serviceList) {
//       tiles.add(Container(
//         padding: EdgeInsets.only(left: 20.w, top: 20.w, bottom: 20.w),
//         child: InkWell(
//           onTap: () {},
//           child: Row(children: <Widget>[
//             if (item['label'] == vn)
//               Padding(
//                 padding: EdgeInsets.only(right: 16.sp),
//                 child: FaIcon(
//                   FontAwesomeIcons.chevronRight,
//                   size: 30.w,
//                   color: Colors.white,
//                 ),
//               ),
//             Text(
//               item['label'],
//               style: TextStyle(color: Colors.white, fontSize: 30.sp),
//             ),
//           ]),
//         ),
//       ));
//     }
//     content = Container(
//       color: const Color.fromARGB(153, 31, 31, 31),
//       width: 1.sw,
//       child: Column(
//           children: tiles //重点在这里，因为用编辑器写Column生成的children后面会跟一个<Widget>[]，
//           //此时如果我们直接把生成的tiles放在<Widget>[]中是会报一个类型不匹配的错误，把<Widget>[]删了就可以了
//           ),
//     );
//     return content;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//           image: DecorationImage(
//               alignment: Alignment.topCenter,
//               image: AssetImage(
//                 'assets/images/picture_home.png',
//               ),
//               fit: BoxFit.fitWidth)),
//       child: Scaffold(
//         appBar: AppBar(
//           elevation: 0,
//           title: InkWell(
//             overlayColor: const MaterialStatePropertyAll(Colors.transparent),
//             onTap: () {
//               setState(() {
//                 isShowList = !isShowList;
//               });
//             },
//             //下拉icon
//             child: SizedBox(
//               width: 1.sw,
//               child: Row(
//                 children: [
//                   Text(vn),
//                   FaIcon(
//                     FontAwesomeIcons.chevronDown,
//                     size: 30.w,
//                   )
//                 ],
//               ),
//             ),
//           ),
//           backgroundColor: Colors.transparent,
//         ),
//         backgroundColor: Colors.transparent,
//         body: GestureDetector(
//           onTap: () => closeKeyboard(context),
//           behavior: HitTestBehavior.opaque,
//           child: Container(
//             decoration:
//                 const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
//             height: 1000,
//             child: Stack(
//               children: [
//                 // 头部下拉widget
//                 Container(
//                   width: 1.sw,
//                   height: 200.h,
//                   color: Colors.transparent,
//                 ),
//                 if (isShowList) Positioned(top: 0.w, child: buildGrid()),
//                 Column(
//                   children: [
//                     //2
//                     Container(
//                         height: 150.w,
//                         padding: EdgeInsets.all(28.0.w),
//                         margin: EdgeInsets.only(
//                             bottom: 20.w, left: 30.w, right: 30.w),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(18.w),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               '已连接',
//                               style: TextStyle(
//                                   fontSize: 30.sp,
//                                   color: const Color(0xff051220)),
//                             ),
//                             Column(
//                               children: [
//                                 Text(
//                                   '优',
//                                   style: TextStyle(
//                                       fontSize: 30.sp, color: Colors.blue),
//                                 ),
//                                 Text(
//                                   '网络环境',
//                                   style: TextStyle(
//                                       fontSize: 30.sp, color: Colors.blue),
//                                 ),
//                               ],
//                             ),
//                             IconButton(
//                               onPressed: () {
//                                 debugPrint('1');
//                               },
//                               icon: const Icon(Icons.rocket),
//                             )
//                           ],
//                         )),
//                     //3
//                     Container(
//                         height: 150.w,
//                         padding: EdgeInsets.all(28.0.w),
//                         margin: EdgeInsets.only(
//                             bottom: 20.w, left: 30.w, right: 30.w),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(18.w),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Column(
//                               children: [
//                                 Text(
//                                   '0.4MB',
//                                   style: TextStyle(
//                                       fontSize: 30.sp,
//                                       color: const Color(0xff051220)),
//                                 ),
//                                 Text(
//                                   '已使用',
//                                   style: TextStyle(
//                                       fontSize: 30.sp,
//                                       color: const Color(0xff051220)),
//                                 ),
//                               ],
//                             ),
//                          FloatingActionButton(onPressed: (){

//                          },
//                              child: Text('我是浮动按钮'),
//                          ),
//                             Column(
//                               children: [
//                                 Text(
//                                   '5 GB/月',
//                                   style: TextStyle(
//                                       fontSize: 30.sp,
//                                       color: const Color(0xff051220)),
//                                 ),
//                                 Text(
//                                   '流量套餐',
//                                   style: TextStyle(
//                                       fontSize: 30.sp,
//                                       color: const Color(0xff051220)),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         )),
//                     Text('2'),
//                     Text('3'),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/core/widget/common_widget.dart';
import 'package:flutter_template/core/widget/custom_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter_template/pages/net_status/arc_progress_bar.dart';
import 'package:flutter_template/pages/net_status/model/net_connect_status.dart';
import 'package:flutter_template/pages/net_status/dashboard.dart';

import '../../core/http/http.dart';
import '../../generated/l10n.dart';
import 'homepage_state_btn.dart';

/// 消息页面
class NetStatus extends StatefulWidget {
  const NetStatus(this.service, {Key? key}) : super(key: key);
  final String service;
  @override
  State<StatefulWidget> createState() => _NetStatusState();
}

class _NetStatusState extends State<NetStatus> {
  // 定义套餐类型
  int _comboType = 0;
  // 定义套餐总量
  double _totalComboData = 0;
  // 定义显示套餐状况
  String _comboLabel =  S.current.Notset;
  // 套餐周期
  List<String> comboCycleLabel = [
    S.current.day,
    S.current.month,
    S.current.year
  ];
  // 有线连接状况：1:连通0：未连接
  String _wanStatus = '0';
  // wifi连接状况：1:连通0：未连接
  String _wifiStatus = '0';
  // sim卡连接状况：1:连通0：未连接
  String _simStatus = '0';
  // 上行速率
  double _upRate = 0;
  // 下行速率
  double _downRate = 0;

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

  /// 获取网络连接状态和上下行速率并更新
  void updateStatus() async {
    Map<String, dynamic> netStatus = {
      'method': 'obj_get',
      'param':
          '["ethernetConnectionStatus","systemDataRateDlCurrent","systemDataRateUlCurrent","wifiHaveOrNot","wifi5gHaveOrNot","wifiEnable","wifi5gEnable","lteRoam"]'
    };
    try {
      var response = await XHttp.get('/data.html', netStatus);
      // 以 { 或者 [ 开头的
      RegExp exp = RegExp('^[{[]');
      if (!exp.hasMatch(response) && mounted) {
        setState(() {
          _wanStatus = '0';
          _wifiStatus = '0';
          _simStatus = '0';
          _upRate = 0;
          _downRate = 0;
        });
        debugPrint('netStatus得到数据不是json');
      }
      var resObj = NetConnecStatus.fromJson(json.decode(response));
      String wanStatus = resObj.ethernetConnectionStatus == '1' ? '1' : '0';
      String wifiStatus =
          (resObj.wifiHaveOrNot == '1' || resObj.wifi5gHaveOrNot == '1')
              ? '1'
              : '0';
      String simStatus = resObj.lteRoam == '1' ? '1' : '0';
      double upRate = resObj.systemDataRateUlCurrent != null
          ? double.parse(resObj.systemDataRateUlCurrent!)
          : 0;
      double downRate = resObj.systemDataRateDlCurrent != null
          ? double.parse(resObj.systemDataRateDlCurrent!)
          : 0;
      if (mounted) {
        setState(() {
          _wanStatus = wanStatus;
          _wifiStatus = wifiStatus;
          _simStatus = simStatus;
          _upRate = upRate;
          _downRate = downRate;
        });
      }
      debugPrint('wanStatus=$wanStatus,wifi=$wifiStatus,sim=$simStatus');
    } catch (err) {
      debugPrint(err.toString());
    }
  }

  Timer? timer;
  @override
  void initState() {
    super.initState();
    // 获取套餐总量
    sharedGetData('c_type', int).then((value) {
      if (value != null) {
        setState(() => _comboType = int.parse(value.toString()));
      }
    });

    sharedGetData('c_contain', double).then((value) {
      if (value != null) {
        setState(() => _totalComboData = double.parse(value.toString()));
      }
    });

    Future.wait([
      sharedGetData('c_type', int),
      sharedGetData('c_contain', double),
      sharedGetData('c_cycle', int),
    ]).then((results) {
      if (results[0] != null && results[1] != null && results[2] != null) {
        setState(() {
          _comboLabel = results[0] == 0
              ? '${results[1]}GB/${comboCycleLabel[results[2] as int]}'
              : '${results[1]}h/${comboCycleLabel[results[2] as int]}';
        });
      }
    }).catchError((e) {
      printError(info: 'error:$e');
    });

    updateStatus();

    timer = Timer.periodic(const Duration(milliseconds: 2000), (t) async {
      if (mounted) updateStatus();
    });
  }

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
              image: AssetImage('assets/images/picture_home_bg.png'),
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
        body: Stack(
          children: [
            Column(
              children: <Widget>[
                // 头部widget
                Container(
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.only(
                      left: 30.sp, right: 26.sp, top: 0, bottom: 30.sp),
                  width: 1.sw,
                  height: 240.h,
                  color: Colors.transparent,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: 40.h,
                                padding: EdgeInsets.only(
                                    left: 16.sp,
                                    right: 16.sp,
                                    top: 0,
                                    bottom: 0),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.sp)),
                                    border: Border.all(
                                        width: 1, color: Colors.white)),
                                child: Text(
                                  '${S.of(context).TotalPackageQuantity} :$_comboLabel',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ]),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                HomePageStateBtn(
                                  imageUrl:
                                      'assets/images/icon_homepage_wan.png',
                                  offImageUrl:
                                      'assets/images/icon_homepage_no_wan.png',
                                  routeName: '/wan_settings',
                                  status: _wanStatus,
                                ),
                                HomePageStateBtn(
                                  imageUrl:
                                      'assets/images/icon_homepage_wifi.png',
                                  offImageUrl:
                                      'assets/images/icon_homepage_no_wifi.png',
                                  routeName: '/wlan_set',
                                  status: _wifiStatus,
                                ),
                                HomePageStateBtn(
                                  imageUrl:
                                      'assets/images/icon_homepage_sim.png',
                                  offImageUrl:
                                      'assets/images/icon_homepage_no_sim.png',
                                  status: _simStatus,
                                  routeName: '/radio_settings',
                                ),
                              ],
                            ),
                            TextButton(
                                onPressed: () => {
                                      Get.toNamed('/net_server_settings')
                                          ?.then((value) {
                                        setState(() {
                                          _comboLabel = value['type'] == 0
                                              ? '${value['contain']}GB/${comboCycleLabel[value['cycle']]}'
                                              : '${value['contain']}h/${comboCycleLabel[value['cycle']]}';
                                          _comboType = value['type'];
                                          _totalComboData = value['contain'];
                                        });
                                      })
                                    },
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        S.of(context).PackageSetting,
                                        style: TextStyle(
                                            height: 1,
                                            fontSize: 28.sp,
                                            color: Colors.white),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 8.sp),
                                        child: FaIcon(
                                          FontAwesomeIcons.chevronRight,
                                          size: 34.sp,
                                          color: Colors.white,
                                        ),
                                      )
                                    ]))
                          ],
                        )
                      ]),
                ),
                // 仪表盘和数值显示
                Expanded(
                    flex: 1,
                    child: Dashboard(
                      comboType: _comboType,
                      totalComboData: _totalComboData,
                      upRate: _upRate,
                      downRate: _downRate,
                    )),
              ],
            ),
            if (isShowList) Positioned(top: 0.w, child: buildGrid()),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    debugPrint('状态页面销毁');
    timer?.cancel();
    timer = null;
  }
}

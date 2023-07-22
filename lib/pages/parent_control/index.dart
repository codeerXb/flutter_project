import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/request/request.dart';
import 'package:flutter_template/core/widget/water_loading.dart';
import 'package:flutter_template/pages/parent_control/arc_progress_bar.dart';
import 'package:flutter_template/pages/parent_control/card_list/Blocklist.dart';
import 'package:get/get.dart';
import '../../core/widget/custom_app_bar.dart';
import '../net_status/index.dart';
import 'dart:convert';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter_template/core/http/http_app.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/generated/l10n.dart';

import '../../config/base_config.dart';

/// 家长控制
class Parent extends StatefulWidget {
  const Parent({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ParentState();
}

class _ParentState extends State<Parent> {
  //获取列表
  getDeviceListFn() async {
    var res = await sharedGetData('deviceSn', String);
    setState(() {
      loading = true;
      sn = res.toString();
    });
    var response = await App.post(
        '${BaseConfig.cloudBaseUrl}/cpeMqtt/getDevicesTable',
        data: {'sn': sn, "type": "getDevicesTable"});
    setState(() {
      loading = false;
    });
    var d = json.decode(response.toString());
    setState(() {
      d['data']['wifiDevices'].addAll(d['data']['lanDevices']);
      deviceList = d['data']['wifiDevices'];

      //编辑文字回显
      _editvalueList.addAll(
          deviceList.map((item) => TextEditingController(text: item['name'])));
      print('设备列表$deviceList');
    });
  }

  @override
  void initState() {
    super.initState();
    getDeviceListFn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppbar(context: context, title: 'Parental control'),
        body: loading
            ? const Center(
                child: SizedBox(
                  height: 80,
                  width: 80,
                  child: WaterLoading(
                    color: Color.fromARGB(255, 65, 167, 251),
                  ),
                ),
              )
            : Container(
                padding: EdgeInsets.only(
                    left: 26.0.w, top: 0, right: 26.0.w, bottom: 26.0.w),
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(240, 240, 240, 1)),
                height: 1400.w,
                child: CustomScrollView(
                  slivers: [
                    //吸顶
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: MySliverAppBar(
                        minHeight: 200.w,
                        maxHeight: 200.w,
                        child: const SwiperCard(),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Padding(padding: EdgeInsets.only(top: 20.w)),
                        //今日网络使用情况
                        const InternetUsage(),
                        Padding(padding: EdgeInsets.only(top: 20.w)),
                        //6
                        const SixBoxs(),
                        //允许上网时间
                        const Scheduling(),
                      ]),
                    ),
                  ],
                )

                // SingleChildScrollView(
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.stretch,
                //     children: [
                //       const SwiperCard(),

                //       Padding(padding: EdgeInsets.only(top: 20.w)),
                //       //今日网络使用情况
                //       InternetUsage(),

                //       Padding(padding: EdgeInsets.only(top: 20.w)),

                //       //6
                //       SixBoxs(),

                //       //允许上网时间
                //       const Scheduling()
                //     ],
                //   ),
                // )

                ));
  }
}

List<Map<String, dynamic>> filteredData = [];

//选中time period
bool isFirst = true;
//选择日期
String date = 'Mon';
bool loading = true;
String sn = '';
bool isEditable = false; //是否编辑
List deviceList = []; //设备列表
final List<TextEditingController> _editvalueList = []; //编辑列表

//今日网络使用情况
class InternetUsage extends StatelessWidget {
  const InternetUsage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(28.0.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.w),
        ),
        child: Column(
          children: [
            //第一行
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //left
                Text('Internet usage today'),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 60.w)),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Shopping
                    GestureDetector(
                      onTap: () {
                        // 在此处添加导航到其他页面的代码
                        Get.toNamed('/Payment');
                      },
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                            topRight: Radius.circular(30),
                            bottomLeft: Radius.circular(30),
                          ),
                          color: const Color.fromARGB(255, 88, 225, 235),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Shopping',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white)),
                            Padding(padding: EdgeInsets.only(top: 5.w)),
                            const Text('0 min',
                                style: TextStyle(
                                    fontSize: 8, color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(left: 5.w)),
                    // video
                    GestureDetector(
                      onTap: () {
                        // 在此处添加导航到其他页面的代码
                        Get.toNamed('/Video');
                      },
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                            topRight: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                          ),
                          color: const Color.fromARGB(255, 238, 138, 205),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Video',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white)),
                            Padding(padding: EdgeInsets.only(top: 5.w)),
                            const Text('0 min',
                                style: TextStyle(
                                    fontSize: 8, color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 5.w)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // 在此处添加导航到其他页面的代码
                        Get.toNamed('/Installed');
                      },
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                            topRight: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                          ),
                          color: const Color.fromARGB(255, 241, 167, 98),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('APP Stores',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white)),
                            Padding(padding: EdgeInsets.only(top: 5.w)),
                            const Text('0 min',
                                style: TextStyle(
                                    fontSize: 8, color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(left: 5.w)),
                    // Social
                    GestureDetector(
                      onTap: () {
                        // 在此处添加导航到其他页面的代码
                        Get.toNamed('/Social');
                      },
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                            topRight: Radius.circular(30),
                            bottomLeft: Radius.circular(30),
                          ),
                          color: const Color.fromARGB(255, 207, 124, 240),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Social media',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white)),
                            Padding(padding: EdgeInsets.only(top: 5.w)),
                            const Text('0 min',
                                style: TextStyle(
                                    fontSize: 8, color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 60.w)),

            //第三行
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: (() {
                    Get.toNamed('/Internet');
                  }),
                  child: Column(
                    children: [
                      const Text(
                        'Time Online',
                        style: TextStyle(color: Colors.black45),
                      ),
                      Text(
                        '0 min',
                        style: TextStyle(fontSize: 36.w, color: Colors.black87),
                      ),
                      // const Text(
                      //   'Healthy Internet access',
                      //   style: TextStyle(color: Colors.black45),
                      // )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: (() {
                    Get.toNamed('/Internet');
                  }),
                  child: Column(
                    children: [
                      const Text(
                        'Time Left',
                        style: TextStyle(color: Colors.black45),
                      ),
                      Text(
                        'Not Set',
                        style: TextStyle(fontSize: 36.w, color: Colors.black87),
                      ),
                      // const Text(
                      //   'Add 10 min',
                      //   style: TextStyle(color: Colors.black45),
                      // )
                    ],
                  ),
                )
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 60.w)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 300.w,
                  height: 80.w,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(240, 240, 240, 1),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.wifi_off_outlined,
                        color: const Color.fromRGBO(144, 147, 153, 1),
                        size: 40.w,
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 150.w),
                        child: const FittedBox(
                          child: Text(
                            'Disconnect Internet',
                            style: TextStyle(color: Colors.black87),
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_drop_down_outlined,
                        color: const Color.fromRGBO(144, 147, 153, 1),
                        size: 40.w,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 300.w,
                  height: 80.w,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(240, 240, 240, 1),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.verified_user_outlined,
                        color: const Color.fromRGBO(144, 147, 153, 1),
                        size: 40.w,
                      ),
                      const Text(
                        'No Time Limit',
                        style: TextStyle(color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ));
  }
}

var name;
ValueNotifier<String> MACAddress = ValueNotifier('');

//上方轮播图
class SwiperCard extends StatefulWidget {
  const SwiperCard({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SwiperCardState();
}

class _SwiperCardState extends State<SwiperCard> {
  //云端
  getACSNodeFn(index) async {
    try {
      var parameterNames = [
        "InternetGatewayDevice.WEB_GUI.ParentalControls",
      ];
      //获取云端数据
      var res = await Request().getACSNode(parameterNames, sn);
      Map<String, dynamic> d = jsonDecode(res);
      var resList = d['data']['InternetGatewayDevice']['WEB_GUI']
          ['ParentalControls']['List'];
      setState(() {
        resList.remove('_object');
        resList.remove('_timestamp');
        resList.remove('_writable');
        accessList = [];
        filteredData = [];
      });

      resList.forEach((key, value) {
        setState(() {
          accessList.add(value);
        });
      });
      setState(() {
        MACAddress.value = deviceList[index]['MACAddress'];
        name = deviceList[index]['name'];
        date = 'Mon';

        //过滤列表
        accessList = accessList
            .where((element) => element['Device']['_value'] == MACAddress.value)
            .toList();
      });
      for (var item in accessList) {
        if (item['Weekdays']['_value'].contains('Mon')) {
          filteredData.add({
            'TimeStart': item['TimeStart']['_value'],
            'TimeStop': item['TimeStop']['_value'],
          });
        }
      }
    } catch (e) {
      // 处理异常
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    if (deviceList[0].containsKey('connection')) {
      MACAddress.value = deviceList[0]['MACAddress'];
    } else {
      MACAddress.value = deviceList[0]['MacAddress'];
    }
    name = deviceList[0]['name'];
  }

  //重设名称
  editName(String sn, String mac, String nickname) async {
    Map<String, dynamic> form = {
      'sn': sn,
      'mac': mac,
      'nickname': nickname,
    };
    var res = await App.post('${BaseConfig.cloudBaseUrl}/platform/cpeNick/nick',
        data: form);
    var d = json.decode(res.toString());
    if (d['code'] != 200) {
      ToastUtils.error(d['message']);
    } else {
      ToastUtils.success(d['message']);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: deviceList.isNotEmpty ? 240.w : 0.w,
      child: Swiper(
          onIndexChanged: (int index) {
            getACSNodeFn(index);
          },
          itemCount: deviceList.length, // 轮播图数量
          itemBuilder: (BuildContext context, int index) {
            return Card(
              clipBehavior: Clip.hardEdge,
              elevation: 5, //设置卡片阴影的深度
              shape: const RoundedRectangleBorder(
                //设置卡片圆角
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color.fromARGB(255, 200, 211, 246),
                      Color.fromARGB(255, 219, 224, 228),
                    ],
                  ),
                ),
                child: ListTile(
                  //图片
                  leading: ClipOval(
                      child: Image.asset('assets/images/phone.png',
                          fit: BoxFit.fitWidth, width: 110.w)),
                  //中间文字
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SizedBox(
                          child:
                              //显示的文字
                              Text(
                            deviceList[index]['name'],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ),
                      // 编辑
                      IconButton(
                        onPressed: () {
                          //底部弹出Container
                          showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (BuildContext context) {
                              return WillPopScope(
                                onWillPop: () async {
                                  Navigator.pop(context);
                                  _editvalueList[index].text =
                                      deviceList[index]['name'];
                                  return false;
                                },
                                child: SingleChildScrollView(
                                  child: Container(
                                    padding: EdgeInsets.only(
                                      left: 40.w,
                                      right: 40.w,
                                      //将在输入框底部添加一个填充，以确保输入框不会被键盘遮挡。
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom,
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                            padding:
                                                EdgeInsets.only(top: 30.w)),

                                        //title
                                        Text(
                                          S.current.ModifyRemarks,
                                          style: TextStyle(fontSize: 46.sp),
                                        ),
                                        Padding(
                                            padding:
                                                EdgeInsets.only(top: 46.w)),

                                        //输入框
                                        TextField(
                                          autofocus: true,
                                          controller: _editvalueList[index],
                                          decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.only(left: 20.w),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            hintText: S.current.pleaseEnter,
                                            suffixIcon: IconButton(
                                              icon: const Icon(Icons.clear),
                                              onPressed: () {
                                                // 清空输入框中的内容
                                                _editvalueList[index].clear();
                                              },
                                            ),
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              deviceList[index]['name'] = value;
                                            });
                                          },
                                        ),

                                        Padding(
                                            padding:
                                                EdgeInsets.only(top: 20.w)),
                                        //btn
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            //取消
                                            ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  _editvalueList[index].text =
                                                      deviceList[index]['name'];
                                                });
                                                Navigator.pop(context);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                minimumSize: Size(300.w, 70.w),
                                              ),
                                              child: Text(S.current.cancel),
                                            ),
                                            //确定
                                            ElevatedButton(
                                              onPressed: () {
                                                if (_editvalueList[index]
                                                    .text
                                                    .isNotEmpty) {
                                                  isEditable = false;
                                                  editName(
                                                      sn,
                                                      deviceList[index]
                                                              ['MACAddress'] ??
                                                          deviceList[index]
                                                              ['MacAddress'],
                                                      deviceList[index]
                                                          ['name']);
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                minimumSize: Size(300.w, 70.w),
                                              ),
                                              child: Text(S.current.confirm),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                          setState(() {
                            isEditable = true;
                          });
                        },
                        icon: const Icon(Icons.create),
                      )
                    ],
                  ),

                  //title下方显示的内容
                  subtitle: Text(
                    deviceList[index]['connection'] ?? 'LAN',
                  ),
                ),
              ),
            );
          },
          pagination: const SwiperPagination()),
    );
  }
}

//卡片
class SixBoxs extends StatefulWidget {
  const SixBoxs({super.key});
  @override
  SixBoxsState createState() => SixBoxsState();
}

class SixBoxsState extends State<SixBoxs> {
  int urlListAmount = 0;

// URL
  getURLFilter() async {
    var sn = await sharedGetData('deviceSn', String);
    setState(() {
      loading = true;
      sn = sn.toString();
    });
    var parameterNames = [
      "InternetGatewayDevice.WEB_GUI.Security.URLFilter",
    ];
    var response = await Request().getACSNode(parameterNames, sn);
    try {
      Map<String, dynamic> d = jsonDecode(response);
      setState(() {
        loading = false;
        Map<String, dynamic> flowTableName = d['data']['InternetGatewayDevice']
            ['WEB_GUI']['Security']['URLFilter']['List'];
        urlListAmount = flowTableName.keys
            .toList()
            .where((element) {
              var pattern = RegExp(r'[0-9]+');
              var isMatch = pattern.hasMatch(element);
              return isMatch;
            })
            .toList()
            .length;
      });
    } catch (e) {
      loading = false;
      debugPrint('获取设备信息失败：${e.toString()}');
    }
  }

  @override
  void initState() {
    super.initState();
    getURLFilter();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 320.w,
          child: GridView(
            physics: const NeverScrollableScrollPhysics(), //禁止滚动
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, //一行的Widget数量
              childAspectRatio: 2, //宽高比为1
              crossAxisSpacing: 22, //横轴方向子元素的间距
            ),
            children: <Widget>[
              //Games
              // GestureDetector(
              //   onTap: () {
              //     Get.toNamed('/games');
              //   },
              //   child: GardCard(
              //       boxCotainer: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Row(
              //         children: [
              //           Padding(
              //             padding: const EdgeInsets.only(right: 2),
              //             child: Icon(Icons.games,
              //                 color: const Color.fromRGBO(95, 141, 255, 1),
              //                 size: 80.sp),
              //           ),
              //           Column(
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               const Text('Games'),
              //               Text(
              //                 '11 allowed',
              //                 style:
              //                     TextStyle(color: Colors.black54, fontSize: 25.sp),
              //               ),
              //             ],
              //           )
              //         ],
              //       ),
              //       Icon(
              //         Icons.arrow_forward_ios_outlined,
              //         color: const Color.fromRGBO(144, 147, 153, 1),
              //         size: 30.w,
              //       )
              //     ],
              //   )),
              // ),
              //Video
              GestureDetector(
                onTap: () {
                  Get.toNamed('/Video',
                      arguments: {'mac': MACAddress.value, 'sn': sn});
                },
                child: GardCard(
                    boxCotainer: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 2),
                          child: Icon(Icons.videocam_rounded,
                              color: const Color.fromRGBO(95, 141, 255, 1),
                              size: 80.sp),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: 150.w),
                                child: const FittedBox(
                                    child: Text('Video Streaming'))),
                            Text(
                              '6 allowed',
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 25.sp),
                            ),
                          ],
                        )
                      ],
                    ),
                    Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: const Color.fromRGBO(144, 147, 153, 1),
                      size: 30.w,
                    )
                  ],
                )),
              ),
              //Social
              GestureDetector(
                onTap: () {
                  Get.toNamed('/Social',
                      arguments: {'mac': MACAddress.value, 'sn': sn});
                },
                child: GardCard(
                    boxCotainer: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 2),
                          child: Icon(Icons.chat_rounded,
                              color: const Color.fromRGBO(95, 141, 255, 1),
                              size: 80.sp),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: 150.w),
                                child: const FittedBox(
                                    child: Text('Social media'))),
                            Text(
                              '3 allowed',
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 25.sp),
                            ),
                          ],
                        )
                      ],
                    ),
                    Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: const Color.fromRGBO(144, 147, 153, 1),
                      size: 30.w,
                    )
                  ],
                )),
              ),
              //shopping
              GestureDetector(
                onTap: () {
                  Get.toNamed('/Payment',
                      arguments: {'mac': MACAddress.value, 'sn': sn});
                },
                child: GardCard(
                    boxCotainer: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 2),
                          child: Icon(Icons.payment,
                              color: const Color.fromRGBO(95, 141, 255, 1),
                              size: 80.sp),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: 150.w),
                                child:
                                    const FittedBox(child: Text('Shopping'))),
                            Text(
                              '4 allowed',
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 25.sp),
                            ),
                          ],
                        )
                      ],
                    ),
                    Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: const Color.fromRGBO(144, 147, 153, 1),
                      size: 30.w,
                    )
                  ],
                )),
              ),
              //APP Stores
              GestureDetector(
                onTap: () {
                  Get.toNamed('/Installed',
                      arguments: {'mac': MACAddress.value, 'sn': sn});
                },
                child: GardCard(
                    boxCotainer: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 2),
                          child: Icon(Icons.install_mobile,
                              color: const Color.fromRGBO(95, 141, 255, 1),
                              size: 80.sp),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: 150.w),
                                child:
                                    const FittedBox(child: Text('APP Stores'))),
                            Text(
                              '2 allowed',
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 25.sp),
                            ),
                          ],
                        )
                      ],
                    ),
                    Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: const Color.fromRGBO(144, 147, 153, 1),
                      size: 30.w,
                    )
                  ],
                )),
              ),
            ],
          ),
        ),
        //URL blocklist
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Blocklist(),
                  settings: RouteSettings(
                      arguments: {'mac': MACAddress.value, 'sn': sn}),
                )).then((value) {
              setState(() {
                getURLFilter();
              });
            });
          },
          child: GardCard(
              boxCotainer: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(right: 2),
                      child: Icon(Icons.block,
                          color: const Color.fromRGBO(95, 141, 255, 1),
                          size: 80.sp)),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 350.w),
                          child: const FittedBox(
                              child: Text('Website Blocklist'))),
                      Text(
                        '$urlListAmount blocked',
                        style:
                            TextStyle(color: Colors.black54, fontSize: 35.sp),
                      ),
                    ],
                  )
                ],
              ),
              Icon(
                Icons.arrow_forward_ios_outlined,
                color: const Color.fromRGBO(144, 147, 153, 1),
                size: 30.w,
              )
            ],
          )),
        ),
      ],
    );
  }
}

List accessList = []; //家长控制列表

//允许上网时间安排
class Scheduling extends StatefulWidget {
  const Scheduling({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SchedulingState();
}

class _SchedulingState extends State<Scheduling> {
  //云端
  getACSNodeFn() async {
    setState(() {
      loading = true;
    });

    try {
      var parameterNames = [
        "InternetGatewayDevice.WEB_GUI.ParentalControls",
      ];
      //获取云端数据
      var res = await Request().getACSNode(parameterNames, sn);
      Map<String, dynamic> d = jsonDecode(res);
      var resList = d['data']['InternetGatewayDevice']['WEB_GUI']
          ['ParentalControls']['List'];
      setState(() {
        resList.remove('_object');
        resList.remove('_timestamp');
        resList.remove('_writable');
        accessList = [];
        date = 'Mon';
        filteredData = [];
      });

      resList.forEach((key, value) {
        setState(() {
          accessList.add(value);
        });
      });
      setState(() {
        //过滤列表
        accessList = accessList
            .where((element) => element['Device']['_value'] == MACAddress.value)
            .toList();
      });
      for (var item in accessList) {
        if (item['Weekdays']['_value'].contains('Mon')) {
          filteredData.add({
            'TimeStart': item['TimeStart']['_value'],
            'TimeStop': item['TimeStop']['_value'],
          });
        }
      }
    } catch (e) {
      // 处理异常
      debugPrint(e.toString());
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getACSNodeFn();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(28.0.w),
        // margin: EdgeInsets.only(bottom: 20.w, left: 30.w, right: 30.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.w),
        ),
        child: Column(
          children: [
            //第一行
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //left
                const Text('Internet access time scheduling'),
                //right
                GestureDetector(
                  onTap: () {
                    Get.toNamed('/Internetaccess', arguments: {
                      "sn": sn,
                      "MACAddress": MACAddress.value,
                      "name": name
                    });
                  },
                  child: Row(
                    children: [
                      Text('Settings',
                          style: TextStyle(
                              color: const Color.fromRGBO(144, 147, 153, 1),
                              fontSize: 30.sp)),
                      Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: const Color.fromRGBO(144, 147, 153, 1),
                        size: 30.w,
                      )
                    ],
                  ),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 20.w)),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      isFirst = true;
                    });
                  },
                  child: Text(
                    'Time Period',
                    style: TextStyle(
                        color: isFirst
                            ? const Color.fromRGBO(95, 141, 255, 1)
                            : Colors.black54),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isFirst = false;
                    });
                  },
                  child: Text(
                    'Duration',
                    style: TextStyle(
                        color: !isFirst
                            ? const Color.fromRGBO(95, 141, 255, 1)
                            : Colors.black54),
                  ),
                )
              ],
            ),
            // Image(
            //   image: isFirst
            //       ? AssetImage('assets/images/leftTime.png')
            //       : AssetImage('assets/images/Durationtime.png'),
            // ),
            // TODO 周期显示的图片
            if (isFirst)
              GestureDetector(
                onTap: () {
                  Get.toNamed('/Internetaccess', arguments: {
                    "sn": sn,
                    "MACAddress": MACAddress.value,
                    "name": name
                  });
                },
                child: Container(
                  margin: EdgeInsets.zero,
                  color: const Color.fromARGB(255, 255, 255, 255),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          ValueListenableBuilder<String>(
                            valueListenable: MACAddress,
                            builder: (context, value, child) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width: 390.w,
                                    height: 390.w,
                                    child: ArcProgresssBar(
                                        width: 1.sw,
                                        height: 1.sw,
                                        progress: filteredData),
                                  ),
                                ],
                              );
                            },
                          ),
                          Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 14.sp),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Center(
                        child: Container(
                            margin: const EdgeInsets.only(right: 15, left: 15),
                            padding: const EdgeInsets.only(top: 15, bottom: 15),
                            width: 1.sw - 30,
                            decoration: const BoxDecoration(
                              // 背景色
                              color: Color.fromARGB(255, 255, 255, 255),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                // UploadSpeed(
                                //   rate: widget.upRate,
                                // ),
                                // DownloadSpeed(
                                //   rate: widget.downRate,
                                // ),
                                // OnlineCount(
                                //   count: _onlineCount,
                                // ),
                              ],
                            )),
                      ),
                      const Text('Internet Time',
                          style: TextStyle(
                              color: Color.fromARGB(255, 109, 109, 109),
                              fontSize: 12)),
                    ],
                  ),
                ),
              ),

            if (!isFirst)
              const Image(
                image: AssetImage('assets/images/Durationtime.png'),
              ),

            ValueListenableBuilder<String>(
              valueListenable: MACAddress,
              builder: (context, value, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //Mon
                    Expanded(
                      child: TextButton(
                        style: ButtonStyle(
                            fixedSize:
                                MaterialStateProperty.all(const Size(10, 10))),
                        onPressed: () {
                          setState(() {
                            date = 'Mon';
                            filteredData = [];
                          });
                          getACSNodeFn();
                          for (var item in accessList) {
                            if (item['Weekdays']['_value'].contains('Mon')) {
                              filteredData.add({
                                'TimeStart': item['TimeStart']['_value'],
                                'TimeStop': item['TimeStop']['_value'],
                              });
                            }
                          }
                        },
                        child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 150.w),
                            child: FittedBox(
                              child: Text(
                                'Mon',
                                style: TextStyle(
                                    color: date == 'Mon'
                                        ? Colors.blue
                                        : Colors.black54),
                              ),
                            )),
                      ),
                    ),

                    //Tue
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            filteredData = [];
                            date = 'Tue';
                          });
                          for (var item in accessList) {
                            if (item['Weekdays']['_value'].contains('Tue')) {
                              filteredData.add({
                                'TimeStart': item['TimeStart']['_value'],
                                'TimeStop': item['TimeStop']['_value'],
                              });
                            }
                          }
                          print(filteredData);
                        },
                        child: FittedBox(
                          child: Text(
                            'Tue',
                            style: TextStyle(
                                color: date == 'Tue'
                                    ? Colors.blue
                                    : Colors.black54),
                          ),
                        ),
                      ),
                    ),

                    //Wed
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            date = 'Wed';
                            filteredData = [];
                          });
                          for (var item in accessList) {
                            if (item['Weekdays']['_value'].contains('Wed')) {
                              filteredData.add({
                                'TimeStart': item['TimeStart']['_value'],
                                'TimeStop': item['TimeStop']['_value'],
                              });
                            }
                          }
                          print(filteredData);
                        },
                        child: FittedBox(
                          child: Text(
                            'Wed',
                            style: TextStyle(
                                color: date == 'Wed'
                                    ? Colors.blue
                                    : Colors.black54),
                          ),
                        ),
                      ),
                    ),

                    //Thu
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            date = 'Thu';
                            filteredData = [];
                          });
                          for (var item in accessList) {
                            if (item['Weekdays']['_value'].contains('Thu')) {
                              filteredData.add({
                                'TimeStart': item['TimeStart']['_value'],
                                'TimeStop': item['TimeStop']['_value'],
                              });
                            }
                          }
                          print(filteredData);
                        },
                        child: FittedBox(
                          child: Text(
                            'Thu',
                            style: TextStyle(
                                color: date == 'Thu'
                                    ? Colors.blue
                                    : Colors.black54),
                          ),
                        ),
                      ),
                    ),

                    // Fri
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            date = 'Fri';
                            filteredData = [];
                          });
                          for (var item in accessList) {
                            if (item['Weekdays']['_value'].contains('Fri')) {
                              filteredData.add({
                                'TimeStart': item['TimeStart']['_value'],
                                'TimeStop': item['TimeStop']['_value'],
                              });
                            }
                          }
                          print(filteredData);
                        },
                        child: FittedBox(
                          child: Text(
                            'Fri',
                            style: TextStyle(
                                color: date == 'Fri'
                                    ? Colors.blue
                                    : Colors.black54),
                          ),
                        ),
                      ),
                    ),

                    // Sat
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            date = 'Sat';
                            filteredData = [];
                          });
                          for (var item in accessList) {
                            if (item['Weekdays']['_value'].contains('Sat')) {
                              filteredData.add({
                                'TimeStart': item['TimeStart']['_value'],
                                'TimeStop': item['TimeStop']['_value'],
                              });
                            }
                          }
                          print(filteredData);
                        },
                        child: FittedBox(
                          child: Text(
                            'Sat',
                            style: TextStyle(
                                color: date == 'Sat'
                                    ? Colors.blue
                                    : Colors.black54),
                          ),
                        ),
                      ),
                    ),

                    // Sun
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            date = 'Sun';
                            filteredData = [];
                          });
                          for (var item in accessList) {
                            if (item['Weekdays']['_value'].contains('Sun')) {
                              filteredData.add({
                                'TimeStart': item['TimeStart']['_value'],
                                'TimeStop': item['TimeStop']['_value'],
                              });
                            }
                          }
                          print(filteredData);
                        },
                        child: FittedBox(
                          child: Text(
                            'Sun',
                            style: TextStyle(
                                color: date == 'Sun'
                                    ? Colors.blue
                                    : Colors.black54),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ));
  }
}

//吸顶
class MySliverAppBar extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  MySliverAppBar({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(covariant MySliverAppBar oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

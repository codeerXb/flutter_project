import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  void initState() {
    super.initState();
    getDeviceListFn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppbar(context: context, title: 'Parental control'),
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : Container(
                padding: EdgeInsets.all(26.w),
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(240, 240, 240, 1)),
                height: 1400.w,
                child: Swiper(
                  onIndexChanged: (int index) {
                    print('index233$index');
                  },
                  itemCount: deviceList.length, // 轮播图数量
                  itemBuilder: (BuildContext context, int index) {
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          /// 顶部滑动卡片
                          Card(
                            clipBehavior: Clip.hardEdge,
                            elevation: 5, //设置卡片阴影的深度
                            shape: const RoundedRectangleBorder(
                              //设置卡片圆角
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
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
                                    child: Image.asset(
                                        'assets/images/phone.png',
                                        fit: BoxFit.fitWidth,
                                        width: 110.w)),
                                //中间文字
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 300.w,
                                      child:
                                          //显示的文字
                                          Text(
                                        deviceList[index]['name'],
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
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
                                                    bottom:
                                                        MediaQuery.of(context)
                                                            .viewInsets
                                                            .bottom,
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 30.w)),

                                                      //title
                                                      Text(
                                                        S.current.ModifyRemarks,
                                                        style: TextStyle(
                                                            fontSize: 46.sp),
                                                      ),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 46.w)),

                                                      //输入框
                                                      TextField(
                                                        autofocus: true,
                                                        controller:
                                                            _editvalueList[
                                                                index],
                                                        decoration:
                                                            InputDecoration(
                                                          contentPadding:
                                                              EdgeInsets.only(
                                                                  left: 20.w),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          hintText: S.current
                                                              .pleaseEnter,
                                                          suffixIcon:
                                                              IconButton(
                                                            icon: const Icon(
                                                                Icons.clear),
                                                            onPressed: () {
                                                              // 清空输入框中的内容
                                                              _editvalueList[
                                                                      index]
                                                                  .clear();
                                                            },
                                                          ),
                                                        ),
                                                        onChanged: (value) {
                                                          setState(() {
                                                            deviceList[index]
                                                                    ['name'] =
                                                                value;
                                                          });
                                                        },
                                                      ),

                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 20.w)),
                                                      //btn
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          //取消
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                _editvalueList[
                                                                            index]
                                                                        .text =
                                                                    deviceList[
                                                                            index]
                                                                        [
                                                                        'name'];
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text(S
                                                                .current
                                                                .cancel),
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              minimumSize: Size(
                                                                  300.w, 70.w),
                                                            ),
                                                          ),
                                                          //确定
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              if (_editvalueList[
                                                                      index]
                                                                  .text
                                                                  .isNotEmpty) {
                                                                isEditable =
                                                                    false;
                                                                editName(
                                                                    sn,
                                                                    deviceList[
                                                                            index]
                                                                        [
                                                                        'MACAddress'],
                                                                    deviceList[
                                                                            index]
                                                                        [
                                                                        'name']);
                                                              }
                                                            },
                                                            child: Text(S
                                                                .current
                                                                .confirm),
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              minimumSize: Size(
                                                                  300.w, 70.w),
                                                            ),
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
                                  deviceList[index]['connection'] == null
                                      ? '-'
                                      : deviceList[index]['connection'],
                                ),
                              ),
                            ),
                          ),

                          Padding(padding: EdgeInsets.only(top: 20.w)),
                          //今日网络使用情况
                          InternetUsage(),

                          Padding(padding: EdgeInsets.only(top: 20.w)),

                          //6
                          SixBoxs(),

                          //允许上网时间
                          const Scheduling()
                        ],
                      ),
                    );
                  },
                  pagination: SwiperPagination(), // 显示分页器
                )));
  }
}

//选中time period
bool isFirst = true;
//选择日期
String date = 'Sun';
bool loading = true;
String sn = '';
bool isEditable = false; //是否编辑
List deviceList = []; //设备列表
final List<TextEditingController> _editvalueList = []; //编辑列表

//今日网络使用情况
class InternetUsage extends StatelessWidget {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //left
                const Text('Internet usage today'),
                //right
                Row(
                  children: [
                    Text('More',
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
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 60.w)),
            const Image(
              image: AssetImage('assets/images/butterfly.png'),
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
                        'Online',
                        style: TextStyle(color: Colors.black45),
                      ),
                      Text(
                        '0 min',
                        style: TextStyle(fontSize: 36.w, color: Colors.black87),
                      ),
                      const Text(
                        'Healthy Internet access',
                        style: TextStyle(color: Colors.black45),
                      )
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
                      const Text(
                        'Add 10 min',
                        style: TextStyle(color: Colors.black45),
                      )
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

//卡片
class SixBoxs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 520.w,
      child: GridView(
        physics: const NeverScrollableScrollPhysics(), //禁止滚动
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, //一行的Widget数量
          childAspectRatio: 2, //宽高比为1
          crossAxisSpacing: 22, //横轴方向子元素的间距
        ),
        children: <Widget>[
          //Games
          GestureDetector(
            onTap: () {
              Get.toNamed('/games');
            },
            child: GardCard(
                boxCotainer: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 2),
                      child: Icon(Icons.games,
                          color: Colors.blue[500], size: 80.sp),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Games'),
                        Text(
                          '135 allowed',
                          style:
                              TextStyle(color: Colors.black54, fontSize: 25.sp),
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
          //Video
          GestureDetector(
            onTap: () {
              Get.toNamed('/Video');
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
                          color: Colors.blue[500], size: 80.sp),
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
                          '26 allowed',
                          style:
                              TextStyle(color: Colors.black54, fontSize: 25.sp),
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
              Get.toNamed('/Social');
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
                          color: Colors.blue[500], size: 80.sp),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 150.w),
                            child:
                                const FittedBox(child: Text('Social media'))),
                        Text(
                          '2 allowed',
                          style:
                              TextStyle(color: Colors.black54, fontSize: 25.sp),
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
          //payment
          GestureDetector(
            onTap: () {
              Get.toNamed('/Payment');
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
                          color: Colors.blue[500], size: 80.sp),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 150.w),
                            child: const FittedBox(
                                child: Text('Payment Service'))),
                        Text(
                          '4 allowed',
                          style:
                              TextStyle(color: Colors.black54, fontSize: 25.sp),
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
          //Installed
          GestureDetector(
            onTap: () {
              Get.toNamed('/Installed');
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
                          color: Colors.blue[500], size: 80.sp),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Installed'),
                        Text(
                          '8 allowed',
                          style:
                              TextStyle(color: Colors.black54, fontSize: 25.sp),
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
          //URL blocklist
          GestureDetector(
            onTap: () {
              Get.toNamed('/Blocklist');
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
                            color: Colors.blue[500], size: 80.sp)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 150.w),
                            child: const FittedBox(
                                child: Text('Website Blocklist'))),
                        Text(
                          '2 allowed',
                          style:
                              TextStyle(color: Colors.black54, fontSize: 25.sp),
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
    );
  }
}

//允许上网时间安排
class Scheduling extends StatefulWidget {
  const Scheduling({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SchedulingState();
}

class _SchedulingState extends State<Scheduling> {
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
                    Get.toNamed('/Internetaccess');
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
                    'time period',
                    style: TextStyle(
                        color: isFirst ? Colors.blue : Colors.black54),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isFirst = false;
                    });
                  },
                  child: Text(
                    'duration',
                    style: TextStyle(
                        color: !isFirst ? Colors.blue : Colors.black54),
                  ),
                )
              ],
            ),
            Image(
              image: isFirst
                  ? AssetImage('assets/images/leftTime.png')
                  : AssetImage('assets/images/Durationtime.png'),
            ),

            Row(
              // scrollDirection: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Sun
                // TextButton(

                //   onPressed: () {
                //     setState(() {
                //       date = 'Sun';
                //     });
                //   },
                //   child: Text(
                //     'Sun',
                //     style: TextStyle(
                //         color: date == 'Sun'
                //             ? Colors.blue
                //             : Colors.black54),
                //   ),
                // ),
                //Mon
                TextButton(
                  style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(const Size(10, 10))),

                  // style: ButtonStyle(fixedSize:MaterialStateProperty.all(const Size.fromHeight(5)) ),
                  onPressed: () {
                    setState(() {
                      date = 'Mon';
                    });
                  },
                  child: Text(
                    'Mon',
                    style: TextStyle(
                        color: date == 'Mon' ? Colors.blue : Colors.black54),
                  ),
                ),
                //Tue
                TextButton(
                  onPressed: () {
                    setState(() {
                      date = 'Tue';
                    });
                  },
                  child: Text(
                    'Tue',
                    style: TextStyle(
                        color: date == 'Tue' ? Colors.blue : Colors.black54),
                  ),
                ),
                //Wed
                TextButton(
                  onPressed: () {
                    setState(() {
                      date = 'Wed';
                    });
                  },
                  child: Text(
                    'Wed',
                    style: TextStyle(
                        color: date == 'Wed' ? Colors.blue : Colors.black54),
                  ),
                ),
                //Thu
                TextButton(
                  onPressed: () {
                    setState(() {
                      date = 'Thu';
                    });
                  },
                  child: Text(
                    'Thu',
                    style: TextStyle(
                        color: date == 'Thu' ? Colors.blue : Colors.black54),
                  ),
                ),
                // Fri
                TextButton(
                  onPressed: () {
                    setState(() {
                      date = 'Fri';
                    });
                  },
                  child: Text(
                    'Fri',
                    style: TextStyle(
                        color: date == 'Fri' ? Colors.blue : Colors.black54),
                  ),
                ),
              ],
            )
          ],
        ));
  }
}

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import 'package:flutter_template/core/widget/common_picker.dart';
import 'package:flutter_template/core/widget/otp_input.dart';
import 'package:flutter_template/pages/Ethernet/net/net_datas.dart';
import '../../../core/widget/custom_app_bar.dart';

/// 以太网设置
class NetSet extends StatefulWidget {
  const NetSet({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NetSetState();
}

class _NetSetState extends State<NetSet> {
  Timer? timer;
  netDatas netdata = netDatas(
      //连接模式
      ethernetConnectMode: '',
      //仅以太网
      ethernetConnectOnly: '',
      //MTU
      ethernetMtu: '',
      //检测服务器
      ethernetDetectServer: '');
  //连接模式
  String showVal = '动态ip';
  int val = 0;
  //优先级
  String priorityVal = '以太网';
  int priorityIndex = 0;
  bool isCheck = true;
  final TextEditingController mtu = TextEditingController();
  final TextEditingController server = TextEditingController();
  final TextEditingController ipVal1 = TextEditingController();
  final TextEditingController ipVal2 = TextEditingController();
  final TextEditingController ipVal3 = TextEditingController();
  final TextEditingController ipVal4 = TextEditingController();
  final TextEditingController zwVal1 = TextEditingController();
  final TextEditingController zwVal2 = TextEditingController();
  final TextEditingController zwVal3 = TextEditingController();
  final TextEditingController zwVal4 = TextEditingController();
  final TextEditingController mrwgVal1 = TextEditingController();
  final TextEditingController mrwgVal2 = TextEditingController();
  final TextEditingController mrwgVal3 = TextEditingController();
  final TextEditingController mrwgVal4 = TextEditingController();
  final TextEditingController zdnsVal1 = TextEditingController();
  final TextEditingController zdnsVal2 = TextEditingController();
  final TextEditingController zdnsVal3 = TextEditingController();
  final TextEditingController zdnsVal4 = TextEditingController();
  final TextEditingController fDNSVal1 = TextEditingController();
  final TextEditingController fDNSVal2 = TextEditingController();
  final TextEditingController fDNSVal3 = TextEditingController();
  final TextEditingController fDNSVal4 = TextEditingController();
  @override
  void initState() {
    super.initState();
    getData();
    timer = Timer.periodic(const Duration(milliseconds: 2000), (t) async {});
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
    timer = null;
  }

  // 点击空白  关闭键盘 时传的一个对象
  FocusNode blankNode = FocusNode();

  /// 点击空白  关闭输入键盘
  void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(blankNode);
  }

  //保存
  void handleSave(params) async {
    Map<String, dynamic> data = {
      'method': 'obj_set',
      'param': params,
    };
    XHttp.get('/data.html', data).then((res) {
      try {
        ToastUtils.toast('修改成功');
      } on FormatException catch (e) {
        print(e);
      }
    }).catchError((onError) {
      debugPrint('失败：${onError.toString()}');
      ToastUtils.toast('修改失败');
    });
  }

  //读取
  void getData() async {
    Map<String, dynamic> data = {
      'method': 'obj_get',
      'param':
          '["ethernetConnectMode","ethernetConnectOnly","ethernetConnectPriority","ethernetIp","ethernetMask","ethernetDefaultGateway","ethernetPrimaryDns","ethernetSecondaryDns","ethernetMtu","ethernetDetectServer","systemCurrentPlatform","wifiEzmeshEnable"]',
    };
    try {
      var response = await XHttp.get('/data.html', data);
      var d = json.decode(response.toString());
      setState(() {
        netdata = netDatas.fromJson(d);
        //连接模式
        switch (netdata.ethernetConnectMode.toString()) {
          case 'dhcp':
            showVal = '动态ip';
            break;
          // case 'FR':
          //   showVal = '静态IP';
          //   break;
          case 'lanonly':
            showVal = '仅LAN';
            break;
        }

        //仅以太网
        isCheck = netdata.ethernetConnectOnly.toString() == '1' ? true : false;
        //优先级 == '1' 4g
        priorityVal =
            netdata.ethernetConnectPriority.toString() == '1' ? '4G/5G' : '以太网';
        priorityIndex = ['以太网', '4G/5G'].indexOf(priorityVal);
        //mtu
        mtu.text = netdata.ethernetMtu.toString();
        //检测服务器
        server.text = netdata.ethernetDetectServer.toString();
      });
    } catch (e) {
      debugPrint('获取以太网设置失败：$e.toString()');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppbar(context: context, title: '以太网设置'),
        body: GestureDetector(
          onTap: () => closeKeyboard(context),
          behavior: HitTestBehavior.opaque,
          child: Container(
            padding: EdgeInsets.all(20.w),
            decoration:
                const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
            height: 2000.h,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const TitleWidger(title: '设置'),
                  InfoBox(
                      boxCotainer: Column(
                    children: [
                      //连接模式
                      GestureDetector(
                        onTap: () {
                          closeKeyboard(context);
                          var result = CommonPicker.showPicker(
                            context: context,
                            options: ['动态ip', '静态ip', '仅LAN'],
                            value: val,
                          );
                          result?.then((selectedValue) => {
                                if (val != selectedValue &&
                                    selectedValue != null)
                                  {
                                    setState(() => {
                                          val = selectedValue,
                                          showVal =
                                              ['动态ip', '静态ip', '仅LAN'][val],
                                        })
                                  }
                              });
                        },
                        child: BottomLine(
                          rowtem: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('连接模式',
                                  style: TextStyle(
                                      color: const Color.fromARGB(255, 5, 0, 0),
                                      fontSize: 28.sp)),
                              Row(
                                children: [
                                  Text(showVal,
                                      style: const TextStyle(
                                          color: Color.fromARGB(255, 5, 0, 0),
                                          fontSize: 14)),
                                  Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    color:
                                        const Color.fromRGBO(144, 147, 153, 1),
                                    size: 30.w,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      //仅以太网
                      Offstage(
                        offstage: showVal == '仅LAN',
                        child: BottomLine(
                          rowtem: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('仅以太网',
                                  style: TextStyle(
                                      color: const Color.fromARGB(255, 5, 0, 0),
                                      fontSize: 28.sp)),
                              Row(
                                children: [
                                  Switch(
                                    value: isCheck,
                                    onChanged: (newVal) {
                                      setState(() {
                                        isCheck = newVal;
                                      });
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      //优先级
                      Offstage(
                        offstage: isCheck || showVal == '仅LAN',
                        child: GestureDetector(
                          onTap: () {
                            closeKeyboard(context);
                            var result = CommonPicker.showPicker(
                              context: context,
                              options: ['以太网', '4G/5G'],
                              value: priorityIndex,
                            );
                            result?.then((selectedValue) => {
                                  if (priorityIndex != selectedValue &&
                                      selectedValue != null)
                                    {
                                      setState(() => {
                                            priorityIndex = selectedValue,
                                            priorityVal =
                                                ['以太网', '4G/5G'][priorityIndex],
                                          })
                                    }
                                });
                          },
                          child: BottomLine(
                            rowtem: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('优先级',
                                    style: TextStyle(
                                        color:
                                            const Color.fromARGB(255, 5, 0, 0),
                                        fontSize: 28.sp)),
                                Row(
                                  children: [
                                    Text(priorityVal,
                                        style: const TextStyle(
                                            color: Color.fromARGB(255, 5, 0, 0),
                                            fontSize: 14)),
                                    Icon(
                                      Icons.arrow_forward_ios_outlined,
                                      color: const Color.fromRGBO(
                                          144, 147, 153, 1),
                                      size: 30.w,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      //--------------
                      //IP地址
                      Offstage(
                        offstage: showVal != '静态ip',
                        child: BottomLine(
                          rowtem: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Text(
                                'IP地址',
                              ),
                              OtpInput(ipVal1, false),
                              const Text('.'),
                              OtpInput(ipVal2, false),
                              const Text('.'),
                              OtpInput(ipVal3, false),
                              const Text('.'),
                              OtpInput(ipVal4, false),
                              const Text(
                                '*',
                                style: TextStyle(color: Colors.red),
                              )
                            ],
                          ),
                        ),
                      ),
                      //子网掩码
                      Offstage(
                        offstage: showVal != '静态ip',
                        child: BottomLine(
                          rowtem: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Text('子网掩码'),
                              OtpInput(zwVal1, false),
                              const Text('.'),
                              OtpInput(zwVal2, false),
                              const Text('.'),
                              OtpInput(zwVal3, false),
                              const Text('.'),
                              OtpInput(zwVal4, false),
                              const Text(
                                '*',
                                style: TextStyle(color: Colors.red),
                              )
                            ],
                          ),
                        ),
                      ),
                      //默认网关
                      Offstage(
                        offstage: showVal != '静态ip',
                        child: BottomLine(
                          rowtem: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Text('默认网关'),
                              OtpInput(mrwgVal1, false),
                              const Text('.'),
                              OtpInput(mrwgVal2, false),
                              const Text('.'),
                              OtpInput(mrwgVal3, false),
                              const Text('.'),
                              OtpInput(mrwgVal4, false),
                              const Text(
                                '*',
                                style: TextStyle(color: Colors.red),
                              )
                            ],
                          ),
                        ),
                      ),
                      //主DNS
                      Offstage(
                        offstage: showVal != '静态ip',
                        child: BottomLine(
                          rowtem: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Text('主DNS'),
                              OtpInput(zdnsVal1, false),
                              const Text('.'),
                              OtpInput(zdnsVal2, false),
                              const Text('.'),
                              OtpInput(zdnsVal3, false),
                              const Text('.'),
                              OtpInput(zdnsVal4, false),
                              const Text(
                                '*',
                                style: TextStyle(color: Colors.red),
                              )
                            ],
                          ),
                        ),
                      ),
                      //辅DNS
                      Offstage(
                        offstage: showVal != '静态ip',
                        child: BottomLine(
                          rowtem: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Text('辅DNS'),
                              OtpInput(fDNSVal1, false),
                              const Text('.'),
                              OtpInput(fDNSVal2, false),
                              const Text('.'),
                              OtpInput(fDNSVal3, false),
                              const Text('.'),
                              OtpInput(fDNSVal4, false),
                              const Text(
                                '*',
                                style: TextStyle(color: Colors.red),
                              )
                            ],
                          ),
                        ),
                      ),
                      //--------------
                      //MTU
                      Offstage(
                        offstage: showVal == '仅LAN',
                        child: BottomLine(
                          rowtem: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('MTU',
                                  style: TextStyle(
                                      color: const Color.fromARGB(255, 5, 0, 0),
                                      fontSize: 28.sp)),
                              SizedBox(
                                width: 100.w,
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  maxLength: 4,
                                  controller: mtu,
                                  style: TextStyle(
                                      fontSize: 26.sp,
                                      color: const Color(0xff051220)),
                                  decoration: InputDecoration(
                                    hintText: "输入MTU",
                                    hintStyle: TextStyle(
                                        fontSize: 26.sp,
                                        color: const Color(0xff737A83)),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      //检测服务器
                      Offstage(
                        offstage: showVal == '仅LAN',
                        child: BottomLine(
                          rowtem: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('检测服务器',
                                  style: TextStyle(
                                      color: const Color.fromARGB(255, 5, 0, 0),
                                      fontSize: 28.sp)),
                              SizedBox(
                                width: 100.w,
                                child: TextFormField(
                                  controller: server,
                                  maxLength: 6,
                                  style: TextStyle(
                                      fontSize: 26.sp,
                                      color: const Color(0xff051220)),
                                  decoration: InputDecoration(
                                    hintText: "输入检测服务器",
                                    hintStyle: TextStyle(
                                        fontSize: 26.sp,
                                        color: const Color(0xff737A83)),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      //提交
                      Padding(
                        padding: const EdgeInsets.only(top: 50.0),
                        child: Row(
                          children: [
                            SizedBox(
                              height: 70.sp,
                              width: 650.sp,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        const Color.fromARGB(
                                            255, 48, 118, 250))),
                                onPressed: () {
                                  //对话框
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                            title: const Text("提示"),
                                            content:
                                                const Text("提交后设备将会重启，是否继续?"),
                                            actions: <Widget>[
                                              TextButton(
                                                child: const Text("取消"),
                                                onPressed: () {
                                                  //取消
                                                  Navigator.pop(
                                                      context, 'Cancle');
                                                },
                                              ),
                                              TextButton(
                                                  child: const Text("确定"),
                                                  onPressed: () {
                                                    //确定
                                                    Navigator.pop(
                                                        context, "Ok");
                                                    // Navigator.push(context, DialogRouter(LoadingDialog()));
                                                  })
                                            ]);
                                      });
                                  //携带优先级
                                  // if (isCheck) {
                                  //   if (showVal == '动态ip') {
                                  //     handleSave(
                                  //         '{"ethernetConnectMode":"dhcp","ethernetMtu":"${mtu.text}","ethernetConnectOnly":"${isCheck ? 1 : 0}","ethernetDetectServer":"${server.text}"},"ethernetConnectPriority":"1"');
                                  //   } else if (showVal == '动态ip') {
                                  //     print(1);
                                  //   } else {
                                  //     handleSave({
                                  //       "ethernetConnectMode": "lanonly",
                                  //       "ethernetConnectOnly": "1"
                                  //     });
                                  //   }
                                  // }
                                  // //无优先级
                                  // else {
                                  //   if (showVal == '动态ip') {
                                  //     handleSave(
                                  //         '{"ethernetConnectMode":"dhcp","ethernetMtu":"${mtu.text}","ethernetConnectOnly":"${isCheck ? 1 : 0}","ethernetDetectServer":"${server.text}"},"ethernetConnectPriority":"1"');
                                  //   } else if (showVal == '动态ip') {
                                  //     print(2);
                                  //   } else {
                                  //     handleSave({
                                  //       "ethernetConnectMode": "lanonly",
                                  //       "ethernetConnectOnly": "1"
                                  //     });
                                  //   }
                                  // }
                                },
                                child: Text(
                                  '提交',
                                  style: TextStyle(fontSize: 36.sp),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  )),
                ],
              ),
            ),
          ),
        ));
  }
}

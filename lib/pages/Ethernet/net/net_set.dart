import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import 'package:flutter_template/core/widget/common_picker.dart';
import 'package:flutter_template/pages/Ethernet/net/net_datas.dart';
import '../../../core/widget/custom_app_bar.dart';

/// 以太网设置
class NetSet extends StatefulWidget {
  const NetSet({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NetSetState();
}

class _NetSetState extends State<NetSet> {
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
  bool isCheck = true;
  final TextEditingController mtu = TextEditingController();
  final TextEditingController server = TextEditingController();
  @override
  void initState() {
    super.initState();
    getData();
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
      // 'param':'{"ethernetConnectMode":"lanonly","ethernetConnectOnly":"1"}'
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
        //mtu
        mtu.text = netdata.ethernetMtu.toString();
        //检测服务器
        server.text = netdata.ethernetDetectServer.toString();
        //连接模式
        switch (netdata.ethernetConnectMode.toString()) {
          case 'dhcp':
            showVal = '动态ip';
            break;
          // case 'FR':
          //   showVal = '静态IP';
          //   break;
          // case 'RU':
          //   showVal = '仅LAN';
          //   break;

        }
        //仅以太网
        isCheck = netdata.ethernetConnectOnly.toString() == '1' ? true : false;
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
                            options: ['动态ip', '静态ip', 'LAN Only'],
                            value: val,
                          );
                          result?.then((selectedValue) => {
                                if (val != selectedValue &&
                                    selectedValue != null)
                                  {
                                    setState(() => {
                                          val = selectedValue,
                                          showVal =
                                              ['动态ip', '静态ip', 'LAN Only'][val],
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
                      BottomLine(
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

                      //MTU
                      BottomLine(
                        rowtem: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('MTU',
                                style: TextStyle(
                                    color: const Color.fromARGB(255, 5, 0, 0),
                                    fontSize: 28.sp)),
                            SizedBox(
                              width: 300.w,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
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
                      //检测服务器
                      BottomLine(
                        rowtem: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('检测服务器',
                                style: TextStyle(
                                    color: const Color.fromARGB(255, 5, 0, 0),
                                    fontSize: 28.sp)),
                            SizedBox(
                              width: 300.w,
                              child: TextFormField(
                                controller: server,
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
                                  if (showVal == '动态ip') {
                                    // handleSave(params:'1');
// '{"ethernetConnectMode":"${showVal == '动态ip' ? 'dchp' : '3' == '静态ip' ? '3' : '3'}","ethernetMtu":"${mtu.text}","ethernetConnectOnly":"${isCheck ? 1 : 0}","ethernetDetectServer":"${server.text}"}'
                                  }
                                  print(
                                      '{"ethernetConnectMode":"${showVal == '动态ip' ? 'dchp' : '3' == '静态ip' ? '3' : '3'}","ethernetMtu":"${mtu.text}","ethernetConnectOnly":"${isCheck ? 1 : 0}","ethernetDetectServer":"${server.text}"}');
                                },
                                child: Text(
                                  '提交',
                                  style: TextStyle(fontSize: 36.sp),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )),
                ],
              ),
            ),
          ),
        ));
  }
}

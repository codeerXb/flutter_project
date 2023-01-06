import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import 'package:flutter_template/core/widget/common_picker.dart';
import 'package:flutter_template/core/widget/common_widget.dart';
import 'package:flutter_template/pages/Ethernet/net/net_datas.dart';
import 'package:get/get.dart';
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
  String showVal = '动态ip';
  int val = 0;
  bool isCheck = true;
  String mtuVal = '请输入MTU值';
  String serVal = '请输入检测服务器值';
  @override
  void initState() {
    super.initState();
    getData();
  }

  //保存
  void handleSave() async {
    Map<String, dynamic> data = {
      'method': 'obj_set',
      'param': '{"wifi5gRegionCountry":$val}',
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
        mtuVal = netdata.ethernetMtu.toString();
        serVal = netdata.ethernetDetectServer.toString();
        //连接模式
        switch (netdata.ethernetConnectMode.toString()) {
          case 'dhcp':
            showVal = '动态IP';
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
        body: Container(
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
                    BottomLine(
                      rowtem: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('连接模式',
                              style: TextStyle(
                                  color: const Color.fromARGB(255, 5, 0, 0),
                                  fontSize: 28.sp)),
                          GestureDetector(
                            onTap: () {
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
                                              showVal = [
                                                '动态ip',
                                                '静态ip',
                                                'LAN Only'
                                              ][val]
                                            })
                                      }
                                  });
                            },
                            child: Row(
                              children: [
                                Text(showVal,
                                    style: const TextStyle(
                                        color: Color.fromARGB(255, 5, 0, 0),
                                        fontSize: 14)),
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
                      rowtem: CommonWidget.simpleWidgetWithUserDetail("MTU",
                          value: mtuVal, callBack: () {
                         Get.toNamed("/input_mtu",arguments:mtuVal);
                      }),
                    ),
                    //检测服务器
                    BottomLine(
                      rowtem: CommonWidget.simpleWidgetWithUserDetail("检测服务器",
                          value: serVal, callBack: () {
                       Get.toNamed("/input_server",arguments:serVal);
                      }),
                    ),
                  ],
                )),
              ],
            ),
          ),
        ));
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import 'package:flutter_template/pages/Ethernet/netType_datas.dart';
import 'package:intl/intl.dart';
import '../../core/widget/custom_app_bar.dart';

/// 以太网状态
class NetType extends StatefulWidget {
  const NetType({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NetTypeState();
}

class _NetTypeState extends State<NetType> {
  NetTypeDatas NetTypeData = NetTypeDatas(
    ethernetConnectMode: '',
    ethernetLinkStatus: '',
    ethernetConnectionStatus: '',
    systemOnlineTime: '',
    ethernetConnectionIp: '',
    ethernetConnectionMask: '',
    ethernetConnectionGateway: '',
    ethernetConnectionDns1: '',
    ethernetConnectionDns2: '',
  );
  @override
  void initState() {
    super.initState();
    getNetType();
  }

  void getNetType() async {
    Map<String, dynamic> data = {
      'method': 'obj_get',
      'param':
          '["ethernetConnectMode","ethernetLinkStatus","ethernetConnectionStatus","systemOnlineTime","ethernetConnectionIp","ethernetConnectionMask","ethernetConnectionGateway","ethernetConnectionDns1","ethernetConnectionDns2"]',
    };
    try {
      var response = await XHttp.get('/data.html', data);
      var d = json.decode(response.toString());
      setState(() {
        NetTypeData = NetTypeDatas.fromJson(d);
      });
    } catch (e) {
      debugPrint('获取以太网状态失败：$e.toString()');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context: context, title: '以太网状态'),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        decoration:
            const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //1系统信息
            const TitleWidger(title: '状态'),
            InfoBox(
              boxCotainer: Column(
                children: [
                  BottomLine(
                      rowtem: RowContainer(
                    leftText: '连接模式',
                    righText:
                        NetTypeData.ethernetConnectMode.toString() == 'dhcp'
                            ? '动态 IP'
                            : '非动态 IP',
                  )),
                  BottomLine(
                      rowtem: RowContainer(
                    leftText: '链接状态',
                    righText:
                        NetTypeData.ethernetConnectionStatus.toString() == '1'
                            ? '已连接'
                            : '未连接',
                  )),
                  BottomLine(
                      rowtem: RowContainer(
                    leftText: '连接状态',
                    righText: NetTypeData.ethernetLinkStatus.toString() == '1'
                        ? '已连接'
                        : '未连接',
                  )),
                  BottomLine(
                      rowtem: RowContainer(
                    leftText: '在线时间',
                    righText: DateFormat("dd天HH小时mm分钟").format(
                        DateTime.fromMillisecondsSinceEpoch(int.parse(
                                NetTypeData.systemOnlineTime.toString() +
                                    '000') -
                            86400000)),
                  )),
                  BottomLine(
                      rowtem: RowContainer(
                    leftText: 'IP地址',
                    righText: NetTypeData.ethernetConnectionIp.toString(),
                  )),
                  BottomLine(
                      rowtem: RowContainer(
                    leftText: '子网掩码',
                    righText: NetTypeData.ethernetConnectionMask.toString(),
                  )),
                  BottomLine(
                      rowtem: RowContainer(
                    leftText: '默认网关',
                    righText: NetTypeData.ethernetConnectionGateway.toString(),
                  )),
                  BottomLine(
                      rowtem: RowContainer(
                    leftText: '主DNS',
                    righText: NetTypeData.ethernetConnectionDns1.toString(),
                  )),
                  Container(
                    padding: EdgeInsets.only(top: 20.w),
                    child: RowContainer(
                      leftText: '辅DNS',
                      righText: NetTypeData.ethernetConnectionDns2.toString(),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

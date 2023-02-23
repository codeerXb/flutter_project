import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import 'package:flutter_template/pages/Ethernet/netType_datas.dart';
import 'package:intl/intl.dart';
import '../../core/widget/custom_app_bar.dart';
import '../../generated/l10n.dart';

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
  int day = 0;
  int hour = 0;
  int min = 0;
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
        var time = int.parse(NetTypeData.systemOnlineTime.toString());
        day = time ~/ (24 * 3600);
        hour = (time - day * 24 * 3600) ~/ 3600;
        min = (time - day * 24 * 3600 - hour * 3600) ~/ 60;
      });
    } catch (e) {
      debugPrint('获取以太网状态失败：$e.toString()');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          customAppbar(context: context, title: S.of(context).EthernetStatus),
      body: SingleChildScrollView(
        child: Container(
          decoration:
              const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
          height: 1400.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //1系统信息
              TitleWidger(title: S.of(context).status),
              InfoBox(
                boxCotainer: Column(
                  children: [
                    BottomLine(
                        rowtem: RowContainer(
                      leftText: S.of(context).connectionMode,
                      righText:
                          NetTypeData.ethernetConnectMode.toString() == 'dhcp'
                              ? S.current.DynamicIP
                              : S.current.staticIP,
                    )),
                    BottomLine(
                        rowtem: RowContainer(
                      leftText: S.of(context).linkStatus,
                      righText:
                          NetTypeData.ethernetConnectionStatus.toString() == '1'
                              ? S.current.Connected
                              : S.current.ununited,
                    )),
                    BottomLine(
                        rowtem: RowContainer(
                      leftText: S.of(context).connectStatus,
                      righText: NetTypeData.ethernetLinkStatus.toString() == '1'
                          ? S.current.Connected
                          : S.current.ununited,
                    )),
                    BottomLine(
                        rowtem: RowContainer(
                      leftText: S.of(context).OnlineTime,
                      righText: day.toString() +
                          S.of(context).date +
                          hour.toString() +
                          S.of(context).hour +
                          min.toString() +
                          S.of(context).minute,
                    )),
                    BottomLine(
                        rowtem: RowContainer(
                      leftText: S.of(context).IPAddress,
                      righText: NetTypeData.ethernetConnectionIp.toString(),
                    )),
                    BottomLine(
                        rowtem: RowContainer(
                      leftText: S.of(context).SubnetMask,
                      righText: NetTypeData.ethernetConnectionMask.toString(),
                    )),
                    BottomLine(
                        rowtem: RowContainer(
                      leftText: S.of(context).DefaultGateway,
                      righText:
                          NetTypeData.ethernetConnectionGateway.toString(),
                    )),
                    BottomLine(
                        rowtem: RowContainer(
                      leftText: S.of(context).PrimaryDNS,
                      righText: NetTypeData.ethernetConnectionDns1.toString(),
                    )),
                    BottomLine(
                      rowtem: RowContainer(
                        leftText: S.of(context).SecondaryDNS,
                        righText: NetTypeData.ethernetConnectionDns2.toString(),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

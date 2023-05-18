import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/request/request.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import 'package:flutter_template/pages/Ethernet/netType_datas.dart';
import 'package:flutter_template/pages/login/login_controller.dart';
import 'package:get/get.dart';
import '../../core/widget/custom_app_bar.dart';
import '../../generated/l10n.dart';

/// 以太网状态
class NetType extends StatefulWidget {
  const NetType({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NetTypeState();
}

class _NetTypeState extends State<NetType> {
  final LoginController loginController = Get.put(LoginController());

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
  String sn = '';
  String connectionModeValue = '';
  String linkStatusValue = '';
  String connectStatusValue = '';
  String onlineTimeValue = '';
  String iPAddressValue = '';
  String subnetMaskValue = '';
  String defaultGatewayValue = '';
  String primaryDNSValue = '';
  String secondaryDNSValue = '';

  @override
  void initState() {
    super.initState();
    sharedGetData('deviceSn', String).then(((res) {
      printInfo(info: 'deviceSn$res');
      setState(() {
        sn = res.toString();
        //状态为local 请求本地  状态为cloud  请求云端
        if (loginController.login.state == 'cloud' && sn.isNotEmpty) {
          getTRNetDatas();
        }
        if (loginController.login.state == 'local') {
          getNetType();
        }
      });
    }));
  }

  bool loading = false;

  void getNetType() async {
    setState(() {
      loading = true;
    });
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
        connectionModeValue = NetTypeData.ethernetConnectMode.toString();
        linkStatusValue = NetTypeData.ethernetConnectionStatus.toString();
        connectStatusValue = NetTypeData.ethernetLinkStatus.toString();
        onlineTimeValue = day.toString() +
            S.of(context).date +
            hour.toString() +
            S.of(context).hour +
            min.toString() +
            S.of(context).minute;
        iPAddressValue = NetTypeData.ethernetConnectionIp.toString();
        subnetMaskValue = NetTypeData.ethernetConnectionMask.toString();
        defaultGatewayValue = NetTypeData.ethernetConnectionGateway.toString();
        primaryDNSValue = NetTypeData.ethernetConnectionDns1.toString();
        secondaryDNSValue = NetTypeData.ethernetConnectionDns2.toString();
      });
    } catch (e) {
      Get.back();
      debugPrint('获取以太网状态失败：$e.toString()');
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

// 云端
  getTRNetDatas() async {
    setState(() {
      loading = true;
    });
    // Navigator.push(context, DialogRouter(LoadingDialog()));
    try {
      var parameterNames = [
        "InternetGatewayDevice.WANDevice.1.WANConnectionDevice.1.WANIPConnection.1.AddressingType",
        "InternetGatewayDevice.WEB_GUI.Ethernet.Status.LinkStatus",
        "InternetGatewayDevice.WEB_GUI.Ethernet.Status.ConnectStatus",
        "InternetGatewayDevice.WEB_GUI.Overview.SystemInfo.OnlineTime",
        "InternetGatewayDevice.WANDevice.1.WANConnectionDevice.1.WANIPConnection.1.ExternalIPAddress",
        "InternetGatewayDevice.WANDevice.1.WANConnectionDevice.1.WANIPConnection.1.SubnetMask",
        "InternetGatewayDevice.WANDevice.1.WANConnectionDevice.1.WANIPConnection.1.DefaultGateway",
        "InternetGatewayDevice.WANDevice.1.WANConnectionDevice.1.WANIPConnection.1.DNSServers",
      ];
      var res = await Request().getACSNode(parameterNames, sn);
      Map<String, dynamic> d = jsonDecode(res);
      setState(() {
        var PREFIX = d['data']['InternetGatewayDevice']['WANDevice']['1']
            ['WANConnectionDevice']['1']['WANIPConnection']['1'];

        var addressingType = PREFIX['AddressingType']['_value'];
        if (addressingType == 'dhcp') {
          connectionModeValue = 'Dynamic IP';
        } else if (addressingType == 'static') {
          connectionModeValue = 'Static IP';
        } else {
          connectionModeValue = 'Only LAN';
        }

        iPAddressValue = PREFIX["ExternalIPAddress"]["_value"];
        subnetMaskValue = PREFIX["SubnetMask"]["_value"];

        defaultGatewayValue = PREFIX["DefaultGateway"]["_value"];

        var dNSServers = PREFIX["DNSServers"]["_value"];
        primaryDNSValue = dNSServers.split(',')[0];
        secondaryDNSValue = dNSServers.split(',')[1];

        var PREFIX1 =
            d["data"]["InternetGatewayDevice"]["WEB_GUI"]["Ethernet"]["Status"];

        var linkStatus = PREFIX['AddressingType']['_value'];
        if (linkStatus == '1') {
          linkStatusValue = 'Connected';
        } else {
          linkStatusValue = 'Disconnected';
        }

        var connectStatus = PREFIX['AddressingType']['_value'];
        if (connectStatus == '1') {
          connectStatusValue = 'Connected';
        } else {
          connectStatusValue = 'Disconnected';
        }

        var onlineTime = d["data"]["InternetGatewayDevice"]["WEB_GUI"]
            ["Overview"]["SystemInfo"]["OnlineTime"]["_value"];
        var time = int.parse(onlineTime.toString());
        day = time ~/ (24 * 3600);
        hour = (time - day * 24 * 3600) ~/ 3600;
        min = (time - day * 24 * 3600 - hour * 3600) ~/ 60;

        onlineTimeValue = day.toString() +
            S.of(context).date +
            hour.toString() +
            S.of(context).hour +
            min.toString() +
            S.of(context).minute;
      });
    } catch (e) {
      ToastUtils.error('Request Failed');
      Get.back();
      debugPrint('获取以太网信息失败：${e.toString()}');
    } finally {
      setState(() {
        loading = false;
      });
    }
    // Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          customAppbar(context: context, title: S.of(context).EthernetStatus),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(240, 240, 240, 1)),
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
                            righText: connectionModeValue,
                          )),
                          BottomLine(
                              rowtem: RowContainer(
                            leftText: S.of(context).linkStatus,
                            righText: linkStatusValue,
                          )),
                          BottomLine(
                              rowtem: RowContainer(
                            leftText: S.of(context).connectStatus,
                            righText: connectStatusValue,
                          )),
                          BottomLine(
                              rowtem: RowContainer(
                            leftText: S.of(context).OnlineTime,
                            righText: onlineTimeValue,
                          )),
                          BottomLine(
                              rowtem: RowContainer(
                            leftText: S.of(context).IPAddress,
                            righText: iPAddressValue,
                          )),
                          BottomLine(
                              rowtem: RowContainer(
                            leftText: S.of(context).SubnetMask,
                            righText: subnetMaskValue,
                          )),
                          BottomLine(
                              rowtem: RowContainer(
                            leftText: S.of(context).DefaultGateway,
                            righText: defaultGatewayValue,
                          )),
                          BottomLine(
                              rowtem: RowContainer(
                            leftText: S.of(context).PrimaryDNS,
                            righText: primaryDNSValue,
                          )),
                          BottomLine(
                            rowtem: RowContainer(
                              leftText: S.of(context).SecondaryDNS,
                              righText: secondaryDNSValue,
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

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/request/request.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import 'package:flutter_template/core/widget/water_loading.dart';
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
    // networkWanSettingsConnectMode,ethernetLinkStatus,lteMainStatusGet,OnlineTime,networkWanSettingsIp,networkWanSettingsMask,networkWanSettingsGateway,networkWanSettingsDns
    var parameterNames = {
      "method": "get",
      "nodes": [
      "networkWanSettingsConnectMode",
      "ethernetLinkStatus",
      "lteMainStatusGet",
      "systemOnlineTime",
      "networkWanSettingsIp",
      "networkWanSettingsMask",
      "networkWanSettingsGateway",
      "networkWanSettingsDns",
      ]
    };
    try {
      var res = await Request().getACSNode(parameterNames, sn);
      Map<String, dynamic> d = jsonDecode(res);
      var prettyJsonString = const JsonEncoder.withIndent('  ').convert(d);
      debugPrint("获取的网路状态数据:$prettyJsonString");
      setState(() {
        // var prefix = d['data']['InternetGatewayDevice']['WANDevice']['1']
        //     ['WANConnectionDevice']['1']['WANIPConnection']['1'];
        var prefix = d['data'];
        var addressingType = prefix['networkWanSettingsConnectMode'];
        if (addressingType == 'dhcp') {
          connectionModeValue = 'Dynamic IP';
        } else if (addressingType == 'static') {
          connectionModeValue = 'Static IP';
        } else {
          connectionModeValue = 'Only LAN';
        }

        iPAddressValue = prefix["networkWanSettingsIp"];
        subnetMaskValue = prefix["networkWanSettingsMask"];

        defaultGatewayValue = prefix["networkWanSettingsGateway"];

        var dNSServers = prefix["networkWanSettingsDns"];
        primaryDNSValue = dNSServers.split('.')[0];
        secondaryDNSValue = dNSServers.split('.')[1];

        // var prefix1 =
        //     d["data"]["InternetGatewayDevice"]["WEB_GUI"]["Ethernet"]["Status"];

        String? linkStatus = prefix["ethernetLinkStatus"];
        if (linkStatus == '1') {
          linkStatusValue = 'Connected';
        } else {
          linkStatusValue = 'Disconnected';
        }

        var connectStatus = prefix["lteMainStatusGet"];
        if (connectStatus == 'connected') {
          connectStatusValue = 'Connected';
        } else {
          connectStatusValue = 'Disconnected';
        }

        String? onlineTime = prefix["systemOnlineTime"];
        if (onlineTime != "") {
        var time = int.parse(onlineTime.toString());
        day = time ~/ (24 * 3600);
        hour = (time - day * 24 * 3600) ~/ 3600;
        min = (time - day * 24 * 3600 - hour * 3600) ~/ 60;
        }else {
          day = 0;
          hour = 0;
          min = 0;
        }
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
          ? const Center(
              child: SizedBox(
                height: 80,
                width: 80,
                child: WaterLoading(
                  color: Color.fromARGB(255, 65, 167, 251),
                ),
              ),
            )
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

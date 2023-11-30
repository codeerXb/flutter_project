import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/request/request.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import 'package:flutter_template/core/widget/water_loading.dart';
import 'package:flutter_template/pages/Ethernet/net/wan_status_bean.dart';
import 'package:flutter_template/pages/Ethernet/net/wan_status_table_bean.dart';
import 'package:flutter_template/pages/login/login_controller.dart';
import 'package:get/get.dart';
import '../../../core/widget/custom_app_bar.dart';
import '../../../generated/l10n.dart';

class WanStatusPage extends StatefulWidget {
  const WanStatusPage({super.key});

  @override
  State<WanStatusPage> createState() => _WanStatusPageState();
}

class _WanStatusPageState extends State<WanStatusPage> {
  final LoginController loginController = Get.put(LoginController());
  int day = 0;
  int hour = 0;
  int min = 0;
  String sn = '';
  bool loading = false;

  String wan_status = "true";
  String upTimeValue = '';
  String connectStatusValue = '';
  String macAddressValue =  '';
  String downStreamValue =  '';
  String upStreamValue =  '';
  String byteRevValue =  '';
  String byteSentValue =  '';
  String packetRevValue =  '';
  String packetSentValue =  '';
  
  @override
  void initState() {
    super.initState();
    sharedGetData('deviceSn', String).then(((res) {
      printInfo(info: 'deviceSn--$res');
      setState(() {
        sn = res.toString();
        //状态为local 请求本地  状态为cloud  请求云端
        if (loginController.login.state == 'cloud' && sn.isNotEmpty) {
          getTRNetDatas();
        }
      });
    }));
  }

// 云端
  getTRNetDatas() async {
    setState(() {
      loading = true;
    });

    var parameterNames = {
      "method": "get",
      "nodes": [
        "networkWanSettingsConnectMode",
        'networkWanSettingsMac',
        "ethernetLinkStatus",
        "lteMainStatusGet",
        "systemOnlineTime",
        "networkWanSettingsIp",
        "networkWanSettingsMask",
        "networkWanSettingsGateway",
        "networkWanSettingsDns",
        'networkWanSettingsInterface',
        'systemDataRateUlCurrent',
        'systemDataRateDlCurrent',
        'lteDefaultGateway',
      ]
    };

    var params = {"method": "get", "table": "FlowTable"};

    try {
      var res = await Request().getSODTable(params, sn);
      var jsonObj = jsonDecode(res);
      // 格式化JSON字符串
      var tableJsonString = const JsonEncoder.withIndent('  ').convert(jsonObj);
      // 输出格式化的JSON字符串
      debugPrint("wan_status:格式化数据输出:$tableJsonString");

      var model = Wan_status_table_bean.fromJson(jsonObj);

      var result = await Request().getACSNode(parameterNames, sn);
      Map<String, dynamic> dict = jsonDecode(result);
      var nodeJsonString = const JsonEncoder.withIndent('  ').convert(dict);
      debugPrint("获取的网路状态数据:$nodeJsonString");
      var nodeModel = wan_status_bean.fromJson(dict);

      setState(() {

        int index = int.parse(nodeModel.data!.lteDefaultGateway!);
        debugPrint("表的索引是:$index");

        String resvStr = model.data![index].recvBytes! == "" ? "0" : model.data![index].recvBytes!;
        String sentStr = model.data![index].sendBytes! == "" ? "0" : model.data![index].sendBytes!;
        double resvBy = double.parse(resvStr);
        double resRateB = resvBy / (1000 * 1000);
        debugPrint("接收速率1是:$resRateB");
        String resSpeed = resRateB.toStringAsFixed(2);
        byteRevValue = "$resSpeed B";

        double sendBy = double.parse(sentStr);
        double sendRateB = sendBy / (1000 * 1000);
        debugPrint("发送速率1是:$sendRateB");
        String sendSpeed = sendRateB.toStringAsFixed(2);
        byteSentValue = "$sendSpeed B";

        String recvPacketStr = model.data![index].recvPackets! == "" ? "0" : model.data![index].recvPackets!;
        String sendPacketStr = model.data![index].sendPackets! == "" ? "0" : model.data![index].sendPackets!;
        double recvPacketBy = double.parse(recvPacketStr);
        double recvPacketB = recvPacketBy / (1000 * 1000);
        debugPrint("接收速率2是:$recvPacketB");
        String recvPacketSpeed = recvPacketB.toStringAsFixed(2);
        packetRevValue = "$recvPacketSpeed B";

        double sendPacketBy = double.parse(sendPacketStr);
        double sendPacketB = sendPacketBy / (1000 * 1000);
        debugPrint("发送速率2是:$sendPacketB");
        String sendPacketSpeed = sendPacketB.toStringAsFixed(2);
        packetSentValue = "$sendPacketSpeed B";

        double downBy = double.parse(nodeModel.data!.systemDataRateDlCurrent!);
        double rateB = downBy / (1000 * 1000);
        debugPrint("下载的速率是:$rateB");
        String downSpeed = rateB.toStringAsFixed(4);
        downStreamValue = "$downSpeed Mbps";
        double upBites = double.parse(nodeModel.data!.systemDataRateUlCurrent!);
        double upB = upBites / (1000 * 1000);
        debugPrint("上传的速率是:$upB");
        var upSpeed =  upB.toStringAsFixed(4);
        upStreamValue = "$upSpeed Mbps";

        macAddressValue = nodeModel.data!.networkWanSettingsMac!;

        var connectStatus = nodeModel.data!.lteMainStatusGet;
        if (connectStatus == 'connected') {
          connectStatusValue = 'Online';
        } else {
          connectStatusValue = 'Offline';
        }

        String? onlineTime = nodeModel.data!.systemOnlineTime;
        if (onlineTime!.isNotEmpty) {
          var time = int.parse(onlineTime.toString());
          day = time ~/ (24 * 3600);
          hour = (time - day * 24 * 3600) ~/ 3600;
          min = (time - day * 24 * 3600 - hour * 3600) ~/ 60;
        } else {
          day = 0;
          hour = 0;
          min = 0;
        }
        upTimeValue = day.toString() +
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
                            leftText: S.of(context).Enabled,
                            righText: wan_status,
                          )),
                          BottomLine(
                              rowtem: RowContainer(
                            leftText: S.of(context).UpTime,
                            righText: upTimeValue,
                          )),
                          BottomLine(
                              rowtem: RowContainer(
                            leftText: S.of(context).connectStatus,
                            righText: connectStatusValue,
                          )),
                          BottomLine(
                              rowtem: RowContainer(
                            leftText: S.of(context).MACAddress,
                            righText: macAddressValue,
                          )),
                          BottomLine(
                              rowtem: RowContainer(
                            leftText: S.of(context).DownStream,
                            righText: downStreamValue,
                          )),
                          BottomLine(
                              rowtem: RowContainer(
                            leftText: S.of(context).UpStream,
                            righText: upStreamValue,
                          )),
                          BottomLine(
                              rowtem: RowContainer(
                            leftText: S.of(context).ByteReceive,
                            righText: byteRevValue,
                          )),
                          BottomLine(
                              rowtem: RowContainer(
                            leftText: S.of(context).ByteSent,
                            righText: byteSentValue,
                          )),
                          BottomLine(
                            rowtem: RowContainer(
                              leftText: S.of(context).PacketReceive,
                              righText: packetRevValue,
                            ),
                          ),
                          BottomLine(
                            rowtem: RowContainer(
                              leftText: S.of(context).PacketSent,
                              righText: packetSentValue,
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

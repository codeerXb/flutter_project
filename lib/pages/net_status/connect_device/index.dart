import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/pages/topo/model/equipment_datas.dart';
import 'package:get/get.dart';
import '../../../config/base_config.dart';
import '../../../core/http/http_app.dart';
import '../../../core/utils/shared_preferences_util.dart';
import '../../../core/widget/custom_app_bar.dart';
import '../../../generated/l10n.dart';

//接入设备
class ConnectedDevice extends StatefulWidget {
  const ConnectedDevice({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ConnectedDeviceState();
}

String sn = '';
bool isOnline = true;
List deviceList = []; //设备列表
EquipmentDatas topoData = EquipmentDatas(onlineDeviceTable: [], max: null);

class _ConnectedDeviceState extends State<ConnectedDevice> {
  bool loading = false;

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
      List<OnlineDeviceTable>? onlineDeviceTable = [];
      int id = 0;

      d['data']['wifiDevices'].addAll(d['data']['lanDevices']);
      deviceList = d['data']['wifiDevices'];

      for (var item in deviceList) {
        OnlineDeviceTable device = OnlineDeviceTable.fromJson({
          'id': id,
          'LeaseTime': '1',
          'Type': item['connection'] ?? 'LAN',
          'HostName': item['name'],
          'IP': item['IPAddress'],
          'MAC': item['MACAddress'] ?? item['MacAddress']
        });
        onlineDeviceTable.add(device);
        id++;
      }
      topoData = EquipmentDatas(onlineDeviceTable: onlineDeviceTable, max: 255);
      // print('设备列表$deviceList');
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
        appBar: customAppbar(
            context: context,
            title: 'Devices(' + deviceList.length.toString() + ')'),
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : Container(
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(240, 240, 240, 1)),
                height: 1400.w,
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(padding: EdgeInsets.only(top: 40.w)),

                        //在线/离线
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isOnline = true;
                                  });
                                },
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        width: 2.0,
                                        color: isOnline
                                            ? const Color.fromRGBO(
                                                33, 150, 243, 1)
                                            : const Color.fromRGBO(
                                                240, 240, 240, 1),
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 12.0.w),
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Online',
                                            style: TextStyle(
                                              fontSize: 50.0.w,
                                              color: isOnline
                                                  ? const Color.fromRGBO(
                                                      33, 150, 243, 1)
                                                  : Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                '(${deviceList.length.toString()})',
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: isOnline
                                                  ? const Color.fromRGBO(
                                                      33, 150, 243, 1)
                                                  : Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isOnline = false;
                                  });
                                },
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        width: 2.0,
                                        color: !isOnline
                                            ? const Color.fromRGBO(
                                                33, 150, 243, 1)
                                            : const Color.fromRGBO(
                                                240, 240, 240, 1),
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 12.0.w),
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Offline',
                                            style: TextStyle(
                                              fontSize: 50.0.w,
                                              color: !isOnline
                                                  ? const Color.fromRGBO(
                                                      33, 150, 243, 1)
                                                  : Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: '(0)',
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: !isOnline
                                                  ? const Color.fromRGBO(
                                                      33, 150, 243, 1)
                                                  : Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )),
                          ],
                        ),

                        Padding(padding: EdgeInsets.only(top: 20.w)),

                        if (isOnline)
                          //遍历卡片
                          SizedBox(
                            height: deviceList.length * 150.w,
                            child: ListView.builder(
                              itemCount: deviceList.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Get.toNamed("/access_equipment",
                                        arguments:
                                            topoData.onlineDeviceTable![index]);
                                  },
                                  child: Card(
                                    clipBehavior: Clip.hardEdge,
                                    elevation: 5, //设置卡片阴影的深度
                                    shape: const RoundedRectangleBorder(
                                      //设置卡片圆角
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                    ),
                                    child: Container(
                                      decoration: const BoxDecoration(),
                                      child: ListTile(
                                          //图片
                                          leading: ClipOval(
                                              child: Image.asset(
                                                  'assets/images/slices.png',
                                                  fit: BoxFit.fitWidth,
                                                  width: 90.w)),
                                          //中间文字
                                          title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: SizedBox(
                                                  child:
                                                      //显示的文字
                                                      Text(
                                                    deviceList[index]['name'],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ),
                                              ),
                                              // icon
                                              IconButton(
                                                  onPressed: () {},
                                                  icon: deviceList[index]
                                                              ['connection'] ==
                                                          'LAN'
                                                      ? const Icon(
                                                          Icons.lan,
                                                          color: Color.fromRGBO(
                                                              120,
                                                              199,
                                                              197,
                                                              1.0),
                                                        )
                                                      : const Icon(
                                                          Icons.wifi,
                                                          color: Color.fromRGBO(
                                                              120,
                                                              199,
                                                              197,
                                                              1.0),
                                                        ))
                                            ],
                                          ),

                                          //title下方显示的内容
                                          subtitle: Row(
                                            children: [
                                              Text(deviceList[index]
                                                  ['connection']),
                                              Text(
                                                deviceList[index]
                                                            ['connection'] ==
                                                        'LAN'
                                                    ? '   LAN'
                                                    : '   Wi-Fi',
                                              ),
                                            ],
                                          )),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )

                        // else
                      ]),
                )));
  }
}

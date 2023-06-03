import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/pages/topo/model/equipment_datas.dart';
import 'package:get/get.dart';
import '../../../config/base_config.dart';
import '../../../core/http/http_app.dart';
import '../../../core/utils/shared_preferences_util.dart';

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

class _ConnectedDeviceState extends State<ConnectedDevice>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        title: Text(
          'Devices(${deviceList.length})',
          style: const TextStyle(color: Colors.black),
        ),
        // backgroundColor: Colors.white,
        centerTitle: true,
        systemOverlayStyle: const SystemUiOverlayStyle(
          //设置状态栏的背景颜色
          statusBarColor: Colors.transparent,
          //状态栏的文字的颜色
          statusBarIconBrightness: Brightness.dark,
        ),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
        bottom: TabBar(
          controller: _tabController,
          unselectedLabelColor: Colors.black,
          labelColor: Colors.blue,
          tabs: [
            Tab(text: 'Online(${deviceList.length.toString()})'),
            const Tab(text: 'Offline(0)'),
          ],
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: const [
                OnlinePage(),
                OfflinePage(),
              ],
            ),
    );
  }
}

class OnlinePage extends StatelessWidget {
  const OnlinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
              child: SizedBox(
            height: 1.sh - 70,
            child: ListView.builder(
              itemCount: deviceList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Get.toNamed("/access_equipment",
                        arguments: topoData.onlineDeviceTable![index]);
                  },
                  child: Card(
                    clipBehavior: Clip.hardEdge,
                    elevation: 5, //设置卡片阴影的深度
                    shape: const RoundedRectangleBorder(
                      //设置卡片圆角
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Container(
                      decoration: const BoxDecoration(),
                      child: ListTile(
                          //图片
                          leading: ClipOval(
                              child: Image.asset('assets/images/slices.png',
                                  fit: BoxFit.fitWidth, width: 90.w)),
                          //中间文字
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: SizedBox(
                                  child:
                                      //显示的文字
                                      Text(
                                    deviceList[index]['name'],
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                              // icon
                              IconButton(
                                  onPressed: () {},
                                  icon: deviceList[index]['connection'] == 'LAN'
                                      ? const Icon(
                                          Icons.lan,
                                          color: Color.fromRGBO(
                                              120, 199, 197, 1.0),
                                        )
                                      : const Icon(
                                          Icons.wifi,
                                          color: Color.fromRGBO(
                                              120, 199, 197, 1.0),
                                        ))
                            ],
                          ),

                          //title下方显示的内容
                          subtitle: Row(
                            children: [
                              Text(
                                deviceList[index].containsKey('connection')
                                    ? '${deviceList[index]['connection']}   Wi-Fi'
                                    : 'LAN',
                              ),
                            ],
                          )),
                    ),
                  ),
                );
              },
            ),
          )),
        ),
      ],
    );
  }
}

class OfflinePage extends StatelessWidget {
  const OfflinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(' ');
  }
}

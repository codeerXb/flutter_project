import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/pages/get_equipment/water_ripple_painter.dart';
import 'package:flutter_template/pages/login/model/equipment_data.dart';
import 'package:get/get.dart';

class Equipment extends StatefulWidget {
  const Equipment({super.key});

  @override
  State<Equipment> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Equipment> {
  EquipmentData equipmentData = EquipmentData();
  bool loding = true;
  @override
  void initState() {
    super.initState();
    getEquipmentData();
  }

  void getEquipmentData() {
    Map<String, dynamic> data = {
      'method': 'obj_get',
      'param':
          '["systemProductModel","systemVersionRunning","wifi5gHaveOrNot","wifiEnable","wifiCurrentChannel","wifiMode","wifiSsid","wifi5gEnable","wifi5gCurrentChannel","wifi5gMode","wifi5gSsid","lteNetwork","networkWanSettingsMode","wifiHaveOrNot","lteDefaultGateway","wifi5gHaveOrNot","systemCurrentPlatform","systemGpsSupport","systemOnlineTime","systemRunningTime","lteMainStatusGet","lteOperatorGet","lteModeGet","lteCellidGet","lteRsrp0","lteRsrp1","lteRsrq","lteSinr","lteCellidGet_5g","lteRsrp0_5g","lteRsrp1_5g","lteRsrq_5g","lteSinr_5g","networkWanSettingsIp","networkWanSettingsMask","networkIpv6WanSettingsIp","networkIpv6WanSettingsMask","systemGpsLongitude","systemGpsLatitude","systemGpsAltitude","networkWanSettingsDns","networkIpv6WanSettingsDns1","networkIpv6WanSettingsDns2"]',
    };
    loding = true;
    XHttp.get('', data).then((res) {
      loding = false;
      try {
        print("\n==================  ==========================");
        var d = json.decode(res.toString());
        setState(() {
          equipmentData = EquipmentData.fromJson(d);
        });
        print(equipmentData);
      } on FormatException catch (e) {
        setState(() {
          equipmentData = EquipmentData();
        });
        print('The provided string is not valid JSON');
        print(e);
      }
    }).catchError((onError) {
      debugPrint(onError.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('发现设备'),
        elevation: 0,
      ),
      body: Column(children: [
        Padding(
          padding: EdgeInsets.only(top: 100.w),
        ),
        Center(
            child: SizedBox(
                height: 200,
                width: 200,
                child: WaterRipple(
                  key: childKey,
                ))),
        Padding(
          padding: EdgeInsets.only(top: 100.w),
        ),
        if (loding)
          Text(
            '正在扫描',
            style: TextStyle(fontSize: 36.sp),
          ),
        if (!loding) Text('未发现设备', style: TextStyle(fontSize: 36.sp)),
        if (!loding)
          TextButton(
            onPressed: () {
              childKey.currentState!.controllerForward();
            },
            child: const Text('重新扫描'),
          ),
        TextButton(
          onPressed: () {
            Get.offNamed("/loginPage");
          },
          child: const Text('连接设备'),
        ),
        // ElevatedButton(
        //   onPressed: () {
        //     childKey.currentState!.controllerStop();
        //   },
        //   child: const Text('停止搜索'),
        // )
      ]),
    );
  }
}

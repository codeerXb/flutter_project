import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'package:flutter_template/pages/get_equipment/water_ripple_painter.dart';
import 'package:flutter_template/pages/login/login_controller.dart';
import 'package:flutter_template/pages/login/model/equipment_data.dart';
import 'package:get/get.dart';

class Equipment extends StatefulWidget {
  const Equipment({super.key});

  @override
  State<Equipment> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Equipment> {
  final LoginController loginController = Get.put(LoginController());
  EquipmentData equipmentData = EquipmentData();

  @override
  void initState() {
    super.initState();
    getEquipmentData();
  }

  void appLogin(pwd, sn, vn) {
    Map<String, dynamic> data = {
      'username': 'admin',
      'password': utf8.decode(base64Decode(pwd)),
    };
    XHttp.get('/action/appLogin', data).then((res) {
      try {
        print("+++++++++++++");

        var d = json.decode(res.toString());
        print(d['token']);
        loginController.setSession(d['sessionid']);
        sharedAddAndUpdate("session", String, d['sessionid']);

        loginController.setToken(d['token']);
        sharedAddAndUpdate("token", String, d['token']);
        Get.offNamed("/home");
        // print(d);
      } on FormatException catch (e) {
        print('----------');
        Get.offNamed("/loginPage", arguments: {"sn": sn, "vn": vn});
        print('The provided string is not valid JSON');
        print(e);
      }
    }).catchError((onError) {
      Get.offNamed("/loginPage", arguments: {"sn": sn, "vn": vn});

      debugPrint(onError.toString());
    });
  }

  void getEquipmentData() {
    Map<String, dynamic> data = {
      'method': 'obj_get',
      'param':
          '["systemProductModel","systemVersionHw","systemVersionRunning","systemVersionUboot","systemVersionSn","networkLanSettingsMac","networkLanSettingIp","networkLanSettingMask","systemRunningTime"]'
    };
    setState(() {
      equipmentData = EquipmentData(
          systemProductModel: null,
          systemVersionRunning: '',
          systemVersionSn: '');
    });
    XHttp.get('/pub/pub_data.html', data).then((res) {
      try {
        print("\n==================  ==========================");
        var d = json.decode(res.toString());
        setState(() {
          equipmentData = EquipmentData.fromJson(d);
        });

        print(equipmentData);
      } on FormatException catch (e) {
        print('The provided string is not valid JSON');
        print(e);
      }
    }).catchError((onError) {
      // debugPrint(onError.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            '发现设备',
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0,
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        ),
        body: Obx(
          () => ListView(
              padding: EdgeInsets.only(left: 20.w, right: 20.w),
              children: [
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
                if (loginController.loading.value)
                  Center(
                    child: Text(
                      '正在扫描',
                      style: TextStyle(fontSize: 36.sp),
                    ),
                  ),

                if (equipmentData == null)
                  Center(
                      child: Text('未发现设备', style: TextStyle(fontSize: 36.sp))),
                if (!loginController.loading.value)
                  TextButton(
                    onPressed: () {
                      getEquipmentData();
                      childKey.currentState!.controllerForward();
                    },
                    child: const Text('重新扫描'),
                  ),
                if (equipmentData.systemProductModel != null)
                  Card(
                    elevation: 5, //设置卡片阴影的深度
                    shape: const RoundedRectangleBorder(
                      //设置卡片圆角
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    margin: const EdgeInsets.all(10), //设置卡片外边距
                    child: Column(
                      children: [
                        ListTile(
                          leading: ClipOval(
                            //设置圆形头像
                            child: Image.network(
                                "https://www.itying.com/images/flutter/3.png",
                                fit: BoxFit.cover,
                                height: 60,
                                width: 60),
                          ),
                          title: Text(
                              '产品型号 ${equipmentData.systemProductModel.toString()}'),
                          subtitle: Text(
                              '软件版本 ${equipmentData.systemVersionRunning.toString()}'),
                          trailing: TextButton(
                            onPressed: () {
                              sharedGetData(
                                      equipmentData.systemVersionSn.toString(),
                                      String)
                                  .then((data) {
                                if (data != null) {
                                  appLogin(data, equipmentData.systemVersionSn,
                                      equipmentData.systemProductModel);
                                  loginController.setSn(
                                      equipmentData.systemVersionSn, data);
                                } else {
                                  loginController.setSn(
                                      equipmentData.systemVersionSn, 'admin');
                                  Get.offNamed("/loginPage", arguments: {
                                    "sn": equipmentData.systemVersionSn,
                                    "vn": equipmentData.systemProductModel
                                  });
                                }
                              });
                            },
                            child: const Text('连接设备'),
                          ),
                        ),
                      ],
                    ),
                  )

                // ElevatedButton(
                //   onPressed: () {
                //     childKey.currentState!.controllerStop();
                //   },
                //   child: const Text('停止搜索'),
                // )
              ]),
        ));
  }
}
